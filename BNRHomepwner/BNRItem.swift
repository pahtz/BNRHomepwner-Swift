//
//  BNRItem.swift
//  BNRHomepwner
//
//  Created by Paul Yu on 9/7/14.
//  Copyright (c) 2014 Paul Yu. All rights reserved.
//

import Foundation
import CoreData
import UIKit

@objc(BNRItem)
class BNRItem: NSManagedObject {

    @NSManaged var dateCreated: NSDate
    @NSManaged var itemKey: String
    @NSManaged var itemName: String
    @NSManaged var orderingValue: Double
    @NSManaged var serialNumber: String
    @NSManaged var valueInDollars: Int32
    @NSManaged var thumbnail: UIImage?
    @NSManaged var assetType: NSManagedObject?

    override func awakeFromInsert()
    {
        super.awakeFromInsert()
        
        itemName = ""
        serialNumber = ""
        valueInDollars = 0
        dateCreated = NSDate()
        //orderingValue = 0
        self.setValue(0, forKey: "orderingValue")
        thumbnail = nil
        assetType = nil
        
        //Create an NSUUID object - and get its string representation
        let uuid = NSUUID()
        let key = uuid.UUIDString
        itemKey = key
    }
    
    func setThumbnailFromImage(image: UIImage)
    {
        let origImageSize = image.size
        
        //The rectangle of the thumbnail
        let newRect = CGRectMake(0,0,40,40)
        
        //Figure out a scaling ratio to make sure we maintain the same aspect ratio
        let ratio = max(newRect.size.width / origImageSize.width, newRect.size.height / origImageSize.height)
        
        //Create a transparent bitmap context with a scaling factor
        //equal to that of the screen
        UIGraphicsBeginImageContextWithOptions(newRect.size, false, 0.0)
        
        //Create a path that is a rounded rectangle
        var path = UIBezierPath(roundedRect: newRect, cornerRadius: 5.0)
        
        //Make all subsequent drawing clip to this rounded rectangle
        path.addClip()
        
        //Center the image in the thumbnail rectangle
        var projectRect = CGRectZero
        projectRect.size.width = ratio * origImageSize.width
        projectRect.size.height = ratio * origImageSize.height
        projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0
        projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0
        
        //Draw the image on it
        image.drawInRect(projectRect)
        
        //Get the image from the image context; keep it as our thumbnail
        var smallImage = UIGraphicsGetImageFromCurrentImageContext()
        thumbnail = smallImage
        
        //Cleanup image context resources; we're done
        UIGraphicsEndImageContext()
    }
}
