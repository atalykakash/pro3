//
//  RealmUser.swift
//  Pro3
//
//  Created by Admin on 5/6/17.
//  Copyright © 2017 AAkash. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    
    dynamic var id = String()
    dynamic var name = String()
    dynamic var phoneNumber = String()
    dynamic var token = String()
    dynamic var carTypeId = String()
    dynamic var carTypeName = String()
    dynamic var cityId = String()
    dynamic var cityName = String()
}
