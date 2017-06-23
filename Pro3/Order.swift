//
//  Order.swift
//  Pro3
//
//  Created by Admin on 5/23/17.
//  Copyright © 2017 AAkash. All rights reserved.
//

import Foundation
import RealmSwift

class Order : Object {

    dynamic var id = String()
    dynamic var carwashName = String()
    dynamic var serviceName = String()
    dynamic var address = String()
    dynamic var carType = String()
    dynamic var price = String()
    dynamic var status = String()
    dynamic var startTime = String()
    dynamic var endTime = String()
}
