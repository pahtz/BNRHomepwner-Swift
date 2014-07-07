//
//  BNRItem.swift
//  BNRHomepwner
//
//  Created by Paul Yu on 26/6/14.
//  Copyright (c) 2014 Paul Yu. All rights reserved.
//

import UIKit

class BNRItem: NSObject, NSCoding {
    var itemName : String = ""
    var serialNumber : String = ""
    var valueInDollars : Int = 0
    var dateCreated : NSDate = NSDate()
    var itemKey : String!
    var thumbnail : UIImage?
    
    init()
    {
        super.init()

        //Create an NSUUID object - and get its string representation
        let uuid = NSUUID()
        let key = uuid.UUIDString
        itemKey = key
    }
    
    convenience init(name: String, value: Int, serial: String)
    {
        self.init()
        itemName = name
        valueInDollars = value
        serialNumber = serial
    }
    
    func encodeWithCoder(aCoder: NSCoder!)
    {
        aCoder.encodeObject(itemName, forKey: "itemName")
        aCoder.encodeObject(serialNumber, forKey: "serialNumber")
        aCoder.encodeObject(dateCreated, forKey: "dateCreated")
        aCoder.encodeObject(itemKey, forKey: "itemKey")
        aCoder.encodeInt(CInt(valueInDollars), forKey: "valueInDollars")
        aCoder.encodeObject(thumbnail, forKey: "thumbnail")
    }
    
    init(coder aDecoder: NSCoder!)
    {
        super.init()
        itemName = aDecoder.decodeObjectForKey("itemName") as String
        serialNumber = aDecoder.decodeObjectForKey("serialNumber") as String
        dateCreated = aDecoder.decodeObjectForKey("dateCreated") as NSDate
        itemKey = aDecoder.decodeObjectForKey("itemKey") as String
        valueInDollars = Int(aDecoder.decodeIntForKey("valueInDollars"))
        thumbnail = aDecoder.decodeObjectForKey("thumbnail") as? UIImage
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
    
    class func randomItem() -> (BNRItem)
    {
        func randomDigit() -> String
        {
            let digits = ["0","1","2","3","4","5","6","7","8","9"]
            
            let index = Int(arc4random_uniform(10))
            
            return digits[index]
        }
        
        func randomAlpha() -> String
        {
            let alphas = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
            
            let index = Int(arc4random_uniform(26))
            
            return alphas[index]
        }
        
        let randomAdjectiveList = ["Fluffy", "Rusty", "Shiny"]
        let randomNounList = ["Bear", "Spork", "Mac"]
        
        let adjectiveIndex = Int(arc4random_uniform(UInt32(randomAdjectiveList.count)))
        let nounIndex = Int(arc4random_uniform(UInt32(randomNounList.count)))
        
        let randomName = "\(randomAdjectiveList[adjectiveIndex]) \(randomNounList[nounIndex])"
        
        let randomValue = Int(arc4random_uniform(100))
        
        let randomSerialNumber = "\(randomDigit())\(randomAlpha())\(randomDigit())\(randomAlpha())\(randomDigit())"
        
        var item = BNRItem(name: randomName, value: randomValue, serial: randomSerialNumber)
        return item
    }
    
    func description() -> String
    {
        return "\(itemName) \(serialNumber): Worth $\(valueInDollars), recorded on \(dateCreated)"
    }    
}
