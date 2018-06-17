//
//  Projects.swift
//  PlanIt
//
//  Created by Karla Pantelimon on 18/05/2018.
//  Copyright © 2018 Karla Pantelimon. All rights reserved.
//

import UIKit

class Projects:NSObject,  NSCoding{
    
    var name: String;
    
    var id : Int32;
    
    var desc: String;

    var admin: Bool;
    
    var startDate: String;
    
    var finishDate: String;
    
    var address: String;
    
    override init() {
        self.name = "";
        self.id = 0;
        self.desc = "";
        self.admin = false;
        self.startDate = "";
        self.finishDate = "";
        self.address = "";
    }
    
    
    required init?(coder aDecoder: NSCoder)
    {
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.id = Int32(aDecoder.decodeObject(forKey: "id") as! String)!
        self.desc = aDecoder.decodeObject(forKey: "desc") as! String;
        self.admin = Bool(aDecoder.decodeObject(forKey: "admin") as! String)!;
        self.startDate = aDecoder.decodeObject(forKey: "startDate") as! String;
        self.finishDate = aDecoder.decodeObject(forKey: "finishDate") as! String;
        self.address = aDecoder.decodeObject(forKey: "address") as! String;
    }
    
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(String(self.id), forKey: "id")
        aCoder.encode(self.startDate, forKey: "startDate")
        aCoder.encode(self.finishDate, forKey: "finishDate")
        aCoder.encode(self.desc, forKey: "desc")
        aCoder.encode(self.admin.description, forKey: "admin")
        aCoder.encode(self.address, forKey: "address");
    }

}
