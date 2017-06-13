//
//  CarWashInfo.swift
//  Pro3
//
//  Created by Admin on 6/6/17.
//  Copyright © 2017 AAkash. All rights reserved.
//

import Foundation
import RealmSwift

class CarWashInfo : Object {
    
    var id = String()
    var name = String()
    var phoneNumber = String()
    var address = String()
    var carWashCityId = String()
    var carWashCityName = String()
    var contacts = String()
    var isFavorite = String()
}

