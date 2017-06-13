//
//  Car.swift
//  Pro3
//
//  Created by Admin on 5/5/17.
//  Copyright © 2017 AAkash. All rights reserved.
//

import Foundation
import RealmSwift

class Car : Object {
    
    dynamic var id = String()
    dynamic var name = String()
    
    override var hashValue: Int {
        get {
            return name.hashValue
        }
    }
}

func ==(lhs: Car, rhs: Car) -> Bool {
    return lhs.name == rhs.name
}
