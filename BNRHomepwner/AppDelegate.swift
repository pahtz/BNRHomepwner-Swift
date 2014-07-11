//
//  AppDelegate.swift
//  BNRHomepwner
//
//  Created by Paul Yu on 26/6/14.
//  Copyright (c) 2014 Paul Yu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        //self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        // Override point for customization after application launch.
        
        //If state restoration did not occur, setup the view controller hierarchy
        if (window) { if (window!.rootViewController == nil) {
            println("State restoration did not occur")
            
            //Create a BNRItemsViewController
            var itemsViewController = BNRItemsViewController()
            
            //Place BNRItemsViewController's table view in the window hierarchy
            
            //Create an instance of a UINavigationController
            //its stack contains only itemsViewController
            var navController = UINavigationController(rootViewController: itemsViewController)
            
            //Give the navigation controller a resotration identifier that is
            //the same name as the class
            navController.restorationIdentifier = /*NSStringFromClass(navController.dynamicType*/"UINavigationController"//)
            
            //Place navigation controller's view in the window hierarchy
            window!.rootViewController = navController
        }}
        //self.window!.backgroundColor = UIColor.whiteColor()
        self.window!.makeKeyAndVisible()
        return true
    }

    func application(application: UIApplication!, willFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]!) -> Bool
    {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.backgroundColor = UIColor.whiteColor()
        return true
    }
    
    func application(application: UIApplication!, shouldSaveApplicationState coder: NSCoder!) -> Bool
    {
        return true
    }
    
    func application(application: UIApplication!, shouldRestoreApplicationState coder: NSCoder!) -> Bool
    {
        return true
    }
    
    func application(application: UIApplication!, viewControllerWithRestorationIdentifierPath identifierComponents: [AnyObject]!, coder: NSCoder!) -> UIViewController!
    {
        println("Restoring...")
        
        //Create a new navigation controller
        var vc = UINavigationController()
        
        //The last object in the path array is the restoration identifier for this view controller
        vc.restorationIdentifier = identifierComponents[identifierComponents.endIndex - 1] as String
        
        //If there is only 1 identifier component, then this is the root view controller
        if identifierComponents.count == 1
        {
            println("Restoring root view controller")
            window!.rootViewController = vc
        }
        return vc
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        let  success = BNRItemStore.sharedStore.saveChanges()
        if (success) {
            println("Saved all of the BNRItems")
        }
        else
        {
            println("Could not save any of the BNRItems")
        }
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

