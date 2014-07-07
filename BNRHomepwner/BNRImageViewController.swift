//
//  BNRImageViewController.swift
//  BNRHomepwner
//
//  Created by Paul Yu on 7/7/14.
//  Copyright (c) 2014 Paul Yu. All rights reserved.
//

import UIKit

class BNRImageViewController: UIViewController, UIScrollViewDelegate {

    var image : UIImage?
    var scrollView : UIScrollView = UIScrollView()
    var imageView : UIImageView = UIImageView()
   
    init(coder aDecoder: NSCoder!)
    {
        super.init(coder: aDecoder)
    }
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
        view = scrollView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView!) -> UIView!
    {
        return imageView
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.image = image
        imageView.sizeToFit()
        scrollView.addSubview(imageView)
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 2.0
        scrollView.delegate = self
        scrollView.contentSize = image!.size
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
