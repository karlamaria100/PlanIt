//
//  Folder.swift
//  PlanIt
//
//  Created by Karla Pantelimon on 01/06/2018.
//  Copyright © 2018 Karla Pantelimon. All rights reserved.
//

import UIKit

class Folder: NSObject {
    

    var id: Int32;
    
    var name: String;
    
    var project: Int32;
    
    override init() {
        self.name = "";
        self.id = 0;
        self.project = 0;
    }
    
    
    required init?(coder aDecoder: NSCoder)
    {
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.id = Int32(aDecoder.decodeObject(forKey: "id") as! String)!
        self.project = Int32(aDecoder.decodeObject(forKey: "project") as! String)!;
    }
    
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(String(self.id), forKey: "id")
        aCoder.encode(String(self.project), forKey: "project")
    }


}
