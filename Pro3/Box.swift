//
//  Box.swift
//  Pro3
//
//  Created by Admin on 5/19/17.
//  Copyright © 2017 AAkash. All rights reserved.
//

import Foundation

class BoxTimeInterval {
    
    var startHour: Int
    var startMinute: Int
    var isAvailable: Bool
    
    init(startHour: Int, startMinute: Int, isAvailable: Bool) {
        self.startHour = startHour
        self.startMinute = startMinute
        self.isAvailable = isAvailable
    }
}
