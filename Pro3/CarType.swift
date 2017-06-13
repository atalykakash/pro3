//
//  CarType.swift
//  Pro3
//
//  Created by Admin on 5/9/17.
//  Copyright © 2017 AAkash. All rights reserved.
//

import Foundation
import RealmSwift

class CarType : Object {
    
    var id = String()
    var name = String()
    var priceId = String()
    var priceString = String()
    var priceDescription = String()
    var serviceId = String()
    var serviceName = String()
}

