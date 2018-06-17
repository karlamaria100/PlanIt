//
//  ProjectsTableViewController.swift
//  PlanIt
//
//  Created by Karla Pantelimon on 18/05/2018.
//  Copyright © 2018 Karla Pantelimon. All rights reserved.
//

import UIKit


class ProjectsTableViewController: UITableViewController {

//    @IBOutlet weak var projectsLits: UITableViewCell!
    var projects = NSArray()
    let userDefault = UserDefaults.standard
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var tableCell: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let decoded  = self.userDefault.object(forKey: "projects") as! Data
        self.projects = (NSKeyedUnarchiver.unarchiveObject(with: decoded) as! NSArray)
//        manager.post("http://l127.0.0.1:8080/planit/projects/userProjects", parameters: param, success: { (urlSession, response) in
//            print("success");
//        }) { (urlSession, error) in
//            print("fail");
//        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        return projects.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell2", for: indexPath) as? AdminTableViewCell
        else {
            fatalError("The dequeued cell is not an instance of AdminTableViewCell.")
        }
//        cell.titleLabel.text = ((self.projects[indexPath.row] as! Dictionary<String, AnyObject>)["project"] as! Dictionary<String,AnyObject>)["name"] as? String;
    
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
