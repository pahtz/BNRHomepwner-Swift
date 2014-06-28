//
//  DatePickerViewController.swift
//  BNRHomepwner
//
//  Created by Paul Yu on 28/6/14.
//  Copyright (c) 2014 Paul Yu. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {

    var item : BNRItem?
    @IBOutlet var datePicker: UIDatePicker
    
    override func viewWillAppear(animated: Bool)
    {
        datePicker.date = item!.dateCreated
    }
    
    override func viewWillDisappear(animated: Bool)
    {
       item!.dateCreated = datePicker.date
    }
    
    init(coder aDecoder: NSCoder!)
    {
        super.init(coder: aDecoder)
    }

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
