//
//  Category.swift
//  PlanIt
//
//  Created by Karla Pantelimon on 31/05/2018.
//  Copyright © 2018 Karla Pantelimon. All rights reserved.
//

import UIKit

class Category: NSObject, NSCoding {
    
    
    var name: String;
    
    var total: Int;
    
    override init() {
        self.name = "";
        self.total = 0;
    }
    
    
    required init?(coder aDecoder: NSCoder)
    {
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.total = Int(aDecoder.decodeObject(forKey: "total") as! String)!
    }
    
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(String(self.total), forKey: "total")
    }


}
