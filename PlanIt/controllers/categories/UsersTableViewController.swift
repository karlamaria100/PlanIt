//
//  UsersTableViewController.swift
//  PlanIt
//
//  Created by Karla Pantelimon on 01/06/2018.
//  Copyright © 2018 Karla Pantelimon. All rights reserved.
//

import UIKit
import AFNetworking
import ImageLoader

class UsersTableViewController: UITableViewController {
    
    @IBOutlet var usersTabelView: UITableView!
    @IBOutlet var addButton: UIButton!
    
    var users: [User] = [];
    var project = Projects();
    var category = Category();
    let manager = AFHTTPSessionManager()
    let userDefaults = UserDefaults.standard;

    
    @IBAction func doAddUser(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Users";

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false
        self.getUsersForProject();
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//         self.navigationItem.rightBarButtonItem = self.editButtonItem
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(doAddUser(_:)));
//        let button = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(doAddUser(_:)));
//        button.image = self.addButton.currentImage;
//        button.image.
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action:nil);
//        self.navigationItem.setRightBarButtonItems([self.addButton, self.editButtonItem], animated: false) ;
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(doAddUser(_:))),UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(doAddUser(_:))), ]
        
    }

    func getUsersForProject() -> Void {
        manager.requestSerializer = AFJSONRequestSerializer();
        manager.responseSerializer = AFJSONResponseSerializer();
        
        manager.get("http://127.0.0.1:8080/planit/users/getAllUsersForProject?id=" + String(self.project.id), parameters: nil, success: { (urlSession:URLSessionDataTask!, response:Any) in
            let jsonResult = response as! Dictionary<String, AnyObject>;
            
            if(jsonResult["users"] != nil){
                let json = jsonResult["users"] as! NSArray;
                
                var usr = [User]();
                
                for userData in json {
                    let user = self.parseJsonWithData(categoryData: userData);
                    usr.append(user)
                }
                self.users = usr;
            }else{
                self.users = [];
            }
            
            //            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: self.projects)
            //            self.userDefaults.set(encodedData, forKey: "projects")
            self.usersTabelView.reloadData()
            
        },failure: { (urlSession:URLSessionDataTask!, error:Error!) in
            print("fail");
            let error = error as NSError
            print("Failure, error is \(error.userInfo)")
            self.usersTabelView.reloadData();
        })
    }
    
    func parseJsonWithData(categoryData: Any) -> User{
        let category = User();
        if let name = ((categoryData as! Dictionary<String, AnyObject>)["name"] as? String) {
            category.name = name;
        }
        if let id = ((categoryData as! Dictionary<String, AnyObject>)["number"] as? Int32) {
            category.id = id;
        }
        if let email = ((categoryData as! Dictionary<String, AnyObject>)["email"] as? String) {
            category.email = email;
        }
        if let profilePicture = ((categoryData as! Dictionary<String, AnyObject>)["profilePicture"] as? String) {
            category.profilePicture = profilePicture;
        }
        return category;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.users.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserTableViewCell
        else {
            fatalError("The dequeued cell is not an instance of ProjectTableViewCell.")
        }
        var user: User;
        user = self.users[indexPath.row]
        cell.nameLabel.text = user.name;
        cell.profileImage.load.request(with: user.profilePicture);

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "AddUserSegue"){
            if let modalView = segue.destination as? AddViewController {
                modalView.type = "user";
            }
        }
    }


}
