//
//  ListTableViewController.swift
//  PlanIt
//
//  Created by Karla Pantelimon on 03/06/2018.
//  Copyright © 2018 Karla Pantelimon. All rights reserved.
//

import UIKit
import Alamofire

class ListTableViewController: UITableViewController {

    @IBOutlet var listTableView: UITableView!
    
    var list: List = List();
    var listItems: [ListItem] = [];
    let userDefaults = UserDefaults.standard;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = list.name;
         self.clearsSelectionOnViewWillAppear = true
        self.getListItems();
        //         self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    func getListItems() -> Void {
        
        Alamofire.request("http://127.0.0.1:8080/planit/listItems/getAllItemsForList?id=" + String(self.list.id)).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            
            
//            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//                print("Data: \(utf8Text)") // original server data as UTF8 string
//            }
        }
        
//        manager.get("http://127.0.0.1:8080/planit/listItems/getAllItemsForList?id=" + String(self.list.id), parameters: nil, success: { (urlSession:URLSessionDataTask!, response:Any) in
//            let jsonResult = response as! Dictionary<String, AnyObject>;
//
//            if(jsonResult["items"] != nil){
//                let json = jsonResult["items"] as! NSArray;
//
//                var lst = [ListItem]();
//
//                for listData in json {
//                    let list = self.parseJsonWithData(categoryData: listData);
//                    lst.append(list)
//                }
//                self.listItems = lst;
//            }
//            else{
//                self.listItems = [];
//            }
//
//            //            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: self.projects)
//            //            self.userDefaults.set(encodedData, forKey: "projects")
//            self.listTableView.reloadData()
//
//        },failure: { (urlSession:URLSessionDataTask!, error:Error!) in
//            print("fail");
//            let error = error as NSError
//            print("Failure, error is \(error.userInfo)")
//            self.listTableView.reloadData();
//        })
    }
    
    func parseJsonWithData(categoryData: Any) -> ListItem{
        let category = ListItem();
//        if let desc = ((categoryData as! Dictionary<String, AnyObject>)["description"] as? String) {
//            category.desc = desc;
//        }
//        if let id = ((categoryData as! Dictionary<String, AnyObject>)["number"] as? Int32) {
//            category.id = id;
//        }
//        if let name = ((categoryData as! Dictionary<String, AnyObject>)["name"] as? String) {
//            category.name = name;
//        }
//        if let project = ((categoryData as! Dictionary<String, AnyObject>)["project"] as? Dictionary<String, AnyObject>) {
//            category.project = project["id"] as! Int32;
//        }
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
        return self.listItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListItemCell", for: indexPath)

        // Configure the cell...

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
