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
    }
    
    func allItems() -> (BNRItem[])
    {
        return privateItems.copy() as BNRItem[]
    }
    
    func createItem() -> (BNRItem)
    {
        var item = BNRItem.randomItem()
        
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

}
