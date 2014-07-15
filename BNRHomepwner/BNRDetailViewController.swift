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
    UITextFieldDelegate, UIPopoverControllerDelegate, UIViewControllerRestoration {

    var item : BNRItem? {
    didSet {
        navigationItem.title = item!.itemName
    }
    }
    var imagePickerPopover : UIPopoverController?
    var dismissBlock : (Void)->(Void) = {}
    
    @IBOutlet var nameField: UITextField
    @IBOutlet var serialNumberField: UITextField
    @IBOutlet var valueField: UITextField
    @IBOutlet var dateLabel: UILabel
    @IBOutlet var imageView: UIImageView
    @IBOutlet var toobar: UIToolbar
    @IBOutlet strong var cameraOverlayView: UIView //Gold challenge - Depreciated API - not used
    @IBOutlet var cameraButton: UIBarButtonItem
    @IBOutlet var nameLabel: UILabel
    @IBOutlet var serialNumberLabel: UILabel
    @IBOutlet var valueLabel: UILabel
    @IBOutlet var assetTypeButton: UIBarButtonItem
    
    @IBAction func showAssetTypePicker(sender: UIBarButtonItem) {
        view.endEditing(true)
        
        var avc = BNRAssetTypeViewController()
        avc.item = item
        
        navigationController.pushViewController(avc, animated: true)
    }
    
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
        //imagePicker.mediaTypes = [kUTTypeImage]
        imagePicker.allowsEditing = true
        //imagePicker.allowsImageEditing = true //Bronze challenge - depreciated API
        
        //Place image picker on the screen
        
        //Check for iPad device before instantiating the popover controller
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad
        {
            //Create a new popover controller that will display the imagepicker
            imagePickerPopover = UIPopoverController(contentViewController: imagePicker)
            imagePickerPopover!.delegate = self
            
            //Chapter 17 Gold Challenge - change appearance of the popover
            imagePickerPopover!.popoverBackgroundViewClass = BNRPopoverBackgroundView.self
            
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
    
    class func viewControllerWithRestorationIdentifierPath(identifierComponents: [AnyObject]!, coder: NSCoder!) -> UIViewController!
    {
        var isNew : Bool = false
        if (identifierComponents.count == 3) { isNew = true }
        
        return BNRDetailViewController(forNewItem: isNew)
    }
    
    override func encodeRestorableStateWithCoder(coder: NSCoder!)
    {
        println("Saving state of DetailViewController")
        
        coder.encodeObject(item!.itemKey, forKey: "item.itemKey")
        
        //Save changes to item
        item!.itemName = nameField.text
        item!.serialNumber = serialNumberField.text
        item!.setValue(valueField.text.toInt(), forKey: "valueInDollars")
        
        //Have store save changes to disk
        BNRItemStore.sharedStore.saveChanges()
        
        super.encodeRestorableStateWithCoder(coder)
    }

    override func decodeRestorableStateWithCoder(coder: NSCoder!)
    {
        println("Restoring DetailViewController")
        
        var itemKey = coder.decodeObjectForKey("item.itemKey") as String
        for iterItem in BNRItemStore.sharedStore.allItems()
        {
            if itemKey == iterItem.itemKey
            {
                item = iterItem
                break;
            }
        }
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
    
    convenience init(forNewItem: Bool)
    {
        self.init(nibName: nil, bundle: nil)
        
        restorationIdentifier = NSStringFromClass(self.dynamicType)
        restorationClass = self.dynamicType
        
        if forNewItem
        {
            var doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "save:")
            navigationItem.rightBarButtonItem = doneItem
            
            var cancelItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancel:")
            navigationItem.leftBarButtonItem = cancelItem
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateFonts", name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func updateFonts()
    {
        let font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        
        nameLabel.font = font
        serialNumberLabel.font = font
        valueLabel.font = font
        dateLabel.font = font
        
        nameField.font = font
        serialNumberField.font = font
        valueField.font = font
    }
    
    func save(sender: AnyObject)
    {
        presentingViewController.dismissViewControllerAnimated(true, completion: dismissBlock)
    }
    
    func cancel(sender: AnyObject)
    {
        //If the user cancelled, then remove the BNRItem from the store
        BNRItemStore.sharedStore.removeItem(item!)
        presentingViewController.dismissViewControllerAnimated(true, completion: dismissBlock)
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
        item!.setThumbnailFromImage(image)
        
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
        
        var typeLabel : String?
        if (item!.assetType)
        {
            typeLabel = item!.assetType!.valueForKey("label") as String?
            if (!typeLabel)
            {
                typeLabel = NSLocalizedString("None", tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: "Type label None")
            }
        }
        else
        {
          typeLabel = NSLocalizedString("None", tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: "Type label None")
        }
    
        assetTypeButton.title = NSLocalizedString("Type:", tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: "Asset type button")  + "\(typeLabel)"
    
        updateFonts()
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        //Clear first responder
        view.endEditing(true)
        
        // "Save" changes to item
        item!.itemName = nameField.text
        item!.serialNumber = serialNumberField.text
        if let value = valueField.text.toInt()
        {
            //item!.valueInDollars = Int32(value) //crashes
            item!.setValue(value, forKey: "valueInDollars")
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
