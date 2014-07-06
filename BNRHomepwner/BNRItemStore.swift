//
//  BNRItemStore.swift
//  BNRHomepwner
//
//  Created by Paul Yu on 26/6/14.
//  Copyright (c) 2014 Paul Yu. All rights reserved.
//

// Swift singleton pattern from https://github.com/hpique/SwiftSingleton

import UIKit

class BNRItemStore: NSObject {
    
    var privateItems : NSMutableArray = NSMutableArray()
    
    class var sharedStore : BNRItemStore {
    struct Static {
        static let instance : BNRItemStore = BNRItemStore()
        }
        return Static.instance
    }

    init()
    {
        super.init()
        let path = itemArchivePath()
        
        //Error: Objective-C exception is not handled below if the file is bad or missing
        privateItems = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as NSMutableArray
        
        //If the array hadn't been saved previously, create a new empty one
        if (privateItems == nil)
        {
            privateItems = NSMutableArray()
        }
        
        var nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: "clearCache:", name: UIApplicationDidReceiveMemoryWarningNotification, object: nil)
    }
    
    func allItems() -> (BNRItem[])
    {
        return privateItems.copy() as BNRItem[]
    }
    
    func createItem() -> (BNRItem)
    {
        //var item = BNRItem.randomItem()
        var item = BNRItem()
        
        privateItems.addObject(item)
        
        return item
    }
    
    func itemCount() -> Int
    {
        return privateItems.count
    }
    
    func indexOfItem(item: BNRItem) -> (Int)
    {
        return privateItems.indexOfObject(item)
    }
    
    func removeItem(item: BNRItem)
    {
        BNRImageStore.sharedStore.deleteImageForKey(item.itemKey)
        
        privateItems.removeObjectIdenticalTo(item)
    }
    
    func itemAtIndex(index: Int) -> (BNRItem)
    {
        return privateItems[index] as BNRItem
    }
    
    func moveItemAtIndex(atIndex: Int, toIndex: Int)
    {
        if atIndex == toIndex {
            return
        }
        
        //Get pointer to object being moved so you an re-insert it
        var item = itemAtIndex(atIndex)
        privateItems.removeObjectAtIndex(atIndex)
        privateItems.insertObject(item, atIndex: toIndex)
    }

    func itemArchivePath() -> NSString
    {
        //Make sure that the first argument is NSDocumentDirectory
        //and not NSDocumentationDirectory
        let documentDirectories = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        
        //Get the one document directory from that list
        let documentDirectory = documentDirectories[0] as NSString
        
        return documentDirectory.stringByAppendingPathComponent("items.archive")
    }
    
    func saveChanges() -> Bool
    {
        let path = itemArchivePath()
        
        //Return true on success
        return NSKeyedArchiver.archiveRootObject(privateItems, toFile: path)
    }
    
    func clearCache()
    {
        println("flushing \(privateItems.count) images out of the cache")
        privateItems.removeAllObjects()
    }
}
