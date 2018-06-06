//
//  HomeViewController.swift
//  PlanIt
//
//  Created by Karla Pantelimon on 19/05/2018.
//  Copyright © 2018 Karla Pantelimon. All rights reserved.
//

import UIKit
import AFNetworking

class HomeViewController: UITableViewController {

//    @IBOutlet weak var allProjects: UITableView! = nil
    @IBOutlet var projectsTableView: UITableView!
    
    var projects : [Projects] = []
    let userDefaults = UserDefaults.standard
    var searchedProjects: [Projects] = [];
    private let refreshCtrl = UIRefreshControl()
    let manager = AFHTTPSessionManager()
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBAction func goToProjectPage(_ sender: Any) {
        let i = (sender as! UIButton).tag;
        let admin =  self.projects[i].admin;
        var project :Projects;
        if isFiltering() {
            project = self.searchedProjects[i]
        } else {
            project = self.projects[i]
        }
        if(admin == true){
            let adminProjectView = storyboard?.instantiateViewController(withIdentifier: "AdminProjectView") as! AdminProjectCollectionViewController;
            adminProjectView.project = project;
            navigationController?.pushViewController(adminProjectView, animated: false);
        }else {
            let projectView = storyboard?.instantiateViewController(withIdentifier: "ProjectView") as! ProjectViewController;
            projectView.project = project;
            navigationController?.pushViewController(projectView, animated: false);
        }
        print(sender);
    }
    
 
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func setUpNavigationBar() -> Void{
    
    }
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = UIColor.black;
        
//        navigationController?.navigationBar.clipsToBounds = true;
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Project"
        searchController.searchBar.setShowsCancelButton(true, animated: false)
        searchController.searchBar.delegate = self;
        searchController.searchBar.isTranslucent = true
        searchController.searchBar.alpha = 1
//        searchController.searchBar.setSearchFieldBackgroundImage(UIImage(), for: .normal)
        searchController.searchBar.barTintColor = UIColor(red: 74/255.0, green: 146/255.0, blue: 161/255.0, alpha: 1.0)
//        searchController.searchBar.setSearchFieldBackgroundImage(UIImage(), for: .normal)
//        searchController.searchBar.backgroundColor = UIColor.black;
        searchController.searchBar.tintColor = UIColor.white;
//        searchController.searchBar.barTintColor = UIColor(red: 74/255.0, green: 146/255.0, blue: 161/255.0, alpha: 1.0)
//        (searchController.searchBar.value(forKey: "searchField") as? UITextField)?.textColor = UIColor.black
//        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)
        
        definesPresentationContext = true

        refreshCtrl.addTarget(self, action: #selector(HandleRefresh(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshCtrl
        } else {
            tableView.addSubview(refreshControl!)
        }
        
        if(userDefaults.object(forKey: "projects") != nil){
            let decoded  = userDefaults.object(forKey: "projects") as! Data
            self.projects = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [Projects]
        }
        self.getUserProjects(id: self.userDefaults.string(forKey: "id")!);
        // Do any additional setup after loading the view.
        
    }

    func parseJsonToProject(projectData: Any) -> Projects{
        let project = Projects();
        if let admin = ((projectData as! Dictionary<String, AnyObject>)["admin"] as? Bool) {
            project.admin = admin;
        }
        let info = (projectData as! Dictionary<String, AnyObject>)["project"] as! Dictionary<String, AnyObject> ;
        print(info);
        if let name = (info["name"] as? String) {
            project.name = name;
        }
        
        if let desc = info["description"] as? String {
            project.desc = desc;
        }
        
        if let id = info["id"] as? Int32 {
            project.id = id;
        }
        
        if let date = info["startDate"] as? String {
            project.startDate = date;
        }
        
        if let date = info["finishDate"] as? String {
            project.finishDate = date;
        }
        return project;
    }
    
    func getUserProjects(id: String) -> Void{
        manager.requestSerializer = AFJSONRequestSerializer();
        manager.responseSerializer = AFJSONResponseSerializer();
        manager.get("http://127.0.0.1:8080/planit/projects/selectProjects?id=" + id, parameters: nil, success: { (urlSession:URLSessionDataTask!, response:Any) in
            let jsonResult = response as! Dictionary<String, AnyObject>;
            
            let json = jsonResult["projects"] as! NSArray;
            
            var proj = [Projects]();
            
            for projectData in json {
                let project = self.parseJsonToProject(projectData: projectData);
                proj.append(project)
            }
            self.projects = proj;
            
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: self.projects)
            self.userDefaults.set(encodedData, forKey: "projects")
            self.projectsTableView.reloadData()
            
        },failure: { (urlSession:URLSessionDataTask!, error:Error!) in
            print("fail");
            let error = error as NSError
            print("Failure, error is \(error.userInfo)")
            self.projectsTableView.reloadData();
        })
    }
    

    
    @objc func HandleRefresh(_ refreshControl: UIRefreshControl) {
        // Code to refresh table view
       guard let id = self.userDefaults.string(forKey: "id")
        else {
            print("nu se poate boss");
            return;
        }
        self.getUserProjects(id: id)
        refreshControl.endRefreshing();
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return self.searchedProjects.count
        }
        return self.projects.count
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    
    
    override  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
            let cellIdentifier = "ProjectCell"
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ProjectTableViewCell
            else {
                fatalError("The dequeued cell is not an instance of ProjectTableViewCell.")
            }
            var project: Projects;
            if isFiltering() {
                project = self.searchedProjects[indexPath.row]
            } else {
                project = self.projects[indexPath.row]
            }
            let startDate = Date(timeIntervalSince1970: TimeInterval(project.startDate)!);
            let finishDate = Date(timeIntervalSince1970: TimeInterval(project.finishDate)!);
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = " HH:mm dd-MM-yyyy" //Specify your format that you want
            cell.startDate.text = dateFormatter.string(from: startDate)
            cell.cellButton.tag = indexPath.row;
            cell.titleLabel.text = project.name;
            cell.daysLabel.text = String(2);
            cell.descriptionLabel.text = project.desc;
            if(project.admin == true ){
                cell.adminButton.isHidden = false
            }
       
            return cell;
      
    }
    
   
    @IBAction func doMakeSearchAppear(_ sender: Any) {
        if projectsTableView.tableHeaderView != searchController.searchBar {
            projectsTableView.tableHeaderView = searchController.searchBar;
            searchController.searchBar.becomeFirstResponder();
        }else {
            searchController.searchBar.resignFirstResponder();
            projectsTableView.tableHeaderView = nil
        }
        
    }
    
    @objc
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "AddProjectSegue"){
            if let modalView = segue.destination as? AddViewController {
                modalView.type = "project";
            }
        }
        
    }
    
}

extension HomeViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        searchedProjects = projects.filter({( project : Projects) -> Bool in
            return project.name.lowercased().contains(searchText.lowercased())
        })
        
        projectsTableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
       filterContentForSearchText(searchController.searchBar.text!)
    }
}

extension HomeViewController: UISearchBarDelegate{
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searchController.searchBar.resignFirstResponder();
        projectsTableView.tableHeaderView = nil;
    }
    
    
    
}
