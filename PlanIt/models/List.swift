//
//  List.swift
//  PlanIt
//
//  Created by Karla Pantelimon on 01/06/2018.
//  Copyright © 2018 Karla Pantelimon. All rights reserved.
//

import UIKit

class List: NSObject, NSCoding {
    
    var id: Int32;
    
    var desc: String;
    
    var name: String;
    
    var project: Int32;
    
    override init() {
        self.name = "";
        self.id = 0;
        self.desc = "";
        self.project = 0;
    }
    
    
    required init?(coder aDecoder: NSCoder)
    {
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.id = Int32(aDecoder.decodeObject(forKey: "id") as! String)!
        self.desc = aDecoder.decodeObject(forKey: "desc") as! String;
        self.project = Int32(aDecoder.decodeObject(forKey: "project") as! String)!;
    }
    
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(String(self.id), forKey: "id")
        aCoder.encode(String(self.project), forKey: "project")
        aCoder.encode(self.desc, forKey: "desc")
    }


}
