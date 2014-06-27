//
//  BNRItemStore.swift
//  BNRHomepwner
//
//  Created by Paul Yu on 26/6/14.
//  Copyright (c) 2014 Paul Yu. All rights reserved.
//

// Swift singleton pattern from https://github.com/hpique/SwiftSingleton

import UIKit

let _sharedStore = BNRItemStore()

class BNRItemStore: NSObject {
    
    var privateItems : NSMutableArray = NSMutableArray()
    
    class var sharedStore :BNRItemStore {
        return _sharedStore
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
}
