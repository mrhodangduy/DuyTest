//
//  AppDelegate.swift
//  Wodule
//
//  Created by QTS Coder on 10/2/17.
//  Copyright © 2017 QTS. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static var share = AppDelegate()

    func removeAllValueObject()
    {
        userDefault.removeObject(forKey: SCORE_PART1)
        userDefault.removeObject(forKey: SCORE_PART2)
        userDefault.removeObject(forKey: SCORE_PART3)
        userDefault.removeObject(forKey: SCORE_PART4)
        userDefault.removeObject(forKey: FIRSTNAME_STRING)
        userDefault.removeObject(forKey: MIDDLENAME_STRING)
        userDefault.removeObject(forKey: LASTNAME_STRING)
        userDefault.removeObject(forKey: NATIVE_STRING)
        userDefault.removeObject(forKey: SUFFIX_STRING)
        userDefault.removeObject(forKey: LASTNAMEFIRST_STRING)
        userDefault.removeObject(forKey: BIRTHDAY_STRING)
        userDefault.removeObject(forKey: COUNTRYOFBIRTH_STRING)
        userDefault.removeObject(forKey: ADDRESS1_STRING)
        userDefault.removeObject(forKey: ADDRESS2_STRING)
        userDefault.removeObject(forKey: ADDRESS3_STRING)
        userDefault.removeObject(forKey: CITY_STRING)
        userDefault.removeObject(forKey: COUNTRY_STRING)
        userDefault.removeObject(forKey: EMAIL_STRING)
        userDefault.removeObject(forKey: PHONE_STRING)
        userDefault.removeObject(forKey: NATIONALITY_STRING)
        userDefault.removeObject(forKey: ETHNIC_STRING)
        userDefault.removeObject(forKey: STATUS_STRING)
        userDefault.removeObject(forKey: RELIGION_STRING)
        userDefault.removeObject(forKey: GENDER_STRING)
        userDefault.removeObject(forKey: USERNAME_STRING)
        userDefault.removeObject(forKey: PASSWORD_STRING)
        userDefault.removeObject(forKey: CODE_STRING)
        userDefault.removeObject(forKey: NOTIFI_ERROR)
        userDefault.removeObject(forKey: USERID_STRING)
        userDefault.synchronize()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        
        // Initialize sign-in G+
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError!)")
        
        // Initialize sign-in  FB
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        print("\n\nSimulator path",FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0])
        AudioRecorderManager.shared.setup()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        print("\nURL SCHEME:->",url.scheme as Any)
        
        if url.scheme?.hasPrefix("fb") == true {
            
            return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
            
        }
        
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        removeAllValueObject()
    }


}

