//
//  User.swift
//  PlanIt
//
//  Created by Karla Pantelimon on 01/06/2018.
//  Copyright © 2018 Karla Pantelimon. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var id : Int32;
    
    var email: String;
    
    var name: String;
    
    var profilePicture: String;
    
    var phone: String;
    
    
    override init() {
        self.name = "";
        self.id = 0;
        self.email = "";
        self.profilePicture = "";
        self.phone = "";
    }
    
    
    required init?(coder aDecoder: NSCoder)
    {
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.id = Int32(aDecoder.decodeObject(forKey: "id") as! String)!
        self.email = aDecoder.decodeObject(forKey: "email") as! String;
        self.profilePicture = aDecoder.decodeObject(forKey: "profilePicture") as! String;
        self.phone = aDecoder.decodeObject(forKey: "phone") as! String
    }
    
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(String(self.id), forKey: "id")
        aCoder.encode(self.email, forKey: "email")
        aCoder.encode(self.profilePicture, forKey: "profilePicture")
        aCoder.encode(self.phone, forKey: "phone")
    }


}
