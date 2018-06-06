//
//  Task.swift
//  PlanIt
//
//  Created by Karla Pantelimon on 01/06/2018.
//  Copyright © 2018 Karla Pantelimon. All rights reserved.
//

import UIKit

class Task: NSObject {
    
    var id: Int32;
    
    var desc: String;
    
    var done: Bool;
    
    var project: Int32;
    
    var date: String;
    
    override init() {
        self.project = 0;
        self.id = 0;
        self.desc = "";
        self.done = false;
        self.date = "";
    }
    
    
    required init?(coder aDecoder: NSCoder)
    {
        self.project = Int32(aDecoder.decodeObject(forKey: "project") as! String)!;
        self.id = Int32(aDecoder.decodeObject(forKey: "id") as! String)!
        self.desc = aDecoder.decodeObject(forKey: "desc") as! String;
        self.done = Bool(aDecoder.decodeObject(forKey: "done") as! String)!;
        self.date = aDecoder.decodeObject(forKey: "date") as! String;
    }
    
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(String(self.project), forKey: "project")
        aCoder.encode(String(self.id), forKey: "id")
        aCoder.encode(self.date, forKey: "date")
        aCoder.encode(self.desc, forKey: "desc")
        aCoder.encode(self.done.description, forKey: "done")
    }


}
