//
//  ViewController.swift
//  PlanIt
//
//  Created by Karla Pantelimon on 18/05/2018.
//  Copyright © 2018 Karla Pantelimon. All rights reserved.
//


import UIKit
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit
import AVFoundation
import AFNetworking
import GoogleSignIn

class ViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var loginButton: UIButton!
    let userDefaults = UserDefaults.standard
    
    
    @IBAction func doForgotPassword(_ sender: Any) {
    }
    
    @IBAction func doSignUp(_ sender: Any) {
        
    }
    @IBAction func doLogin(_ sender: Any) {
        
//        let manager = AFHTTPSessionManager()
//        manager.requestSerializer = AFJSONRequestSerializer();
//        manager.responseSerializer = AFJSONResponseSerializer();
//        let param :NSDictionary = ["email": email, "facebookId": id, "name": name,"surname":surname, "profileImage":picture];
//        manager.post("http://127.0.0.1:8080/planit/users/add", parameters:param , success: { (urlSession, response)  in
//            let jsonResult = response as! Dictionary<String, AnyObject>
//            // do whatever with jsonResult
//            let userInfo = jsonResult["user"] as! Dictionary<String, AnyObject>;
//            self.userDefaults.set(userInfo["id"], forKey: "id")
//            //                    let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: jsonResult["projects"] as Any)
//            //                    self.userDefaults.set(encodedData, forKey: "projects")
//            //                    self.userDefaults.synchronize()
//            //                    print("is logged in")
//            
//        },failure: { (urlSession:URLSessionDataTask!, error) in
//            let error = error as NSError
//            print("Failure, error is \(error.userInfo)")
//            //check if error is from not having internet or back failure and print message
//        })

        //check if info respect type
    }
    
    
    
    @IBAction func doDriveLogin(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn();
        print("After Login")
//        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
//        let mainView = self.storyboard?.instantiateViewController(withIdentifier: "MainPage") as! MainViewController;
//        appDelegate.window?.rootViewController = mainView
//        appDelegate.window?.makeKeyAndVisible()
    }
    
    
    @IBAction func doFacebookLogin(_ sender: UIButton) {
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile","email"], from: self) { (result, error) -> Void in
            if (error == nil){
                let fbLoginResult : FBSDKLoginManagerLoginResult = result!
                print(fbLoginResult.grantedPermissions)
                self.getFacebookData();
            }
        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if (FBSDKAccessToken.current() != nil) {
            self.getFacebookData();
        }else{
            GIDSignIn.sharedInstance().uiDelegate = self
            if GIDSignIn.sharedInstance().hasAuthInKeychain() {
                /* Code to show your tab bar controller */
                let appDelegate = UIApplication.shared.delegate! as! AppDelegate
                let mainView = self.storyboard?.instantiateViewController(withIdentifier: "MainPage") as! MainViewController;
                appDelegate.window?.rootViewController = mainView
                appDelegate.window?.makeKeyAndVisible()
                
                //make request
            } else {
                /* code to show your login VC */
            }
        }
  
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getFacebookData() {
            //show loader
        if(self.userDefaults.string(forKey: "id") != nil){
            let appDelegate = UIApplication.shared.delegate! as! AppDelegate
            let mainView = self.storyboard?.instantiateViewController(withIdentifier: "MainPage") as! MainViewController;
            appDelegate.window?.rootViewController = mainView
            appDelegate.window?.makeKeyAndVisible();
        }
            // either add him by fbaccess token or make a request to get his db info
        let req = FBSDKGraphRequest(graphPath: "/me", parameters: ["fields":"email, name, picture, id, last_name, first_name"], tokenString: FBSDKAccessToken.current().tokenString, version: nil, httpMethod: "GET")
        
        req!.start {(connection: FBSDKGraphRequestConnection?, result: Any?, error: Error?) in
            if(error == nil)
            {
                let userData = result as? [String:AnyObject]
                    
                    // Access user data
        
                let name = userData!["first_name"] as? String
                let surname = userData!["last_name"] as? String
                let email  = userData!["email"] as? String
                let id = userData!["id"] as? String
                let picture = "https://graph.facebook.com/"+id!+"/picture?type=normal";
                
                self.userDefaults.set( email , forKey: "email");
                self.userDefaults.set(name, forKey: "first_name");
                self.userDefaults.set(surname, forKey: "last_name");
                self.userDefaults.set(id, forKey: "facebookId");
                self.userDefaults.set(picture, forKey: "profilePicture")
                
                let manager = AFHTTPSessionManager()
                manager.requestSerializer = AFJSONRequestSerializer();
                manager.responseSerializer = AFJSONResponseSerializer();
                let param :NSDictionary = ["email": email as Any, "facebookId": id, "name": name,"surname":surname, "profileImage":picture];
                manager.post("http://127.0.0.1:8080/planit/users/add", parameters:param , success: { (urlSession, response)  in
                    let jsonResult = response as! Dictionary<String, AnyObject>
                    // do whatever with jsonResult
                    let userInfo = jsonResult["user"] as! Dictionary<String, AnyObject>;
                    if(self.userDefaults.string(forKey: "id") == nil){
                        self.userDefaults.set(userInfo["id"], forKey: "id")
                        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
                        let mainView = self.storyboard?.instantiateViewController(withIdentifier: "MainPage") as! MainViewController;
                        appDelegate.window?.rootViewController = mainView
                        appDelegate.window?.makeKeyAndVisible();
                    }
                },failure: { (urlSession:URLSessionDataTask!, error) in
                    let error = error as NSError
                    print("Failure, error is \(error.userInfo)")
                
                    //check if error is from not having internet or back failure and print message
                })
            }
            else
            {
                // show error modal
            }
        };
        // User is logged in, do work such as go to next view controller.
    }



}

