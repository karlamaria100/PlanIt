//
//  ListsTableViewController.swift
//  PlanIt
//
//  Created by Karla Pantelimon on 01/06/2018.
//  Copyright © 2018 Karla Pantelimon. All rights reserved.
//

import UIKit
import Alamofire


class ListsTableViewController: UITableViewController, UITextFieldDelegate {
    
    
    @IBOutlet var listsTableView: UITableView!
    
    var lists: [List] = [];
    var project = Projects();
    var category = Category();
    let userDefaults = UserDefaults.standard;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Lists";
         self.clearsSelectionOnViewWillAppear = true
        self.getListsForProject( id: String(self.project.id));
         self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action:nil);
//        self.navigationItem.rightBarButtonItems = [self.editButtonItem,UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(doAddList))]
    }
    
    @objc func doAddList(){
        
    }

    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let rowToMove = self.lists[sourceIndexPath.row]
        self.lists.remove(at: sourceIndexPath.row)
        self.lists.insert(rowToMove, at: destinationIndexPath.row);
    }
    
    func getListsForProject(id: String) -> Void {
    
        Alamofire.request("http://127.0.0.1:8080/planit/lists/getAllListsForProject?id=" + id, method: .get, encoding: JSONEncoding.default, headers: ["Content-Type" :"application/json"]).responseJSON { response in
            
            switch response.result {
            case .success (let json):
                
                let jsonResult = json as! Dictionary<String, AnyObject>;
                
                if(jsonResult["lists"] != nil){
                let js = jsonResult["lists"] as! NSArray;
                
                var lst = [List]();
                
                for listData in js {
                    let list = self.parseJsonWithData(categoryData: listData);
                    lst.append(list)
                }
                self.lists = lst;
                let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: self.lists)
                self.userDefaults.set(encodedData, forKey: "lists")
                self.listsTableView.reloadData()
                SharedService.shared().internetOn = true;
                break
            }
            case .failure(let error):
                SharedService.shared().internetOn = false;
                self.listsTableView.reloadData()
                print(error)
            }
        }
    }
    
    
    
    func parseJsonWithData(categoryData: Any) -> List{
        let category = List();
        if let desc = ((categoryData as! Dictionary<String, AnyObject>)["description"] as? String) {
            category.desc = desc;
        }
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
        let addRow = tableView.isEditing ? 1:0;
        return self.lists.count + addRow;
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as? ListTableViewCell
        else {
                fatalError("The dequeued cell is not an instance of ProjectTableViewCell.")
        }
        var list: List;
        if(indexPath.row >= self.lists.count && tableView.isEditing){
           
            cell.nameField.text = "Add List";
            cell.nameField.delegate = self;
            cell.nameField.isUserInteractionEnabled = true;
        }else{
             list = self.lists[indexPath.row]
            cell.nameField.text = list.name;
            cell.nameField.delegate = self;
            
        }
        

        return cell
    }
 
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        if( tableView.isEditing && indexPath.row == self.lists.count){
            return UITableViewCellEditingStyle.insert
        }
        return UITableViewCellEditingStyle.delete
    }
    
 
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated);
        let path = IndexPath(row: self.lists.count, section: 0)
        if(isEditing){
            self.listsTableView.setEditing(true, animated: true);
            self.listsTableView.beginUpdates()
            self.listsTableView.insertRows(at: [path], with: UITableViewRowAnimation.left)
            self.listsTableView.endUpdates();
            for i in 0...self.lists.count{
                let index = IndexPath(row: i, section: 0);
                (self.listsTableView.cellForRow(at: index) as! ListTableViewCell).nameField.isUserInteractionEnabled = true;
            }
        }
        else{
            self.listsTableView.setEditing(false, animated: true);
            self.listsTableView.beginUpdates()
            self.listsTableView.deleteRows(at: [path], with: UITableViewRowAnimation.left)
            for i in 0...self.lists.count-1{
                let index = IndexPath(row: i, section: 0);
                (self.listsTableView.cellForRow(at: index) as! ListTableViewCell).nameField.isUserInteractionEnabled = false;
            }
            self.listsTableView.endUpdates();
        }
        
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            self.listsTableView.deleteRows(at: [indexPath], with: .fade)
            self.lists.remove(at: indexPath.row);
            
        } else if editingStyle == .insert {
            let cell = tableView.cellForRow(at: indexPath) as! ListTableViewCell;
            cell.nameField.resignFirstResponder();
            var list = List();
            list.name = cell.nameField.text!;
            self.lists.append(list);
            let secondIndex = IndexPath(row: self.lists.count, section: 0)
            self.listsTableView.beginUpdates()
            self.listsTableView.insertRows(at: [secondIndex], with: UITableViewRowAnimation.none)
            self.listsTableView.endUpdates();
            (self.listsTableView.cellForRow(at: secondIndex) as! ListTableViewCell).nameField.text = "Add List"
            (self.listsTableView.cellForRow(at: secondIndex) as! ListTableViewCell).nameField.isUserInteractionEnabled = true;
            
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable
        if(tableView.isEditing && indexPath.row == self.lists.count){
            return false;
        }
        return true
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "AddProjectSegue"){
            if let listView = segue.destination as? ListTableViewController {
                //get indexpath from sender
//                listView.list = self.lists[];
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        textField.resignFirstResponder();
        return false
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.placeholder = textField.text
        return true;
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if(textField.text?.replacingOccurrences(of: " ", with: "") == ""){
            textField.text = textField.placeholder
            textField.placeholder = "";
        }
        return true;
    }
    

    
}


