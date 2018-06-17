//
//  NetworkService.swift
//  PlanIt
//
//  Created by Karla Pantelimon on 08/06/2018.
//  Copyright © 2018 Karla Pantelimon. All rights reserved.
//

import Foundation
import Alamofire


class ProjectsNetworkManager{
    
    let userDefaults = UserDefaults.standard;
    private static let instance: ProjectsNetworkManager = ProjectsNetworkManager();
    private let url = "http://127.0.0.1:8080/planit/projects";
    var internetOn: Bool = true;
    
    private init() {
   
    }
    
    class func shared() -> ProjectsNetworkManager {
        return instance
    }
    

    
    public func getUserProjects(id: String) -> [Projects]{
        var projects : [Projects] = [];
        
        
        
//        manager.get(self.url+"/selectProjects?id=" + id, parameters: nil, success: { (urlSession:URLSessionDataTask!, response:Any) in
//            let jsonResult = response as! Dictionary<String, AnyObject>;
//
//            let json = jsonResult["projects"] as! NSArray;
//
//            var proj = [Projects]();
//
//            for projectData in json {
//                let project = self.parseJsonToProject(projectData: projectData);
//                proj.append(project)
//            }
//            projects = proj;
//
//            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: projects)
//            self.userDefaults.set(encodedData, forKey: "projects")
//            self.internetOn = true;
//            
//        },failure: { (urlSession:URLSessionDataTask!, error:Error!) in
//            print("fail");
//            let error = error as NSError
//            self.internetOn = false;
//            print("Failure, error is \(error.userInfo)")
//        })
        return projects;
    }
    
    
    
   
    func getCategories(id: String) -> Void {
        
       
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
}
