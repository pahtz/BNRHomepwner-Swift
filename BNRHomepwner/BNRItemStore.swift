//
//  BNRItemStore.swift
//  BNRHomepwner
//
//  Created by Paul Yu on 26/6/14.
//  Copyright (c) 2014 Paul Yu. All rights reserved.
//

// Swift singleton pattern from https://github.com/hpique/SwiftSingleton

import UIKit
import CoreData

class BNRItemStore: NSObject {
    
    var privateItems : NSMutableArray?
    var allAssetTypes : NSMutableArray?
    var context : NSManagedObjectContext?
    var model : NSManagedObjectModel?
    
    class var sharedStore : BNRItemStore {
    struct Static {
        static let instance : BNRItemStore = BNRItemStore()
        }
        return Static.instance
    }

    init()
    {
        super.init()

        //Read in Homepwner.xcdaamodeld
        model = NSManagedObjectModel.mergedModelFromBundles(nil)
        var psc = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        //Where does the SQLite file go?
        let path = BNRItemStore.itemArchivePath()
        let storeURL = NSURL(fileURLWithPath: path)
        
        var error : NSError?
        
        if !psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil, error: &error)
        {
            NSException(name: "OpenFailure", reason: error!.localizedDescription, userInfo: nil).raise()
        }
        
        context = NSManagedObjectContext()
        context!.persistentStoreCoordinator = psc
        
        loadAllItems()
        
        var nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: "clearCache:", name: UIApplicationDidReceiveMemoryWarningNotification, object: nil)
    }
    
    func loadAllItems()
    {
        if (!privateItems)
        {
            var request = NSFetchRequest()
            let e = NSEntityDescription.entityForName("BNRItem", inManagedObjectContext: context)
            request.entity = e
            let sd = NSSortDescriptor(key: "orderingValue", ascending: true)
            request.sortDescriptors = [sd]
            var error : NSError?
            let result = context!.executeFetchRequest(request, error: &error)
            if (!result)
            {
                NSException(name: "Fetch failed", reason: "Reason: \(error!.localizedDescription)", userInfo: nil).raise()
            }
            
            privateItems = NSMutableArray(array: result)
        }
    }
    
    func allItems() -> ([BNRItem])
    {
        return privateItems!.copy() as [BNRItem]
    }
    
    func createItem() -> (BNRItem)
    {
        var order : Double;
        if (privateItems!.count == 0)
        {
            order = 1.0
        }
        else
        {
            let lastItem = privateItems!.lastObject as BNRItem
            order = lastItem.orderingValue + 1.0
        }
        println("Adding after \(privateItems!.count) items, order = \(Int(order))")
        
        var item = NSEntityDescription.insertNewObjectForEntityForName("BNRItem", inManagedObjectContext: context) as BNRItem
        //item.orderingValue = order
        item.setValue(order, forKey: "orderingValue")
        
        let defaults = NSUserDefaults.standardUserDefaults()
        item.setValue(defaults.integerForKey(BNRNextItemValuePrefsKey), forKey: "valueInDollars")
        item.setValue(defaults.objectForKey(BNRNextItemNamePrefsKey) as String, forKey: "itemName")
        
        //Just for fun, list out all the defaults
        println("defaults = \(defaults.dictionaryRepresentation)")
        
        privateItems!.addObject(item)
        return item
    }
    
    func itemCount() -> Int
    {
        return privateItems!.count
    }
    
    func indexOfItem(item: BNRItem) -> (Int)
    {
        return privateItems!.indexOfObject(item)
    }
    
    func removeItem(item: BNRItem)
    {
        BNRImageStore.sharedStore.deleteImageForKey(item.itemKey)
        
        context!.deleteObject(item)
        privateItems!.removeObjectIdenticalTo(item)
    }
    
    func itemAtIndex(index: Int) -> (BNRItem)
    {
        return privateItems![index] as BNRItem
    }
    
    func moveItemAtIndex(atIndex: Int, toIndex: Int)
    {
        if atIndex == toIndex {
            return
        }
        
        //Get pointer to object being moved so you an re-insert it
        var item = itemAtIndex(atIndex)
        privateItems!.removeObjectAtIndex(atIndex)
        privateItems!.insertObject(item, atIndex: toIndex)
        
        //Computing a new orderValue for the object that was moved
        var lowerBound : Double = 0.0
        
        //Is there an object before it in the array?
        if (toIndex > 0)
        {
            lowerBound = (privateItems![(toIndex - 1)] as BNRItem).orderingValue
        } else {
            lowerBound = (privateItems![1] as BNRItem).orderingValue - 2.0
        }
        
        var upperBound : Double  = 0.0
        
        //Is there an object after it in the array?
        if (toIndex < privateItems!.count - 1)
        {
            upperBound = (privateItems![toIndex + 1] as BNRItem).orderingValue
        }
        else
        {
            upperBound = (privateItems![toIndex - 1] as BNRItem).orderingValue + 2.0
        }
        
        var newOrderValue = (lowerBound + upperBound) / 2.0
        
        println("moving to order \(newOrderValue)")
        //item.orderingValue = newOrderValue
        item.setValue(newOrderValue, forKey: "orderingValue")
    }

    class func itemArchivePath() -> NSString
    {
        //Make sure that the first argument is NSDocumentDirectory
        //and not NSDocumentationDirectory
        let documentDirectories = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        
        //Get the one document directory from that list
        let documentDirectory = documentDirectories[0] as NSString
        
        return documentDirectory.stringByAppendingPathComponent("store.data")
    }
    
    func saveChanges() -> Bool
    {
        var error : NSError?
        var successful = context!.save(&error)
        if (!successful)
        {
            println("Error saving: \(error!.localizedDescription)")
        }
        return successful
    }
    
    func clearCache()
    {
        println("flushing \(privateItems!.count) images out of the cache")
        privateItems!.removeAllObjects()
    }
    
    func getAllAssetTypes() -> NSMutableArray
    {
        if (!allAssetTypes)
        {
            var request = NSFetchRequest()
            
            let e = NSEntityDescription.entityForName("BNRAssetType", inManagedObjectContext: context)
            request.entity = e
            
            var error : NSError?
            let result = context!.executeFetchRequest(request, error: &error)
            if (!result)
            {
                NSException(name: "Fetch failed", reason: "Reason: \(error!.localizedDescription)", userInfo: nil).raise()
            }
            allAssetTypes = NSMutableArray(array: result)
        }
        
        //Is this the first time the program is being run?
        if allAssetTypes!.count == 0
        {
            let assetTypes = ["Furniture", "Jewelry", "Electronics"]
            
            for assetType in assetTypes
            {
                var type : NSManagedObject
                type = NSEntityDescription.insertNewObjectForEntityForName("BNRAssetType", inManagedObjectContext: context) as NSManagedObject
                type.setValue(assetType, forKey: "label")
                allAssetTypes!.addObject(type)
            }
        }
        return allAssetTypes!
    }
}
