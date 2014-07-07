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
    
    @IBAction func showImage() {
        if (actionBlock != nil) { actionBlock!() } //Error: the check for nil doesn't work
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
