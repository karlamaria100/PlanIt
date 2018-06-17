//
//  TasksTableViewController.swift
//  PlanIt
//
//  Created by Karla Pantelimon on 01/06/2018.
//  Copyright © 2018 Karla Pantelimon. All rights reserved.
//

import UIKit


class TasksTableViewController: UITableViewController {
    
    
    @IBOutlet var tasksTableView: UITableView!
    
    var tasks: [Task] = [];
    var project = Projects();
    var category = Category();
    let userDefaults = UserDefaults.standard;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Tasks";
        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false
        self.getTasksForProject();
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    func getTasksForProject() -> Void {
    
        
//        manager.get("http://127.0.0.1:8080/planit/tasks/getAllTasksForProject?id=" + String(self.project.id), parameters: nil, success: { (urlSession:URLSessionDataTask!, response:Any) in
//            let jsonResult = response as! Dictionary<String, AnyObject>;
//
//            if(jsonResult["tasks"] != nil){
//                let json = jsonResult["tasks"] as! NSArray;
//
//                var tsk = [Task]();
//
//                for taskData in json {
//                    let task = self.parseJsonWithData(categoryData: taskData);
//                    tsk.append(task)
//                }
//                self.tasks = tsk;
//            }
//            else{
//                self.tasks = [];
//            }
//            //            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: self.projects)
//            //            self.userDefaults.set(encodedData, forKey: "projects")
//            self.tasksTableView.reloadData()
//
//        },failure: { (urlSession:URLSessionDataTask!, error:Error!) in
//            print("fail");
//            let error = error as NSError
//            print("Failure, error is \(error.userInfo)")
//            self.tasksTableView.reloadData();
//        })
    }
    
    func parseJsonWithData(categoryData: Any) -> Task{
        let category = Task();
        if let desc = ((categoryData as! Dictionary<String, AnyObject>)["description"] as? String) {
            category.desc = desc;
        }
        if let id = ((categoryData as! Dictionary<String, AnyObject>)["number"] as? Int32) {
            category.id = id;
        }
        if let date = ((categoryData as! Dictionary<String, AnyObject>)["date"] as? String) {
            category.date = date;
        }
        if let project = ((categoryData as! Dictionary<String, AnyObject>)["project"] as? Int32) {
            category.project = project;
        }
        if let done = ((categoryData as! Dictionary<String, AnyObject>)["done"] as? Bool) {
            category.done = done;
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
        return self.tasks.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as? TaskTableViewCell
        else {
            fatalError("The dequeued cell is not an instance of ProjectTableViewCell.")
        }
        var task: Task;
        task = self.tasks[indexPath.row]
        cell.descriptionLabel.text = task.desc;

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
