//
//  FoldersTableViewController.swift
//  PlanIt
//
//  Created by Karla Pantelimon on 01/06/2018.
//  Copyright © 2018 Karla Pantelimon. All rights reserved.
//

import UIKit
import Alamofire


class FoldersTableViewController: UITableViewController {

    @IBOutlet var foldersTabelView: UITableView!
    
    var folders: [Folder] = [];
    var project = Projects();
    var category = Category();
    let userDefaults = UserDefaults.standard;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Folders";
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = true;
        self.getFoldersForProject(id: String(self.project.id))
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action:nil);
//        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(enableEdit)),UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(doAddFolder))]
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
        
    }
    
    func getFoldersForProject(id: String) -> Void {
        
        Alamofire.request("http://127.0.0.1:8080/planit/folders/getAllFoldersForProject?id=" + id, method: .get, encoding: JSONEncoding.default, headers: ["Content-Type" :"application/json"]).responseJSON { response in
            
            switch response.result {
            case .success (let json):
                
                let jsonResult = json as! Dictionary<String, AnyObject>;
                
                if(jsonResult["folders"] != nil){
                    let json = jsonResult["folders"] as! NSArray;
                    var fld = [Folder]();
                
                    for folderData in json {
                        let folder = self.parseJsonWithData(categoryData: folderData);
                        fld.append(folder)
                    }
                    self.folders = fld;
                    let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: self.folders)
                    self.userDefaults.set(encodedData, forKey: "folders")
                    self.foldersTabelView.reloadData()
                    SharedService.shared().internetOn = true;
                    break
            }
            case .failure(let error):
                SharedService.shared().internetOn = false;
                self.foldersTabelView.reloadData()
                print(error)
            }
        }
        
        
//        manager.get("http://127.0.0.1:8080/planit/folders/getAllFoldersForProject?id=" + String(self.project.id), parameters: nil, success: { (urlSession:URLSessionDataTask!, response:Any) in
//            let jsonResult = response as! Dictionary<String, AnyObject>;
//
//            if(jsonResult["folders"] != nil){
//                let json = jsonResult["folders"] as! NSArray;
//
//                var fld = [Folder]();
//
//                for folderData in json {
//                    let folder = self.parseJsonWithData(categoryData: folderData);
//                    fld.append(folder)
//                }
//                self.folders = fld;
//            }else{
//                self.folders = [];
//            }
//
//            //            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: self.projects)
//            //            self.userDefaults.set(encodedData, forKey: "projects")
//            self.foldersTabelView.reloadData()
//
//        },failure: { (urlSession:URLSessionDataTask!, error:Error!) in
//            print("fail");
//            let error = error as NSError
//            print("Failure, error is \(error.userInfo)")
//            self.foldersTabelView.reloadData();
//        })
    }
    
    func parseJsonWithData(categoryData: Any) ->Folder{
        let category = Folder();
        if let id = ((categoryData as! Dictionary<String, AnyObject>)["number"] as? Int32) {
            category.id = id;
        }
        if let name = ((categoryData as! Dictionary<String, AnyObject>)["name"] as? String) {
            category.name = name;
        }
        if let project = ((categoryData as! Dictionary<String, AnyObject>)["project"] as? Dictionary<String, AnyObject>) {
            category.project = project["id"] as! Int32;
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
        return self.folders.count+1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row < self.folders.count){
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FolderCell", for: indexPath) as? FolderTableViewCell
                else {
                    fatalError("The dequeued cell is not an instance of ProjectTableViewCell.")
            }
            var folder: Folder;
            folder = self.folders[indexPath.row]
            cell.nameField.text = folder.name;
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddNewRow", for: indexPath) as? InsertRowTableViewCell;
            return cell!
        }
        
        

        
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
