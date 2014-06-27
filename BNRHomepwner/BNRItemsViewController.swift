//
//  BNRItemsViewController.swift
//  BNRHomepwner
//
//  Created by Paul Yu on 26/6/14.
//  Copyright (c) 2014 Paul Yu. All rights reserved.
//

import UIKit

class BNRItemsViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var headerView : UIView
    
    @IBAction func addNewItem(sender: UIButton)
    {
        println("addNewItem clicked")
        //Create a new BNRItem and add it to the store
        let newItem = BNRItemStore.sharedStore.createItem()
        
        //Figure out where that item is in the array
        let lastRow = BNRItemStore.sharedStore.indexOfItem(newItem)
        let indexPath = NSIndexPath(forRow: lastRow, inSection: 0)
        
        //Insert the new row into the table
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
    }
    
    @IBAction func toggleEditingMode(sender: UIButton)
    {
        println("toggleEditingMode toggled")
        //If you are currently in editing mode...
        if (editing) {
            //Change text of button to infrom user of state
            sender.setTitle("Edit", forState: UIControlState.Normal)
            setEditing(false, animated: true)
        } else {
            //Change text of button to inform user of state
            sender.setTitle("Done", forState: UIControlState.Normal)
            setEditing(true, animated: true)
        }
    }
    
    init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
        
    init(coder aDecoder: NSCoder!)
    {
        super.init(coder: aDecoder)
    }
    
    init() {
        //Call the superclasss's designated intializer
        super.init(style: UITableViewStyle.Plain)
    }
    
    
    init(style: UITableViewStyle) {
        super.init(style: UITableViewStyle.Plain)
        // Custom initialization
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.backgroundView = UIImageView(image: UIImage(named: "Background.png"))

        tableView.tableHeaderView = headerView
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // #pragma mark - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return BNRItemStore.sharedStore.itemCount() + 1  //add +1 for Silver Challenge
    }
    
    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat
    {
        let last = BNRItemStore.sharedStore.itemCount()
        if (indexPath.row == last)
        {
            return 44.0
        }
        else
        {
            return 60.0
        }
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
    
        //Create an instance of UITableViewCell, with default appearance
        var cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath) as UITableViewCell
        if cell == nil
        {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "UITableViewCell")
        }
        
        //Set the text on the cell with the description of item
        //that is at the nth index of items, where n = row this cell
        //will appear in on the tableview
        let items  = BNRItemStore.sharedStore.allItems()
        
        if indexPath.row == items.count
        {
            cell.textLabel.text = "No more items!"
        }
        else
        {
            let item  = items[indexPath!.row]
        
            // Configure the cell...
            cell.textLabel.text = item.description
            cell.textLabel.font = UIFont.systemFontOfSize(40.0)
        }
        return cell
    }
    
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!)
    {
        //If the table view is asking to commit a delete command...
        if (editingStyle == UITableViewCellEditingStyle.Delete)
        {
            var item = BNRItemStore.sharedStore.itemAtIndex(indexPath.row)
            BNRItemStore.sharedStore.removeItem(item)
            
            //Also remove that row from the table view with an animation
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        }
    }
    
    override func tableView(tableView: UITableView!, moveRowAtIndexPath sourceIndexPath: NSIndexPath!, toIndexPath destinationIndexPath: NSIndexPath!)
    {
        BNRItemStore.sharedStore.moveItemAtIndex(sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
    
    //Prevent editing / deleting last row
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool
    {
        let lastRowIndex = BNRItemStore.sharedStore.itemCount()
        
        if (indexPath.row == lastRowIndex)
        {
            return false
        }
        return true
    }
    
    //Silver Challenge:prevent reordering the last row (No more items!)
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool
    {
        let lastRowIndex = BNRItemStore.sharedStore.itemCount()
        
        if (indexPath.row >= lastRowIndex)
        {
            return false
        }
        return true
    }
    
    //Gold Challenge: preventing reordering beyond / to the last row
    override func tableView(tableView: UITableView!, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath!, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath!) -> NSIndexPath!
    {
        let lastRowIndex = BNRItemStore.sharedStore.itemCount()
        
        if (proposedDestinationIndexPath.row >= lastRowIndex) {
            return NSIndexPath(forRow: lastRowIndex-1, inSection: 0)
        }
        else
        {
            return proposedDestinationIndexPath
        }
    }
    
    //Bronze Challenge: renaming the Delete Button
    override func tableView(tableView: UITableView!, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath!) -> String!
    {
        return "Remove"
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView?, canEditRowAtIndexPath indexPath: NSIndexPath?) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView?, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath?) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView?, moveRowAtIndexPath fromIndexPath: NSIndexPath?, toIndexPath: NSIndexPath?) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView?, canMoveRowAtIndexPath indexPath: NSIndexPath?) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // #pragma mark - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
}
