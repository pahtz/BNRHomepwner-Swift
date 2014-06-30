//
//  BNRImageStore.swift
//  BNRHomepwner
//
//  Created by Paul Yu on 30/6/14.
//  Copyright (c) 2014 Paul Yu. All rights reserved.
//
// Swift singleton pattern from https://github.com/hpique/SwiftSingleton

import UIKit

class BNRImageStore: NSObject {
    var dictionary = NSMutableDictionary()
   
    class var sharedStore : BNRImageStore {
    struct Static {
        static let instance : BNRImageStore = BNRImageStore()
        }
        return Static.instance
    }
    
    init()
    {
        super.init()
    }
    
    func setImage(image: UIImage, forKey: String)
    {
        //dictionary.setObject(image, forKey: forKey)
        dictionary[forKey] = image
    }
    
    func imageForKey(key: String) -> (UIImage?)
    {
        //return dictionary.objectForKey(key) as? UIImage
        return dictionary[key] as? UIImage
    }
    
    func deleteImageForKey(key: String)
    {
        dictionary.removeObjectForKey(key)
    }
}
