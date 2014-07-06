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
    }
    
    init(coder aDecoder: NSCoder!)
    {
        super.init()
        itemName = aDecoder.decodeObjectForKey("itemName") as String
        serialNumber = aDecoder.decodeObjectForKey("serialNumber") as String
        dateCreated = aDecoder.decodeObjectForKey("dateCreated") as NSDate
        itemKey = aDecoder.decodeObjectForKey("itemKey") as String
        valueInDollars = Int(aDecoder.decodeIntForKey("valueInDollars"))
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
