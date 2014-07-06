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
        
        //Create full path for image
        var imagePath = imagePathForKey(forKey)
        
        //Turn image into JPEG data or PNG data for the Bronze Challenge
        var data = UIImagePNGRepresentation(image)
        
        //Write it to full path
        data.writeToFile(imagePath, atomically: true)
    }
    
    func imageForKey(key: String) -> (UIImage?)
    {
        //return dictionary.objectForKey(key) as? UIImage
        //return dictionary[key] as? UIImage
        var result = dictionary[key] as? UIImage
        if (result == nil)
        {
            let imagePath = imagePathForKey(key)
            result = UIImage(contentsOfFile: imagePath)
            
            //If we found an image on the file system, place it into the cache
            if (result != nil)
            {
                dictionary[key] = result
            }
            else
            {
                println("Error: unable to find \(imagePath)")
            }
        }
        return result
    }
    
    func deleteImageForKey(key: String)
    {
        dictionary.removeObjectForKey(key)
        
        let imagePath = imagePathForKey(key)
        NSFileManager.defaultManager().removeItemAtPath(imagePath, error: nil)
    }

    func imagePathForKey(key: String) -> (NSString)
    {
        let documentDirectories = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentDirectory = documentDirectories[0] as String
        return documentDirectory.stringByAppendingPathComponent(key)
    }
    
}
