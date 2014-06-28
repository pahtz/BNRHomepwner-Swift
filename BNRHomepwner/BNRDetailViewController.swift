//
//  BNRDetailViewController.swift
//  BNRHomepwner
//
//  Created by Paul Yu on 28/6/14.
//  Copyright (c) 2014 Paul Yu. All rights reserved.
//

import UIKit

class BNRDetailViewController: UIViewController {

    var item : BNRItem? {
    didSet {
        navigationItem.title = item!.itemName
    }
    }
    
    @IBOutlet var nameField: UITextField
    @IBOutlet var serialNumberField: UITextField
    @IBOutlet var valueField: UITextField
    @IBOutlet var dateLabel: UILabel
    
    @IBAction func changeDateButton(sender: UIButton) {
        var datePicker = DatePickerViewController()
        datePicker.item = item!
        navigationController.pushViewController(datePicker, animated: true)
    }
    
    init(coder aDecoder: NSCoder!)
    {
        super.init(coder: aDecoder)
    }
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }

    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        var editableItem = self.item!
        nameField.text = editableItem.itemName
        serialNumberField.text = editableItem.serialNumber
        valueField.text = "\(editableItem.valueInDollars)"
        
        //You need an NSDateFormatter that will turn a date into a simple date string
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        
        //Use filtered NSDate objet to set dateLabel contents
        dateLabel.text = dateFormatter.stringFromDate(editableItem.dateCreated)
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        //Clear first responder
        view.endEditing(true)
        
        // "Save" changes to item
        var editedItem = self.item!
        editedItem.itemName = nameField.text
        editedItem.serialNumber = serialNumberField.text
        if let value = valueField.text.toInt()
        {
            editedItem.valueInDollars = value
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!)
    {
        nameField.resignFirstResponder()
        serialNumberField.resignFirstResponder()
        valueField.resignFirstResponder()
    }
    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
