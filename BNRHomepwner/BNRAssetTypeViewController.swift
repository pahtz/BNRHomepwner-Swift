//
//  BNRAssetTypeViewController.swift
//  BNRHomepwner
//
//  Created by Paul Yu on 10/7/14.
//  Copyright (c) 2014 Paul Yu. All rights reserved.
//

import UIKit
import CoreData

class BNRAssetTypeViewController: UITableViewController {
   
    var item : BNRItem?

    init(coder aDecoder: NSCoder!)
    {
        super.init(coder: aDecoder)
    }
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
         super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }

    init()
    {
        super.init(style: UITableViewStyle.Plain)
        
        navigationItem.title = NSLocalizedString("Asset Type", tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: "BNRAssetTypeViewController title")
    }

    convenience init(style: UITableViewStyle)
    {
        self.init()
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int
    {
        return BNRItemStore.sharedStore.getAllAssetTypes().count
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!
    {
        var cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath) as UITableViewCell
        let allAssets = BNRItemStore.sharedStore.getAllAssetTypes()
        let assetType = allAssets[indexPath.row] as NSManagedObject
        
        //Use key-value coding to get the asset type's label
        let assetLabel = assetType.valueForKey("label") as String
        cell.textLabel.text = assetLabel
        
        //Checkmark the one that is currently selected
        if (assetType == item!.assetType)
        {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        return cell
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!)
    {
        var cell = tableView.cellForRowAtIndexPath(indexPath)
        cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        
        let allAssets = BNRItemStore.sharedStore.getAllAssetTypes()
        let assetType = allAssets[indexPath.row] as NSManagedObject
        item!.assetType = assetType
        navigationController.popViewControllerAnimated(true)
    }
}