//
//  UserNetworkManager.swift
//  PlanIt
//
//  Created by Karla Pantelimon on 11/06/2018.
//  Copyright © 2018 Karla Pantelimon. All rights reserved.
//

import Foundation
import Alamofire

class UserNetworkManager{
    
    let userDefaults = UserDefaults.standard;
    private static let instance: UserNetworkManager = UserNetworkManager();
    private let url = "http://127.0.0.1:8080/planit/users";
    var internetOn: Bool = false;
    
    private init() {
        
    }
    
    class func shared() -> UserNetworkManager {
        return instance
    }
    
    func addUser(parameters: Dictionary<String, AnyObject>) -> Void{

        print(parameters);
        Alamofire.request(self.url+"/add", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type" :"application/json"]).responseJSON { response in
//            print("Request: \(String(describing: response.request))")   // original url request
//            print("Response: \(String(describing: response.response))") // http url response
//            print("Result: \(response.result)")                         // response serialization result
            
            switch response.result {
            case .success (let json):
            
                let jsonResult = json as! Dictionary<String, AnyObject>
                let userInfo = jsonResult["user"] as! Dictionary<String, AnyObject>;
                self.userDefaults.set(userInfo["id"], forKey: "id");
                
                let appDelegate = UIApplication.shared.delegate! as! AppDelegate
                let story = UIStoryboard(name: "Main", bundle: nil)
                let mainView = story.instantiateViewController(withIdentifier: "MainPage") as! MainViewController;
                appDelegate.window?.rootViewController = mainView
                appDelegate.window?.makeKeyAndVisible();
                
                break
            case .failure(let error):
                if(self.userDefaults.string(forKey: "id") != nil){
                    let appDelegate = UIApplication.shared.delegate! as! AppDelegate
                    let story = UIStoryboard(name: "Main", bundle: nil)
                    let mainView = story.instantiateViewController(withIdentifier: "MainPage") as! MainViewController;
                    appDelegate.window?.rootViewController = mainView
                    appDelegate.window?.makeKeyAndVisible();
                }
                print(error)
            }
        }
    }
    

}
