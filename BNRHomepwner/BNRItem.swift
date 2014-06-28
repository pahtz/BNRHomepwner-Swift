//
//  BNRItem.swift
//  BNRHomepwner
//
//  Created by Paul Yu on 26/6/14.
//  Copyright (c) 2014 Paul Yu. All rights reserved.
//

import UIKit

class BNRItem: NSObject {
    var itemName : String = "Item"
    var serialNumber : String = ""
    var valueInDollars : Int = 0
    var dateCreated : NSDate = NSDate()
    
    init(name: String, value: Int, serial: String)
    {
        super.init()
        itemName = name
        valueInDollars = value
        serialNumber = serial
    }
    
    init(name: String)
    {
        super.init()
        itemName = name
    }
    
    class func randomItem() -> (BNRItem)
    {
        func randomDigit() -> String
        {
            let digits = ["0","1","2","3","4","5","6","7","8","9"]
            
            let index = Int(arc4random()) % 10
            
            return digits[index]
        }
        
        func randomAlpha() -> String
        {
            let alphas = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
            
            let index = Int(arc4random()) % 26
            
            return alphas[index]
        }
        
        let randomAdjectiveList = ["Fluffy", "Rusty", "Shiny"]
        let randomNounList = ["Bear", "Spork", "Mac"]
        
        let adjectiveIndex = Int(arc4random()) % randomAdjectiveList.count
        let nounIndex = Int(arc4random()) % randomNounList.count
        
        let randomName = "\(randomAdjectiveList[adjectiveIndex]) \(randomNounList[nounIndex])"
        
        let randomValue = Int(arc4random()) % 100
        
        let randomSerialNumber = "\(randomDigit())\(randomAlpha())\(randomDigit())\(randomAlpha())\(randomDigit())"
        
        var item = BNRItem(name: randomName, value: randomValue, serial: randomSerialNumber)
        return item
    }
    
    func description() -> String
    {
        return "\(itemName) \(serialNumber): Worth $\(valueInDollars), recorded on \(dateCreated)"
    }    
}
