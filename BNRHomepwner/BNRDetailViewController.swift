//
//  BNRDetailViewController.swift
//  BNRHomepwner
//
//  Created by Paul Yu on 28/6/14.
//  Copyright (c) 2014 Paul Yu. All rights reserved.
//

import UIKit
import MobileCoreServices

class BNRDetailViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate,
    UITextFieldDelegate, UIPopoverControllerDelegate {

    var item : BNRItem? {
    didSet {
        navigationItem.title = item!.itemName
    }
    }
    var imagePickerPopover : UIPopoverController?
    
    @IBOutlet var nameField: UITextField
    @IBOutlet var serialNumberField: UITextField
    @IBOutlet var valueField: UITextField
    @IBOutlet var dateLabel: UILabel
    @IBOutlet var imageView: UIImageView
    @IBOutlet var toobar: UIToolbar
    @IBOutlet strong var cameraOverlayView: UIView //Gold challenge
    @IBOutlet var cameraButton: UIBarButtonItem
    
    @IBAction func takePicture(sender: UIBarButtonItem) {
        if imagePickerPopover?.popoverVisible
        {
            //If the popover is already up, get rid of it
            imagePickerPopover!.dismissPopoverAnimated(true)
            imagePickerPopover = nil
            return
        }
        
        var imagePicker = UIImagePickerController()
        
        //If the device has a camera, take a pictur, otherwise,
        //just pick from photo library
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            //imagePicker.cameraOverlayView = cameraOverlayView //Gold challenge
        }
        else
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        imagePicker.delegate = self
        imagePicker.mediaTypes = [kUTTypeImage]
        imagePicker.allowsEditing = true
        imagePicker.allowsImageEditing = true //Bronze challenge
        
        //Place image picker on the screen
        
        //Check for iPad device before instantiating the popover controller
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad
        {
            //Create a new popover controller that will display the imagepicker
            imagePickerPopover = UIPopoverController(contentViewController: imagePicker)
            imagePickerPopover!.delegate = self
            
            //Display the popover controller; sender is the camera bar button item
            imagePickerPopover!.presentPopoverFromBarButtonItem(sender, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
        else
        {
            presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    //Silver Challenge: Removing an Image
    @IBAction func trashPicture(sender: UIBarButtonItem) {
        BNRImageStore.sharedStore.deleteImageForKey(item!.itemKey)
        imageView.image = nil
    }
    
    @IBAction func changeDateButton(sender: UIButton) {
        var datePicker = DatePickerViewController()
        datePicker.item = item!
        navigationController.pushViewController(datePicker, animated: true)
    }
    
    @IBAction func backgroundTapped(sender: AnyObject) {
        view.endEditing(true)
    }
    
    init(coder aDecoder: NSCoder!)
    {
        cameraOverlayView = UIView() //Gold Challenge - will be replaced by xib
        super.init(coder: aDecoder)
    }
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        cameraOverlayView = UIView() //Gold Challenge - will be replaced by xib
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }
    
    func popoverControllerDidDismissPopover(popoverController: UIPopoverController!)
    {
        println("User dismissed popover")
        self.imagePickerPopover = nil
    }
    
    func prepareViewsForOrientation(orientation: UIInterfaceOrientation)
    {
        //Is it iPad? No preparation necessary
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad { return }
        
        //Is it landscape?
        if UIInterfaceOrientationIsLandscape(orientation)
        {
            imageView.hidden = true
            cameraButton.enabled = false
        } else {
            imageView.hidden = false
            cameraButton.enabled = true
        }
    }
    
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval)
    {
        prepareViewsForOrientation(toInterfaceOrientation)
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: NSDictionary!)
    {
        println("ImagePicker didFinishPickingMedia")
        // Get picked image from info dictionary
        var image = info[UIImagePickerControllerEditedImage] as UIImage //Bronze challenge change to edited image
        
        //Store the image in the BNRImageStore for this key
        BNRImageStore.sharedStore.setImage(image, forKey: item!.itemKey)
        
        //Put that image onto the screen in our image view
        imageView.image = image
        
        //Do I have a popover?
        if imagePickerPopover
        {
            //Dismiss it
            imagePickerPopover!.dismissPopoverAnimated(true)
            imagePickerPopover = nil
        }
        else
        {
            //Take image picker off the screen -
            //you must call this dismiss method
            //Dismiss the modal image picker
            dismissViewControllerAnimated(true, completion: nil)
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> (Bool)
    {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        let io = UIApplication.sharedApplication().statusBarOrientation
        prepareViewsForOrientation(io)
        
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
        
        //Get the image for its image key from the image store
        //and use that image to put on the screen in the imageView
        imageView.image = BNRImageStore.sharedStore.imageForKey(item!.itemKey)
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
