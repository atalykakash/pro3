//
//  TimeInterval.swift
//  Pro3
//
//  Created by Admin on 5/17/17.
//  Copyright © 2017 AAkash. All rights reserved.
//

import Foundation
import RealmSwift

class Box {
    
    var id: String
    var timeIntervals: [BoxTimeInterval]

    init(id: String, timeIntervals: [BoxTimeInterval]) {
        self.id = id
        self.timeIntervals = timeIntervals
    }
}
