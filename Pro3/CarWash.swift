//
//  CarWash.swift
//  Pro3
//
//  Created by Admin on 5/6/17.
//  Copyright © 2017 AAkash. All rights reserved.
//

import Foundation
import RealmSwift

class CarWash : Object {
    
    var id = String()
    var name = String()
    var address = String()
    var carWashCityId = String()
    var carWashCityName = String()
    var price = "0"
    var isFavorite = String()
}
