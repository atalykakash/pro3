//
//  Extensions.swift
//  Pro3
//
//  Created by Admin on 5/1/17.
//  Copyright © 2017 AAkash. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

extension UIColor {
    
    func mainColor() -> UIColor {
        return UIColor(red: 251/255, green: 164/255, blue: 136/255, alpha: 1.0)
    }
    
    func lightGrayBackgroundColor() -> UIColor {
        return UIColor(red: 243/255, green: 243/255, blue: 243/255, alpha: 1.0)
    }
}

extension UIFont {
    
    func risingSun() -> UIFont {
        return UIFont(name: "RisingSun-Light", size: UIScreen.main.bounds.width*0.05)!
    }
    
    func risingSunSmall() -> UIFont {
        return UIFont(name: "RisingSun-Light", size: UIScreen.main.bounds.width*0.04)!
    }
    
    func risingSunRegular() -> UIFont {
        return UIFont(name: "RisingSun-Regular", size: UIScreen.main.bounds.width*0.05)!
    }
    
    func risingSunRegularBig() -> UIFont {
        return UIFont(name: "RisingSun-Regular", size: UIScreen.main.bounds.width*0.06)!
    }
    
    func risingSunBig() -> UIFont {
        return UIFont(name: "RisingSun-Light", size: UIScreen.main.bounds.width*0.06)!
    }
    
    func risingSunBlack() -> UIFont {
        return UIFont(name: "RisingSun-Black", size: UIScreen.main.bounds.width*0.05)!
    }
    
    func risingSunBold() -> UIFont {
        return UIFont(name: "RisingSun-DemiBold", size: UIScreen.main.bounds.width*0.05)!
    }
}

extension Date {
    
    func dayOfWeek(day: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        if day == "today" {
            return dateFormatter.string(from: self).lowercased()
        } else {
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())
            return dateFormatter.string(from: tomorrow!).lowercased()
        }
    }
    
    func dateOfDay(day: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if day == "today" {
            return dateFormatter.string(from: self)
        } else {
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())
            return dateFormatter.string(from: tomorrow!)
        }
    }
    
    func minutes(from date: Date) -> Int {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "GMT")!
        return calendar.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    
    func getCurrentLocalDate()-> Date {
        var now = Date()
        var nowComponents = DateComponents()
        let calendar = Calendar.current
        nowComponents.year = Calendar.current.component(.year, from: now)
        nowComponents.month = Calendar.current.component(.month, from: now)
        nowComponents.day = Calendar.current.component(.day, from: now)
        nowComponents.hour = Calendar.current.component(.hour, from: now)
        nowComponents.minute = Calendar.current.component(.minute, from: now)
        nowComponents.second = Calendar.current.component(.second, from: now)
        nowComponents.timeZone = TimeZone(abbreviation: "GMT")!
        now = calendar.date(from: nowComponents)!
        return now as Date
    }

}

extension String {
    
    subscript(i: Int) ->Character {
        return self[index(startIndex, offsetBy: i)]
    }
}

extension UINavigationBar {
    
    func setBottomBorderColor(color: UIColor, height: CGFloat) -> UIView {
        let bottomBorderView = UIView(frame: CGRect.zero)
        bottomBorderView.translatesAutoresizingMaskIntoConstraints = false
        bottomBorderView.backgroundColor = color
        
        self.addSubview(bottomBorderView)
        
        let views = ["border": bottomBorderView]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[border]|", options: [], metrics: nil, views: views))
        self.addConstraint(NSLayoutConstraint(item: bottomBorderView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: height))
        self.addConstraint(NSLayoutConstraint(item: bottomBorderView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: height))
        
        return bottomBorderView
    }
}

extension UITabBar {
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 40
        return sizeThatFits
    }
}

extension Sequence where Iterator.Element == [String : Any] {
    
    func valuesForCities(id: String, name: String) -> [City]? {
        var result : [City] = []
        
        for value in self {
            if let cityId = value[id] as? Int, let cityName = value[name] as? String {
                let city = City()
                city.id = String(cityId)
                city.name = cityName
                result.append(city)
            }
        }
        return result.isEmpty ? nil : result
    }
    
    func valuesForCars(id: String, name: String) -> [Car]? {
        var result : [Car] = []
        
        for value in self {
            if let carId = value[id] as? Int, let carName = value[name] as? String {
                let car = Car()
                car.id = String(carId)
                car.name = carName
                result.append(car)
            }
        }
        return result.isEmpty ? nil : result
    }
    
    func valuesForCarwashs() -> [CarWash]? {
        var result : [CarWash] = []
        for value in self {
            if let id = value["id"] as? Int, let name = value["name"] as? String, let address = value["address"] as? String, let carwashCityId = value["carwash_city_id"] as? Int, let carWashCityName = value["carwash_city_name"] as? String, let example = value["example"] as? [[String : Any]] {
                
                let carwash = CarWash()
                
                carwash.id = String(id)
                carwash.name = name
                carwash.address = address
                carwash.carWashCityId = String(carwashCityId)
                carwash.carWashCityName = carWashCityName
                
                if example.count>0 {
                    if let price = example[0]["price"] as? Int {
                        carwash.price = String(price)
                    }
                }
                
                result.append(carwash)
            }
        }
        return result.isEmpty ? nil : result
    }
    
    func valuesForCarTypes() -> [CarType]? {
        var result: [CarType] = []
        for value in self {
            
            let carType = CarType()
            
            if let id = value["id"] as? Int {
                carType.priceId = String(id)
            }
            if let priceString = value["price"] as? Int {
                carType.priceString = String(priceString)
            }
            if let car = value["car_type"] as? [String : Any] {
                if let id = car["id"] as? Int, let name = car["name"] as? String {
                    carType.id = String(id)
                    carType.name = name
                }
            }
            if let service = value["service"] as? [String : Any] {
                if let id = service["id"] as? Int, let name = service["name"] as? String {
                    carType.serviceId = String(id)
                    carType.serviceName = name
                }
            }
            result.append(carType)
        }
        return result.isEmpty ? nil : result
    }
}

class ProTextField: UITextField {
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x+10, y: bounds.origin.y, width: bounds.width-20, height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x+10, y: bounds.origin.y, width: bounds.width-20, height: bounds.height)
    }
}
