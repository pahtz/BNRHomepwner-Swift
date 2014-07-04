//
//  BNRPopoverBackgroundView.swift
//  BNRHomepwner
//
//  Created by Paul Yu on 4/7/14.
//  Copyright (c) 2014 Paul Yu. All rights reserved.
//

import UIKit

class BNRPopoverBackgroundView: UIPopoverBackgroundView {

    override var arrowOffset: CGFloat {
    get {
        return 20.0
    }
    set {
    }
    }

    override var arrowDirection : UIPopoverArrowDirection {
    get {
        return UIPopoverArrowDirection.Down
    }
    set {
    }
    }
    
    override class func contentViewInsets() -> (UIEdgeInsets)
    {
        return UIEdgeInsetsMake(3.0, 3.0, 3.0, 3.0)
    }
    
    override class func arrowBase() -> CGFloat
    {
        return 20.0
    }
    
    override class func arrowHeight() -> CGFloat
    {
        return 20.0
    }
    
    init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
        backgroundColor = UIColor.blueColor()
    }
    
    override class func wantsDefaultContentAppearance() -> Bool
    {
        return false
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing code
    }
    */

}
