//
//  AppDelegate.swift
//  PlanIt
//
//  Created by Karla Pantelimon on 18/05/2018.
//  Copyright © 2018 Karla Pantelimon. All rights reserved.
//

import UIKit
import CoreData
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit
import GoogleSignIn
import IQKeyboardManagerSwift
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?
    let userDefaults = UserDefaults.standard


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:  [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        GIDSignIn.sharedInstance().clientID = "716119060999-8hu8k2lea459ma18ppngq60kjp666din.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        IQKeyboardManager.shared.enable = true
        // Override point for customization after application launch.
        return  FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
    }



    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let google = GIDSignIn.sharedInstance().handle(url,sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                                 annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        let fb = FBSDKApplicationDelegate.sharedInstance().application(app,
                                                                       open: url,
                                                                       sourceApplication: options[.sourceApplication] as! String,
                                                                       annotation: options[.annotation])
        
        return google || fb
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
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
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "PlanIt")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            // add or get info for user
            
            SharedService.shared().googleUser.email = user.profile.email;
            SharedService.shared().googleUser.name = user.profile.name;
            SharedService.shared().googleUser.profilePicture = "";
            if user.profile.hasImage{
                SharedService.shared().googleUser.profilePicture = user.profile.imageURL(withDimension: 200).absoluteString
            }
            
        
            let parameters : Dictionary<String, AnyObject> = ["email":user?.profile.email as AnyObject, "googleId": user.userID as AnyObject, "name": "" as AnyObject, "surname": user.profile.givenName as AnyObject, "profilePicture" :  SharedService.shared().googleUser.profilePicture as AnyObject] ;
            print(parameters)
            UserNetworkManager.shared().addUser(parameters: parameters)
           
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }

}

