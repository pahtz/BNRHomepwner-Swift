//
//  BNRItemCell.swift
//  BNRHomepwner
//
//  Created by Paul Yu on 7/7/14.
//  Copyright (c) 2014 Paul Yu. All rights reserved.
//

import UIKit

class BNRItemCell: UITableViewCell {

    var actionBlock : (()->())? = nil
    
    @IBOutlet var thumbnailView: UIImageView
    @IBOutlet var nameLabel: UILabel
    @IBOutlet var serialNumberLabel: UILabel
    @IBOutlet var valueLabel: UILabel
    
    //@IBOutlet var imageViewWidthConstraint: NSLayoutConstraint
    @IBOutlet var imageViewHeightConstraint: NSLayoutConstraint
    
    @IBAction func showImage() {
        actionBlock!()
    }
     
    func updateInterfaceForDynamicTypeSize()
    {
        let font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        nameLabel.font = font
        serialNumberLabel.font = font
        valueLabel.font = font
        
        let imageSizeDictionary = [UIContentSizeCategoryExtraSmall : 40,
            UIContentSizeCategorySmall : 40,
            UIContentSizeCategoryMedium : 40,
            UIContentSizeCategoryLarge : 40,
            UIContentSizeCategoryExtraLarge : 45,
            UIContentSizeCategoryExtraExtraLarge : 55,
            UIContentSizeCategoryExtraExtraExtraLarge : 65]
        
        let userSize = UIApplication.sharedApplication().preferredContentSizeCategory
        
        let imageSize = imageSizeDictionary[userSize] as CGFloat
        imageViewHeightConstraint.constant = imageSize
        //imageViewWidthConstraint.constant = imageSize
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        updateInterfaceForDynamicTypeSize()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateInterfaceForDynamicTypeSize", name: UIContentSizeCategoryDidChangeNotification, object: nil)
        
        var constraint = NSLayoutConstraint(item: thumbnailView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: thumbnailView, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        thumbnailView.addConstraint(constraint)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
