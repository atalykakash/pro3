//
//  City.swift
//  Pro3
//
//  Created by Admin on 5/3/17.
//  Copyright © 2017 AAkash. All rights reserved.
//

import Foundation
import RealmSwift

class City : Object {
    
    dynamic var id = String()
    dynamic var name = String()
 
    override var hashValue: Int {
        get {
            return name.hashValue
        }
    }
}

func ==(lhs: City, rhs: City) -> Bool {
    return lhs.name == rhs.name
}
