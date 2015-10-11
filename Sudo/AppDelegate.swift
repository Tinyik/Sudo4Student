//
//  AppDelegate.swift
//  Sudo
//
//  Created by fong tinyik on 5/31/15.
//  Copyright (c) 2015 fong tinyik. All rights reserved.
//

import UIKit


@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate,UIAlertViewDelegate {
    var window: UIWindow?

   // var sheetIDArray: [String]!

   
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        isTeacher = false
        Bmob.registerWithAppKey("9c95eb1ccd7d852f243ce1cb01769f37")
        UINavigationBar.appearance().barTintColor = .whiteColor()
        UINavigationBar.appearance().tintColor = .whiteColor()
        UINavigationBar.appearance().setBackgroundImage(UIImage(named: "Sudo-HomePage_0012_图层-5"), forBarMetrics: .Default)        
        
        let screenSize = UIScreen.mainScreen().bounds.size
        
        if screenSize.height == 568 {
            let storyboard = UIStoryboard(name: "iPhone5", bundle: nil)
            let initialVC = storyboard.instantiateInitialViewController() as! UIViewController
            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            self.window?.rootViewController = initialVC
            self.window?.makeKeyAndVisible()
            deviceScale = 0.853
            isiPhone6 = false
            UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont(name: "GillSans-Light", size: 22)!, NSForegroundColorAttributeName: UIColor.whiteColor()]
            
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialVC = storyboard.instantiateInitialViewController() as! UIViewController
            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            self.window?.rootViewController = initialVC
            self.window?.makeKeyAndVisible()
            isiPhone6 = true
            deviceScale = 1.0
            UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont(name: "GillSans-Light", size: 25)!, NSForegroundColorAttributeName: UIColor.whiteColor()]
            
            
        }
        
        if BmobUser.getCurrentUser() == nil {
            let storyboard = self.window?.rootViewController?.storyboard
            let rootVC = storyboard?.instantiateViewControllerWithIdentifier("RegiLogin") as! ViewController
            self.window?.rootViewController = rootVC
            self.window?.makeKeyAndVisible()
            
        }
        
        let worldclock =  NetworkClock.sharedNetworkClock()
        let date = worldclock.networkTime
        var expiryDateComponent = NSDateComponents()
         expiryDateComponent.year = 2015
         expiryDateComponent.month = 8
         expiryDateComponent.day = 25
          expiryDateComponent.hour = 0
         expiryDateComponent.minute = 0
        expiryDateComponent.second = 0
        var gregorian = NSCalendar(calendarIdentifier: "gregorian")
        var expiryDate = gregorian?.dateFromComponents(expiryDateComponent)
        println(date)
        if date.laterDate(expiryDate!) == date! {
            let alert = UIAlertView(title: "Sudo4Student Beta has expired", message: "Please contact your teacher and update the app. --Fong Tinyik", delegate: self, cancelButtonTitle: "Exit")
            alert.show()
            
        }
        
        NSThread.sleepForTimeInterval(1)
        
        return true
    }
    
    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        exit(0)
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//        var defaults = NSUserDefaults.standardUserDefaults()
//        defaults.setObject(self.sheetIDArray, forKey: "usedIDs")
//        println(self.sheetIDArray)
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentDir = paths[0] as! String
        let docPath = documentDir.stringByAppendingPathComponent("ReportRecords.plist")
        NSKeyedArchiver.archiveRootObject(reports, toFile: docPath)
        
        println("WILL_TERMINATE")
   

    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        application.registerForRemoteNotifications()
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        println("Received")
        BmobPush.handlePush(userInfo)
    }

}

