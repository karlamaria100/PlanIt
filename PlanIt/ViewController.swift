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
import GoogleSignIn
import Alamofire

class ViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var loginButton: UIButton!
    let userDefaults = UserDefaults.standard
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func doForgotPassword(_ sender: Any) {
    }
    
    @IBAction func doSignUp(_ sender: Any) {
        
    }
    @IBAction func doLogin(_ sender: Any) {
        if((passwordField.text?.count)! < 6){
            passwordField.layer.borderColor = UIColor.red.cgColor;
            passwordField.layer.borderWidth = 1;
        }
        
        let param: Dictionary<String, AnyObject> = ["email": emailField.text as AnyObject, "password": passwordField.text as AnyObject ];
//        UserNetworkManager.shared().loginUser()
        


        //check if info respect type
    }
    
    
    
    @IBAction func doDriveLogin(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn();
        print("After Login")
    }
    
    
    @IBAction func doFacebookLogin(_ sender: UIButton) {
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile","email"], from: self) { (result, error) -> Void in
            if (error == nil){
                let fbLoginResult : FBSDKLoginManagerLoginResult = result!
                if( fbLoginResult.grantedPermissions != nil){
                    print(fbLoginResult.grantedPermissions)
                    self.getFacebookData();
                }
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
  

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
         self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getFacebookData() {
            //show loader
        let req = FBSDKGraphRequest(graphPath: "/me", parameters: ["fields":"email, name, picture, id, last_name, first_name"], tokenString: FBSDKAccessToken.current().tokenString, version: nil, httpMethod: "GET")
        
        req!.start {(connection: FBSDKGraphRequestConnection?, result: Any?, error: Error?) in
            if(error == nil)
            {
                let userData = result as? [String:AnyObject]
        
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
                
                
                let param :Dictionary<String, AnyObject> = ["email": email as AnyObject, "facebookId": id as AnyObject, "name": name as AnyObject,"surname":surname as AnyObject, "profileImage":picture as AnyObject];
                //loader on
                UserNetworkManager.shared().addUser(parameters: param);
                
            }
            else
            {
                if(self.userDefaults.string(forKey: "id") != nil){
                    let appDelegate = UIApplication.shared.delegate! as! AppDelegate
                    let mainView = self.storyboard?.instantiateViewController(withIdentifier: "MainPage") as! MainViewController;
                    appDelegate.window?.rootViewController = mainView
                    appDelegate.window?.makeKeyAndVisible();
                }
            }
        };
    }




}

