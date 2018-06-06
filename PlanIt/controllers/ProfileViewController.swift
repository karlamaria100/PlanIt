//
//  ProfileViewController.swift
//  PlanIt
//
//  Created by Karla Pantelimon on 21/05/2018.
//  Copyright © 2018 Karla Pantelimon. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit
import ImageLoader

class ProfileViewController: UIViewController {

    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    let userDefault = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameLabel.text = self.userDefault.string(forKey: "first_name") as! String + " " + self.userDefault.string(forKey: "last_name")!;
        self.emailLabel.text = self.userDefault.string(forKey: "email");
        self.profilePic.load.request(with: self.userDefault.string(forKey: "profilePicture")!)
//        self.profilePic.image = self.userDefault.string(forKey: "profilePic");
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
