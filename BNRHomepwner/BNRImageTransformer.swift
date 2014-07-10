//
//  BNRImageTransformer.swift
//  BNRHomepwner
//
//  Created by Paul Yu on 9/7/14.
//  Copyright (c) 2014 Paul Yu. All rights reserved.
//

import UIKit

class BNRImageTransformer: NSValueTransformer {
    override class func transformedValueClass() -> AnyClass!
    {
        return NSData.self
    }
    
    override func transformedValue(value: AnyObject!) -> AnyObject!
    {
        if (!value) {
            return nil
        }
        
        if (value.isKindOfClass(NSData.self)) {
            return value
        }
        
        return UIImagePNGRepresentation(value as UIImage)
    }

    override func reverseTransformedValue(value: AnyObject!) -> AnyObject!
    {
        return UIImage(data: value as NSData)
    }
    
}
