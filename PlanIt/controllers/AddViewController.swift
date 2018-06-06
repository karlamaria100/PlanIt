//
//  AddViewController.swift
//  PlanIt
//
//  Created by Karla Pantelimon on 27/05/2018.
//  Copyright © 2018 Karla Pantelimon. All rights reserved.
//

import UIKit
import AFNetworking
import ImageLoader
import DateTimePicker

class AddViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
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
    
    @IBOutlet weak var searchUserField: UITextField!
    @IBOutlet weak var addProjectView: DesignableView!
    
    
    
    
    var type: String = "";
    var nameField: UITextField = UITextField();
    var descriptionField: UITextView = UITextView();
    var startDateField: UITextField = UITextField();
    var finishDateField: UITextField = UITextField();
    var searchedUsers : [User] = [];
    var selectedUser : User = User();
    var userIndex : IndexPath = IndexPath();
    let userDefaults = UserDefaults.standard;
    let manager = AFHTTPSessionManager()
    @IBAction func doAdd(_ sender: Any) {
        //if project
        //make add request
        if(self.type == "project"){
            if(nameField.text != "" && descriptionField.text != ""){
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/YYYY HH:mm"
                let start = formatter.date(from: (self.startDate.titleLabel?.text)!);
                let finish = formatter.date(from: (self.finishDate.titleLabel?.text)!);
                let param :NSDictionary = ["name": nameField.text, "description": descriptionField.text, "user":userDefaults.string(forKey: "id"), "startDate":start!.timeIntervalSince1970, "finishDay":finish!.timeIntervalSince1970];
                manager.post("http://127.0.0.1:8080/planit/projects/add", parameters: param, success: { (urlSession:URLSessionDataTask!, response:Any) in
                    let jsonResult = response as! Dictionary<String, AnyObject>
                    // tell view controller to add project to the table view
                    self.dismiss(animated: true, completion: nil);



                },failure: { (urlSession:URLSessionDataTask!, error:Error!) in
                    print("fail");
                    let error = error as NSError
                    print("Failure, error is \(error.userInfo)")
                })
            }else {
                if(nameField.text == ""){
                    nameField.layer.borderColor = UIColor.red.cgColor;
                    nameField.layer.borderWidth = 1;
                }
                else {
                    nameField.layer.borderWidth = 0;
                }
                if(descriptionField.text == ""){
                    descriptionField.layer.borderColor=UIColor.red.cgColor
                    descriptionField.layer.borderWidth = 1;
                }
                else{
                    descriptionField.layer.borderWidth = 0;
                }
                if(startDate.titleLabel?.text == "Start Date"){
                    startDate.layer.borderColor = UIColor.red.cgColor
                    startDate.layer.borderWidth = 1;
                }else{
                    startDate.layer.borderWidth = 0;
                }
                if(finishDate.titleLabel?.text == "Finish Date"){
                    finishDate.layer.borderColor = UIColor.red.cgColor
                    finishDate.layer.borderWidth = 1;
                }else{
                    finishDate.layer.borderWidth = 1;
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
//            self.startDateField.text = dateFormatter1.string(from: self.dueDatePicker.date)
            self.startDateField.resignFirstResponder()
        }else if(self.finishDateField.isFirstResponder){
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateStyle = .medium
//            self.finishDateField.text = dateFormatter1.string(from: self.dueDatePicker.date)
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
        manager.requestSerializer = AFJSONRequestSerializer();
        manager.responseSerializer = AFJSONResponseSerializer();
//        self.nameField.delegate = self;
        self.searchUserField.delegate = self;
        self.descriptionField.delegate = self;
        self.usersTableView.delegate = self;
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
        
//

        if(self.type == "project"){
            self.view.addSubview(addProjectView);
            self.addProjectView.translatesAutoresizingMaskIntoConstraints = false
            var left = NSLayoutConstraint(item: self.addProjectView, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.6, constant: 0)
            var right = NSLayoutConstraint(item: self.addProjectView, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.9, constant: 0)
            var top = NSLayoutConstraint(item: self.addProjectView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
            var bottom = NSLayoutConstraint(item: self.addProjectView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
            NSLayoutConstraint.activate([left, right, top, bottom]);
            self.titleLabel.text = "Add Project"
//
//            self.nameField.translatesAutoresizingMaskIntoConstraints = false
//            var left = NSLayoutConstraint(item: self.nameField, attribute: .leading, relatedBy: .equal, toItem: self.modalView, attribute: .leading, multiplier: 1, constant: 20)
//            var right = NSLayoutConstraint(item: self.nameField, attribute: .trailing, relatedBy: .equal, toItem: self.modalView, attribute: .trailing, multiplier: 1, constant: -20)
//            var top = NSLayoutConstraint(item: self.nameField, attribute: .top, relatedBy: .equal, toItem: self.titleLabel, attribute: .bottom, multiplier: 1, constant: 20)
//            var bottom = NSLayoutConstraint(item: self.nameField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)
//            NSLayoutConstraint.activate([left, right, top, bottom]);
//
//            self.datePickerToolbar.sizeToFit()
//            self.dueDatePicker.minimumDate = Date();
//
//            // Adding Button ToolBar
//            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doSelectDate))
//            let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//            let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
//            self.datePickerToolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
//            self.datePickerToolbar.isUserInteractionEnabled = true
//
//            self.startDateField.layer.cornerRadius = 5;
//            self.startDateField.textAlignment = .center;
//            self.startDateField.inputView = self.dueDatePicker;
//            self.startDateField.inputAccessoryView = self.datePickerToolbar;
//            self.startDateField.placeholder = "Start date"
//            self.startDateField.backgroundColor = UIColor(red:255, green:255,blue:255,alpha:0.14);
//            self.modalView.addSubview(self.startDateField);
//
//            self.startDateField.translatesAutoresizingMaskIntoConstraints = false;
//            left = NSLayoutConstraint(item: self.startDateField, attribute: .leading, relatedBy: .equal, toItem: self.modalView, attribute: .leading, multiplier: 1, constant: 20)
//            right = NSLayoutConstraint(item: self.startDateField, attribute: .trailing, relatedBy: .equal, toItem: self.modalView, attribute: .trailing, multiplier: 0.5, constant: -10)
//            top = NSLayoutConstraint(item: self.startDateField, attribute: .top, relatedBy: .equal, toItem: self.nameField, attribute: .bottom, multiplier: 1, constant: 20)
//            bottom = NSLayoutConstraint(item: self.startDateField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)
//            NSLayoutConstraint.activate([left, right, top, bottom]);
//
//            self.finishDateField.layer.cornerRadius = 5;
//            self.finishDateField.textAlignment = .center;
//            self.finishDateField.inputView = self.dueDatePicker;
//            self.finishDateField.inputAccessoryView = self.datePickerToolbar
//            self.finishDateField.placeholder = "Finish date"
//            self.finishDateField.backgroundColor = UIColor(red:255, green:255,blue:255,alpha:0.14);
//            self.modalView.addSubview(self.finishDateField);
//
//            self.finishDateField.translatesAutoresizingMaskIntoConstraints = false;
//            left = NSLayoutConstraint(item: self.finishDateField, attribute: .leading, relatedBy: .equal, toItem: self.startDateField, attribute: .trailing, multiplier: 1, constant: 20)
//            right = NSLayoutConstraint(item: self.finishDateField, attribute: .trailing, relatedBy: .equal, toItem: self.modalView, attribute: .trailing, multiplier: 1, constant: -20)
//            top = NSLayoutConstraint(item: self.finishDateField, attribute: .top, relatedBy: .equal, toItem: self.nameField, attribute: .bottom, multiplier: 1, constant: 20)
//            bottom = NSLayoutConstraint(item: self.finishDateField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)
//            NSLayoutConstraint.activate([left, right, top, bottom]);
//
//            self.descriptionField.autocapitalizationType = .sentences
//            self.descriptionField.layer.cornerRadius = 5;
//            self.descriptionField.backgroundColor = UIColor(red:255, green:255,blue:255,alpha:0.14);
//            self.modalView.addSubview(self.descriptionField);
//            self.descriptionField.translatesAutoresizingMaskIntoConstraints = false;
//            let topTable = NSLayoutConstraint(item: self.descriptionField, attribute: .top, relatedBy: .equal, toItem: self.startDateField, attribute: .bottom, multiplier: 1, constant: 20)
//            let bottomTable = NSLayoutConstraint(item: self.descriptionField, attribute: .bottom, relatedBy: .equal, toItem: self.addButton, attribute: .top, multiplier: 1, constant: -20)
//            let leftTable = NSLayoutConstraint(item: self.descriptionField, attribute: .leading, relatedBy: .equal, toItem: self.modalView, attribute: .leading, multiplier: 1, constant: 20)
//            let rightTable = NSLayoutConstraint(item: self.descriptionField, attribute: .trailing, relatedBy: .equal, toItem: self.modalView, attribute: .trailing, multiplier: 1, constant: -20)
//            NSLayoutConstraint.activate([leftTable, rightTable, bottomTable, topTable]);

        }else if(self.type == "user"){
            
            self.view.addSubview(addUserView);
            self.addUserView.translatesAutoresizingMaskIntoConstraints = false
            var left = NSLayoutConstraint(item: self.addUserView, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.6, constant: 0)
            var right = NSLayoutConstraint(item: self.addUserView, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.9, constant: 0)
            var top = NSLayoutConstraint(item: self.addUserView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
            var bottom = NSLayoutConstraint(item: self.addUserView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
            NSLayoutConstraint.activate([left, right, top, bottom]);
            self.titleLabel.text = "Add User";
            
            
//            self.nameField.autocapitalizationType = .sentences
//            self.nameField.borderStyle = UITextBorderStyle.roundedRect
//            self.nameField.placeholder = "Search user by email or name";
//            self.nameField.backgroundColor = UIColor(red:255, green:255,blue:255,alpha:0.14);
//            self.view.addSubview(self.nameField);
//
//            self.nameField.translatesAutoresizingMaskIntoConstraints = false
//            let left = NSLayoutConstraint(item: self.nameField, attribute: .leading, relatedBy: .equal, toItem: self.modalView, attribute: .leading, multiplier: 1, constant: 20)
//            let right = NSLayoutConstraint(item: self.nameField, attribute: .trailing, relatedBy: .equal, toItem: self.modalView, attribute: .trailing, multiplier: 1, constant: -20)
//            let top = NSLayoutConstraint(item: self.nameField, attribute: .top, relatedBy: .equal, toItem: self.titleLabel, attribute: .bottom, multiplier: 1, constant: 20)
//            let bottom = NSLayoutConstraint(item: self.nameField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)
//            NSLayoutConstraint.activate([left, right, top, bottom]);
//
//            self.usersTableView.layer.cornerRadius = 5;
//
//            self.usersTableView.backgroundColor = UIColor(red:255, green:255,blue:255,alpha:0.14)
//            self.modalView.addSubview(self.usersTableView);
//
//            self.usersTableView.translatesAutoresizingMaskIntoConstraints = false;
//            let topTable = NSLayoutConstraint(item: self.usersTableView, attribute: .top, relatedBy: .equal, toItem: self.nameField, attribute: .bottom, multiplier: 1, constant: 20)
//            let bottomTable = NSLayoutConstraint(item: self.usersTableView, attribute: .bottom, relatedBy: .equal, toItem: self.addButton, attribute: .top, multiplier: 1, constant: -20)
//            let leftTable = NSLayoutConstraint(item: self.usersTableView, attribute: .leading, relatedBy: .equal, toItem: self.modalView, attribute: .leading, multiplier: 1, constant: 20)
//            let rightTable = NSLayoutConstraint(item: self.usersTableView, attribute: .trailing, relatedBy: .equal, toItem: self.modalView, attribute: .trailing, multiplier: 1, constant: -20)
//            NSLayoutConstraint.activate([leftTable, rightTable, bottomTable, topTable]);
        }
        // Do any additional setup after loading the view.
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
            formatter.dateFormat = "dd/MM/YYYY HH:mm"
            self.finishDate.titleLabel?.text = formatter.string(from: date);
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
            formatter.dateFormat = "dd/MM/YYYY HH:mm"
            self.startDate.setTitle(formatter.string(from: date), for: .normal);
        }
        
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
    
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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

extension AddViewController: UITextFieldDelegate, UITextViewDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == self.searchUserField){
            let id = userDefaults.string(forKey: "id")
            manager.get("http://127.0.0.1:8080/planit/users/searchToAddToProject?string="+self.searchUserField.text!+"&id="+id!, parameters: nil, success: { (urlSession:URLSessionDataTask!, response:Any) in
                let jsonResult = response as! Dictionary<String, AnyObject>
                if(jsonResult["users"] != nil){
                    let json = jsonResult["users"] as! NSArray;
                    var usr = [User]();
                
                    for userData in json {
                        let user = self.parseJsonWithData(categoryData: userData);
                        usr.append(user)
                    }
                    self.searchedUsers = usr;
                }else{
                    self.searchedUsers = [];
                }

                self.usersTableView.reloadData();
                // tell view controller to add project to the table view
                
            },failure: { (urlSession:URLSessionDataTask!, error:Error!) in
                print("fail");
                let error = error as NSError
                print("Failure, error is \(error.userInfo)")
            })
        }
        endEditing()
        return true
    }
    
    
    
}
