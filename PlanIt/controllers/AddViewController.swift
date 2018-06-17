//
//  AddViewController.swift
//  PlanIt
//
//  Created by Karla Pantelimon on 27/05/2018.
//  Copyright © 2018 Karla Pantelimon. All rights reserved.
//

import UIKit
import ImageLoader
import DateTimePicker
import Alamofire

class AddViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
    @IBAction func dismissPopup(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var usersTableView: UITableView!
   
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var finishDate: UIButton!
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var startDate: UIButton!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var addUserView: UIView!
    
    @IBOutlet weak var lowerValue: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var addProjectView: DesignableView!
    
    var type: String = "";
    var startDateField: UITextField = UITextField();
    var finishDateField: UITextField = UITextField();
    var searchedUsers : [User] = [];
    var users : [User] = [];
    var selectedUser : User = User();
    var filtering = false;
    var userIndex : IndexPath = IndexPath();
    let userDefaults = UserDefaults.standard;
    
    
    @IBAction func selectRow(_ sender: Any) {
        print("selected")
        
//        tableView.cellForRow(at: self.userIndex)?.backgroundColor = UIColor.white;
//        self.userIndex = indexPath;
//        self.selectedUser = self.searchedUsers[indexPath.row];
//        tableView.cellForRow(at: indexPath)?.backgroundColor = UIColor.gray;
    }
    
    
    @IBAction func doAdd(_ sender: Any) {
        //if project
        //make add request
        if(self.type == "project"){
            if(nameLabel.text != "" && descriptionText.text != "" && startDate.titleLabel?.text != "Start date" && finishDate.titleLabel?.text != "Finish date"){
                let formatter = DateFormatter()
//                formatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Set timezone that you want
                formatter.locale = NSLocale.current
                formatter.dateFormat = "dd-MM-yyyy HH:mm"
                let start = formatter.date(from: (self.startDate.titleLabel?.text)!);
                let finish = formatter.date(from: (self.finishDate.titleLabel?.text)!);
                if(finish?.compare(start!) == .orderedAscending){
                    lowerValue.isHidden = false;
                    startDate.layer.borderColor = UIColor.red.cgColor
                    startDate.layer.borderWidth = 1;
                    finishDate.layer.borderColor = UIColor.red.cgColor
                    finishDate.layer.borderWidth = 1;
                    return;
                }
                startDate.layer.borderWidth = 0;
                finishDate.layer.borderWidth = 0;
                lowerValue.isHidden = true;
            
                let param :NSDictionary = ["name": nameLabel.text, "description": descriptionText.text, "user":userDefaults.string(forKey: "id"), "startDate":start!.timeIntervalSince1970, "finishDay":finish!.timeIntervalSince1970];
//                manager.post("http://127.0.0.1:8080/planit/projects/add", parameters: param, success: { (urlSession:URLSessionDataTask!, response:Any) in
//                    let jsonResult = response as! Dictionary<String, AnyObject>
//                    // tell view controller to add project to the table view
//                    self.dismiss(animated: true, completion: nil);
//                },failure: { (urlSession:URLSessionDataTask!, error:Error!) in
//                    print("fail");
//                    let error = error as NSError
//                    print("Failure, error is \(error.userInfo)")
//                })
            }else {
                if(nameLabel.text == ""){
                    nameLabel.layer.borderColor = UIColor.red.cgColor;
                    nameLabel.layer.borderWidth = 1.0;
                }
                else {
                    nameLabel.layer.borderWidth = 0;
                }
                if(descriptionText.text == ""){
                    descriptionText.layer.borderColor=UIColor.red.cgColor
                    descriptionText.layer.borderWidth = 1;
                }
                else{
                    descriptionText.layer.borderWidth = 0;
                }
                if(startDate.titleLabel?.text == "Start date"){
                    startDate.layer.borderColor = UIColor.red.cgColor
                    startDate.layer.borderWidth = 1;
                }else{
                    startDate.layer.borderWidth = 0;
                }
                if(finishDate.titleLabel?.text == "Finish date"){
                    finishDate.layer.borderColor = UIColor.red.cgColor
                    finishDate.layer.borderWidth = 1;
                }else{
                    finishDate.layer.borderWidth = 0;
                }
                
            }
        }
        else if(self.type == "user"){
            
        }
        
    }

    
    @objc func doSelectDate(_ sender: Any) {
        if(self.startDateField.isFirstResponder){
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateStyle = .medium
            self.startDateField.resignFirstResponder()
        }else if(self.finishDateField.isFirstResponder){
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateStyle = .medium
            self.finishDateField.resignFirstResponder()
        }
        
    }
    
    @objc func cancelClick(_ sender: Any) {
        if(self.startDateField.isFirstResponder){
            self.startDateField.resignFirstResponder()
        }else if(self.finishDateField.isFirstResponder){
            self.finishDateField.resignFirstResponder()
        }
    }
    
    
    func parseJsonWithData(categoryData: Any) -> User{
        let category = User();
        if let name = ((categoryData as! Dictionary<String, AnyObject>)["name"] as? String) {
            category.name = name;
            if let surname = ((categoryData as! Dictionary<String, AnyObject>)["surname"] as? String){
                category.name = category.name + " " + surname;
            }
            
        }
        if let id = ((categoryData as! Dictionary<String, AnyObject>)["number"] as? Int32) {
            category.id = id;
        }
        if let email = ((categoryData as! Dictionary<String, AnyObject>)["email"] as? String) {
            category.email = email;
        }
        if let profilePicture = ((categoryData as! Dictionary<String, AnyObject>)["profileImage"] as? String) {
            category.profilePicture = profilePicture;
        }
        return category;
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
       

        
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
//        navigationController?.navigationBar.tintColor = UIColor.black;

        if(self.type == "project"){
            self.view.addSubview(addProjectView);
            self.addProjectView.translatesAutoresizingMaskIntoConstraints = false
            var left = NSLayoutConstraint(item: self.addProjectView, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 1, constant: 0)
            var right = NSLayoutConstraint(item: self.addProjectView, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1, constant: 0)
            var top = NSLayoutConstraint(item: self.addProjectView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
            var bottom = NSLayoutConstraint(item: self.addProjectView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
            
            NSLayoutConstraint.activate([left, right, top, bottom]);
            self.descriptionText.delegate = self;
            self.titleLabel.text = "Add Project"

        }else if(self.type == "user"){
            
            self.view.addSubview(addUserView);
            self.addUserView.translatesAutoresizingMaskIntoConstraints = false
            var left = NSLayoutConstraint(item: self.addUserView, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 1, constant: 0)
            var right = NSLayoutConstraint(item: self.addUserView, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1, constant: 0)
            var top = NSLayoutConstraint(item: self.addUserView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
            var bottom = NSLayoutConstraint(item: self.addUserView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
            NSLayoutConstraint.activate([left, right, top, bottom]);
            
            Alamofire.request("http://127.0.0.1:8080/planit/users/selectAll", method: .get, encoding: JSONEncoding.default, headers: ["Content-Type" :"application/json"]).responseJSON { response in
                
                switch response.result {
                case .success (let json):
                    let jsonResult = json as! Dictionary<String, AnyObject>
                    let json = jsonResult["users"] as! NSArray;
                    var usr = [User]();
                    
                    for userData in json {
                        let user = self.parseJsonWithData(categoryData: userData);
                        usr.append(user)
                    }
                    SharedService.shared().internetOn = true;
                    break
                case .failure(let error):
                    SharedService.shared().internetOn = false;
                    print(error)
                }
            }
            self.usersTableView.delegate = self;
            self.usersTableView.allowsSelection = true;
            self.searchBar.delegate = self;
            self.titleLabel.text = "Add User";
            

        }
        // Do any additional setup after loading the view.
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            filtering = false
            searchedUsers = [];
            view.endEditing(true);
            usersTableView.reloadData();
        }else {
            filtering = true;
            searchedUsers = users.filter({( user : User) -> Bool in
                return user.name.lowercased().contains(searchText.lowercased()) || user.email.lowercased().contains(searchText.lowercased())
            })
            usersTableView.reloadData()
        }
    }
    
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.searchedUsers.count
    }
    
    @IBAction func doSelectFinishDate(_ sender: Any) {
        
        let min = Date().addingTimeInterval(-20 * 60 * 24 * 4)
        let max = Date().addingTimeInterval(400 * 60 * 24 * 4)
        let picker = DateTimePicker.show(selected: Date(), minimumDate: min, maximumDate: max)
        picker.highlightColor = UIColor(red: 255.0/255.0, green: 165.0/255.0, blue: 116.0/255.0, alpha: 1)
        picker.includeMonth = true;
        picker.completionHandler = { date in
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy HH:mm"
            self.finishDate.setTitle(formatter.string(from: date), for: .normal);
            
        }
        
    }
    @IBAction func doSetStartDate(_ sender: Any) {
        
        let min = Date().addingTimeInterval(-20 * 60 * 24 * 4)
        let max = Date().addingTimeInterval(400 * 60 * 24 * 4)
        let picker = DateTimePicker.show(selected: Date(), minimumDate: min, maximumDate: max)
        picker.highlightColor = UIColor(red: 255.0/255.0, green: 165.0/255.0, blue: 116.0/255.0, alpha: 1)
        picker.includeMonth = true;
        picker.completionHandler = { date in
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy HH:mm"
            self.startDate.setTitle(formatter.string(from: date), for: .normal);
        }
        
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 94/255.0, green: 162/255.0, blue: 175/255.0, alpha: 1.0)
        navigationController?.navigationBar.isTranslucent = false
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchedUserCell", for: indexPath) as? UserTableViewCell
            else {
                fatalError("The dequeued cell is not an instance of ProjectTableViewCell.")
        }
        var user: User;
        user = self.searchedUsers[indexPath.row]
        cell.nameLabel.text = user.name;
        cell.emailLabel.isHidden = true;
        cell.profileImage.image = #imageLiteral(resourceName: "user-1");
        cell.profileImage.load.request(with: user.profilePicture);
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
//        print("macar aiici")
//    }
//
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected")
        tableView.cellForRow(at: self.userIndex)?.backgroundColor = UIColor.white;
        self.userIndex = indexPath;
        self.selectedUser = self.searchedUsers[indexPath.row];
        tableView.cellForRow(at: indexPath)?.backgroundColor = UIColor.gray;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @objc func endEditing() {
        view.endEditing(true)
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



extension AddViewController: UITextViewDelegate {

//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if(textField == self.searchUserField){
//            let id = userDefaults.string(forKey: "id")
//
//        }
//        endEditing()
//        return true
//    }

    

}
