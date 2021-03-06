//
//  PublicViewController.swift
//  PlanIt
//
//  Created by Karla Pantelimon on 31/05/2018.
//  Copyright © 2018 Karla Pantelimon. All rights reserved.
//

import UIKit
import Alamofire

class PublicViewController: UIViewController{
    
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var finishDateLabel: UILabel!

    
    @IBOutlet weak var tasksLabel: UILabel!
    @IBOutlet weak var filesLabel: UILabel!
    @IBOutlet weak var usersLabel: UILabel!
    @IBOutlet weak var listsLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var listsNameLabel: UILabel!
    @IBOutlet weak var tasksNameLabel: UILabel!
    @IBOutlet weak var filesNameLabel: UILabel!
    
    var categories: [Category] = [];
    var project: Projects = Projects();
    let userDefaults = UserDefaults.standard;
    
    
    @IBAction func goToUsers(_ sender: Any) {
        let categoryView = storyboard?.instantiateViewController(withIdentifier: "UsersView") as! UsersTableViewController;
        categoryView.project = project;
        navigationController?.navigationItem.title = ""
        navigationController?.pushViewController(categoryView, animated: false);
    }
    
    @IBAction func goToLists(_ sender: Any) {
        let categoryView = storyboard?.instantiateViewController(withIdentifier: "ListsView") as! ListsTableViewController;
        categoryView.project = project;
        navigationController?.pushViewController(categoryView, animated: false);
    }
    
    @IBAction func goToFolders(_ sender: Any) {
        let categoryView = storyboard?.instantiateViewController(withIdentifier: "FoldersView") as! FoldersTableViewController;
        categoryView.project = project;
        navigationController?.pushViewController(categoryView, animated: false);
    }
    
    @IBAction func goToTasks(_ sender: Any) {
        let categoryView = storyboard?.instantiateViewController(withIdentifier: "TasksView") as! TasksTableViewController;
        categoryView.project = project;
        navigationController?.pushViewController(categoryView, animated: false);
        
    }
  
    
    @IBAction func goToMaps(_ sender: Any) {
        
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            UIApplication.shared.openURL(URL(string:
                "comgooglemaps://?q="+self.project.address+"&center=40.765819,-73.975866&zoom=14&views=traffic")!)
        } else {
            print("Can't use comgooglemaps://");
        }
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellIdentifier = "PublicCell"
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? PublicCellCollectionViewCell
        else {
                fatalError("The dequeued cell is not an instance of ProjectTableViewCell.")
        }
        var category: Category;
        category = self.categories[indexPath.row]
        cell.numberLabel.text = String(category.total);
        cell.titleLabel.text = category.name;
        cell.cellButton.tag = indexPath.row;
        
        return cell;
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(enableEdit)),UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addUser))]

        let startDate = Date(timeIntervalSince1970: TimeInterval(project.startDate)!);
        let finishDate = Date(timeIntervalSince1970: TimeInterval(project.finishDate)!);
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "HH:mm dd-MM-yyyy" //Specify your format that you want
        self.startDateLabel.text =  dateFormatter.string(from: startDate);
        self.finishDateLabel.text =  dateFormatter.string(from: finishDate);
        
        self.getCategories();
        
        // Do any additional setup after loading the view.
    }
    
    @objc func enableEdit(){
        print("edit button");
        
    }
    
    @objc func addUser(){
        navigationController?.performSegue(withIdentifier: "AddUserSegue", sender: self);
    }
    
    func getCategories() -> Void {
        
        if(userDefaults.object(forKey: "categories") != nil){
            let decoded  = userDefaults.object(forKey: "categories") as! Data
            self.categories = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [Category]
        }
        Alamofire.request("http://127.0.0.1:8080/planit/projects/getCategories?id=" + String(self.project.id), method: .get, encoding: JSONEncoding.default, headers: ["Content-Type" :"application/json"]).responseJSON { response in
            
            switch response.result {
            case .success (let json):
                
                let jsonResult = json as! Dictionary<String, AnyObject>;
                
                let json = jsonResult["categories"] as! NSArray;
                
                var cat = [Category]();
                
                for categoryData in json {
                    let category = self.parseJsonToCategory(categoryData: categoryData);
                    cat.append(category)
                }
                self.categories = cat;
                
                let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: self.categories)
                self.userDefaults.set(encodedData, forKey: "categories")
                
                self.printCategories();
                
                SharedService.shared().internetOn = true;
                break
            case .failure(let error):
                SharedService.shared().internetOn = false;
                print(error)
            }
        }
        
    }
    
    func printCategories() -> Void {
        for category in self.categories{
            if(category.name == "Users" || category.name == "User"){
                self.usersLabel.text = String(category.total);
                self.userNameLabel.text = category.name;
            }else if(category.name == "Lists" || category.name == "List"){
                self.listsLabel.text = String(category.total);
                self.listsNameLabel.text = category.name;
            }else if(category.name == "Tasks" || category.name == "Task"){
                self.tasksLabel.text = String(category.total);
                self.tasksNameLabel.text = category.name;
            }else if(category.name == "Files" || category.name == "File"){
                self.filesLabel.text = String(category.total);
                self.filesNameLabel.text = category.name;
            }
        }
    }
    
    func parseJsonToCategory(categoryData: Any) -> Category{
        let category = Category();
        if let name = ((categoryData as! Dictionary<String, AnyObject>)["name"] as? String) {
            category.name = name;
        }
        if let total = ((categoryData as! Dictionary<String, AnyObject>)["number"] as? Int) {
            category.total = total;
        }
        return category;
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
