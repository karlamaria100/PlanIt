//
//  SharedService.swift
//  PlanIt
//
//  Created by Karla Pantelimon on 14/06/2018.
//  Copyright © 2018 Karla Pantelimon. All rights reserved.
//

import Foundation


class SharedService {
    
    private static let instance: SharedService = SharedService();
    
    private init() {
        
    }
    
    class func shared() -> SharedService {
        return instance
    }
    
    let googleUser : User = User();
    var internetOn : Bool = false;
    
    
}
