//
//  ApiHelper.swift
//  Pro3
//
//  Created by Admin on 5/3/17.
//  Copyright © 2017 AAkash. All rights reserved.
//

import Foundation
import RealmSwift

protocol DismissViewControllerDelegate: class {
    func dismissViewController()
}

class ApiHelper {
    
    //token = FaMn4PRqv34lu2iGYervA5YaLLbu9WFAas1felzcPLgZDGdLw9T/T4o05Er2SGAydFNrq5NHaHGSM/qadr3TMw==
    
    static weak var delegate: DismissViewControllerDelegate?
    
    static func registerUser(phoneNumber: String, name: String, password: String, confirmPassword: String, cityId: String, carId: String, completion: @escaping () -> (), dismissController: @escaping () -> ()) {
        
        let json = ["user": [
        "phone_number" : phoneNumber,
        "name" : name,
        "password" : password,
        "password_confirmation" : confirmPassword,
        "city_id" : cityId,
        "car_type_id" : carId]]
        
        guard let url = URL(string: "https://propropro.herokuapp.com/api/v1/users") else {
            print("URL not found")
            return
        }
        
        let sesssion = URLSession.shared
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = sesssion.dataTask(with: request as URLRequest) { (data, response, error) in
            
            let statusCode = (response as! HTTPURLResponse).statusCode
  
            if statusCode>=200 && statusCode<=299 {
                dismissController()
            }
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : Any] {
                    
                    print(json)
                    
                    completion()
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        task.resume()

    }
    
    static func getCities(completion: @escaping ([City]) -> ()) {
        
        guard let url = URL(string: "https://propropro.herokuapp.com/api/v1/sessions") else {
            return
        }
        
        let session = URLSession.shared
        
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : Any]
                
                guard let cities = json["cities"] as? [[String : Any]] else {
                    return
                }
                
                guard let citiesArray = cities.valuesForCities(id: "id", name: "name") else {
                    return
                }
                
                completion(citiesArray)
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    static func loginUser(phoneNumber: String, password: String, completion: @escaping () -> ()) {
        
        let json = ["user": [
            "phone_number" : phoneNumber,
            "password" : password]]
        
        guard let url = URL(string: "https://propropro.herokuapp.com/api/v1/sessions") else {
            print("URL not found")
            return
        }
        
        let sesssion = URLSession.shared
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = sesssion.dataTask(with: request as URLRequest) { (data, response, error) in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : Any] {
                    
                    UserDefaults.standard.set(phoneNumber, forKey: "phoneNumber")
                    UserDefaults.standard.set(password, forKey: "password")
                    
                    guard let user = json["user"] as? [String : Any] else {
                        return
                    }
                    
                    if let userId = user["id"] as? Int, let userName = user["name"] as? String, let userPhoneNumber = user["phone_number"] as? Int, let token = user["token"] as? String, let carTypeId = user["car_type_id"] as? Int, let carTypeName = user["car_type_name"] as? String, let cityId = user["city_id"] as? Int, let cityName = user["city_name"] as? String {
                        
                        let user = User()
                        
                        user.id = String(userId)
                        user.name = userName
                        user.phoneNumber = String(userPhoneNumber)
                        user.token = token
                        user.carTypeId = String(carTypeId)
                        user.carTypeName = carTypeName
                        user.cityId = String(cityId)
                        user.cityName = cityName
                        
                        let realm = try! Realm()
                        
                        try! realm.write {
                            realm.delete(realm.objects(User.self))
                            realm.add(user)
                        }
                    }
                    
                    self.delegate?.dismissViewController()
                }
            } catch let error {
                completion()
                print(error.localizedDescription)
            }
        }
        
        task.resume()

    }
    
    static func getCars(completion: @escaping ([Car]) -> ()) {
        
        guard let url = URL(string: "https://propropro.herokuapp.com/api/v1/sessions") else {
            return
        }
        
        let session = URLSession.shared
        
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : Any]
                
                let cars = json["car_types"] as! [[String : Any]]
                
                guard let carsArray = cars.valuesForCars(id: "id", name: "name") else {
                    return
                }
                
                completion(carsArray)
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    static func getAllCarwashs(token: String, cityId: String, completion: @escaping ([CarWash]) -> ()) {
        
        guard let url = URL(string: "https://propropro.herokuapp.com/api/v1/carwashes") else {
            return
        }
        
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.addValue("Token token=\"\(token)\"", forHTTPHeaderField: "Authorization")
        request.addValue("\(cityId)", forHTTPHeaderField: "City")
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : Any]
                
                let carwashs = json["city_carwashes"] as! [[String : Any]]
                
                guard let carwashArray = carwashs.valuesForCarwashs() else {
                    return
                }
                
                completion(carwashArray)
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    static func getIndividualCarWash(token: String, carwashId: String, cityId: String, completion: @escaping ([CarType], CarWashInfo) -> ()) {
        
        guard let url = URL(string: "https://propropro.herokuapp.com/api/v1/carwashes/\(carwashId)") else {
            return
        }
        
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.addValue("Token token=\"\(token)\"", forHTTPHeaderField: "Authorization")
        request.addValue(cityId, forHTTPHeaderField: "City")
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : Any]
                
                guard let carwash = json["carwash"] as? [String : Any] else {
                    return
                }
                
                guard let prices = json["prices"] as? [[String : Any]] else {
                    return
                }
    
                guard let carTypes = prices.valuesForCarTypes() else {
                    return
                }
                
                guard let isFavorite = json["favorite?"] as? String else {
                    return
                }
                
                guard let id = carwash["id"] as? Int else {
                    return
                }
                
                guard let name = carwash["name"] as? String else {
                    return
                }
                
                guard let phoneNumber = carwash["phone_number"] as? Int else {
                    return
                }
                
                guard let address = carwash["address"] as? String else {
                    return
                }
                
                guard let contacts = carwash["contacts"] as? String else {
                    return
                }
                
                guard let city = carwash["city"] as? [String : Any] else {
                    return
                }
                
                guard let cityId = city["id"] as? Int else {
                    return
                }
                
                guard let cityName = city["name"] as? String else {
                    return
                }
                
                let carWashInfo = CarWashInfo()
                
                carWashInfo.id = String(id)
                carWashInfo.name = name
                carWashInfo.phoneNumber = String(phoneNumber)
                carWashInfo.address = address
                carWashInfo.contacts = contacts
                carWashInfo.isFavorite = isFavorite
                carWashInfo.carWashCityId = String(cityId)
                carWashInfo.carWashCityName = cityName
                
                completion(carTypes, carWashInfo)
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
        task.resume()

    }
    
    static func getTimetableCarWash(token: String, carwashId: String, dayOfWeek: String, interval: Int, completion: @escaping (String, String) -> ()) {
        
        guard let url = URL(string: "https://propropro.herokuapp.com/api/v1/schedules/\(carwashId)") else {
            return
        }
        
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.addValue("Token token=\"\(token)\"", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : Any]
                
                guard let week = json["week"] as? [String : Any] else {
                    return
                }
                
                guard let schedules = week["schedules"] as? [[String : Any]] else {
                    return
                }
                
                if schedules.count>0 {
                    guard let day = schedules[0][dayOfWeek] as? String else {
                        return
                    }
                    
                    guard var startTime = Int(String(day[0])) else {
                        return
                    }
                    startTime = startTime*10 + (Int(String(day[1])) ?? 0)
                    let startMinute = (Int(String(day[2])) ?? 0)*10 + (Int(String(day[3])) ?? 0)
                    
                    guard var endTime = Int(String(day[5])) else {
                        return
                    }
                    
                    endTime = endTime*10 + (Int(String(day[6])) ?? 0)
                    
                    var endMinute = (Int(String(day[7])) ?? 0)*10 + (Int(String(day[8])) ?? 0)
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "HH"
                    let currentHour = dateFormatter.string(from: Date())
                    dateFormatter.dateFormat = "mm"
                    let currentMinute = dateFormatter.string(from: Date())
                    
                    guard var current = Int(currentHour), let minute = Int(currentMinute) else {
                        return
                    }
                    
                    if endTime == 0 {
                        endTime = 23
                        endMinute = 59
                    }
                    
                    if (startTime*60+startMinute) > (current*60+minute) {
                        completion("\(startTime):\(startMinute)", "\(endTime):\(endMinute)")
                    } else {
                        if dayOfWeek == Date().dayOfWeek(day: "today") {
                            if minute > interval || interval == 60 {
                                let n = round(Double(minute)/Double(interval))
                                let min = interval*Int(n)
                                current = current + Int(min/60)
                                completion("\(current):\(min%60)", "\(endTime):\(endMinute)")
                            } else {
                                let maxHour = max(startTime/60, current)
                                completion("\(maxHour):\(interval)", "\(endTime):\(endMinute)")
                            }
                        } else {
                            completion("\(startTime):\(startMinute)", "\(endTime):\(endMinute)")
                        }
                    }
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    static func getBoxesCarWash(token: String, carwashId: String, todayOrTomorrow: String, start: String, end: String, timeInterval: Int, completion: @escaping ([Box]) -> ()) {
        
        guard let url = URL(string: "https://propropro.herokuapp.com/api/v1/schedules/\(carwashId)") else {
            return
        }
        
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.addValue("Token token=\"\(token)\"", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : Any]
    
                guard let today = json[todayOrTomorrow] as? [String : Any] else {
                    return
                }
                
                guard let boxes = today["boxes"] as? [[String : Any]] else {
                    return
                }
                
                var boxArray = [Box]()
                
                for box in boxes {
                    
                    let boxIntervals = self.getIntervals(start: start, end: end, interval: timeInterval)
    
                    if let id = box["id"] as? Int  {
                        
                        if let orders = box["orders"] as? [[String : Any]]  {
                        
                            for order in orders {
                                
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                                
                                guard let startTime = order["start_time"] as? String else {
                                    return
                                }
                                guard let endTime = order["end_time"] as? String else {
                                    return
                                }
                                guard let startDate = dateFormatter.date(from: startTime) else {
                                    return
                                }
                                guard let endDate = dateFormatter.date(from: endTime) else {
                                    return
                                }
                                
                                var calendar = Calendar.current
                                calendar.timeZone = TimeZone(identifier: "GMT")!
                                var components = calendar.dateComponents([.hour, .minute], from: startDate)
                                let startHour = Int(components.hour!)
                                let startMinute = Int(components.minute!)
                                components = calendar.dateComponents([.hour, .minute], from: endDate)
                                let endHour = Int(components.hour!)
                                let endMinute = Int(components.minute!)
                                                                
                                for interval in boxIntervals {
                                    if ((interval.startHour*60+interval.startMinute+timeInterval) >  (startHour*60+startMinute)) && ((interval.startHour*60+interval.startMinute+timeInterval) <= (endHour*60+endMinute)) {
                                        interval.isAvailable = false
                                        print("\(startHour):\(startMinute) - \(endHour):\(endMinute) is changed and interval is - \(interval.startHour):\(interval.startMinute)")
                                    }
                                }
                            }
                        }
                        
                        let boxItem = Box(id: String(id), timeIntervals: boxIntervals)
                        boxArray.append(boxItem)
                    }
                }
                completion(boxArray)
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }

    
    static func bookTimeSlot(token: String, boxId: String, priceId: String, startTime: String, endTime: String, errorCompletion: @escaping () -> (), completion: @escaping () -> ()) {
        
        let json : [String : Any] = ["order": [
            "box_id" : boxId,
            "price_id" : priceId,
            "status" : "1",
            "start_time" : startTime,
            "end_time" : endTime]]
        
        guard let url = URL(string: "https://propropro.herokuapp.com/api/v1/orders") else {
            print("URL not found")
            return
        }
        
        let sesssion = URLSession.shared
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("Token token=\"\(token)\"", forHTTPHeaderField: "Authorization")
        
        let task = sesssion.dataTask(with: request as URLRequest) { (data, response, error) in
            
            if let urlResponse = response as? HTTPURLResponse {
                if urlResponse.statusCode >= 200 && urlResponse.statusCode <= 299 {
                    errorCompletion()
                }
            } else {
                errorCompletion()
            }
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) 
                
                completion()
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        task.resume()

    }
    
    static func makeCarwashFavorite(token: String, carwashId: String, completion: @escaping () -> ()) {
        
        let json : [String : Any] = ["favorite": [
            "carwash_id" : carwashId,
            "status" : "t"]]
        
        guard let url = URL(string: "https://propropro.herokuapp.com/api/v1/favorites/") else {
            print("URL not found")
            return
        }
        
        let sesssion = URLSession.shared
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("Token token=\"\(token)\"", forHTTPHeaderField: "Authorization")
        
        let task = sesssion.dataTask(with: request as URLRequest) { (data, response, error) in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                print(json)
                
                completion()
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }
    
    static func deleteCarwashFavorite(token: String, carwashId: String, completion: @escaping () -> ()) {
    
        guard let url = URL(string: "https://propropro.herokuapp.com/api/v1/favorites/\(carwashId)") else {
            print("URL not found")
            return
        }
        
        let sesssion = URLSession.shared
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "DELETE"
        
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("Token token=\"\(token)\"", forHTTPHeaderField: "Authorization")
        
        let task = sesssion.dataTask(with: request as URLRequest) { (data, response, error) in
            
            let statusCode = (response as! HTTPURLResponse).statusCode
            
            if statusCode >= 200 && statusCode <= 299 {
                completion()
            }
        }
        
        task.resume()
    }

    
    static func getIntervals(start: String, end: String, interval: Int)->[BoxTimeInterval]{
        let formatter = DateFormatter()
        print(start)
        formatter.dateFormat = "HH:mm"
        var fromDate = formatter.date(from: start)!
        let calendar = Calendar.current
        let component = calendar.dateComponents([.hour, .minute], from: fromDate)
        fromDate = calendar.date(bySettingHour: component.hour!, minute: component.minute!, second: 0, of: fromDate)!
        
        let thirtyMin: TimeInterval = TimeInterval(Int(interval*60))
        let endDate = formatter.date(from: end)!
        var intervals = Int(endDate.timeIntervalSince(fromDate)/thirtyMin)
        intervals = intervals < 0 ? 0 : intervals
        
        var dates = [BoxTimeInterval]()
        
        for x in 0...intervals{
            let date = fromDate.addingTimeInterval(TimeInterval(x)*thirtyMin)
            formatter.dateFormat = "HH"
            let hour = formatter.string(from: date)
            formatter.dateFormat = "mm"
            let minute = formatter.string(from: date)
            let boxTimeInterval = BoxTimeInterval(startHour: Int(hour)!, startMinute: Int(minute)!, isAvailable: true)
            dates.append(boxTimeInterval)
        }
        return dates
    }
    
    static func getAllOrders(token: String, completion: @escaping ([Order]) -> ()) {
        
        guard let url = URL(string: "https://propropro.herokuapp.com/api/v1/orders") else {
            return
        }
        
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.addValue("Token token=\"\(token)\"", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                
                guard let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String : Any]] else {
                    return
                }
                
                var orderArray = [Order]()
                
                for item in json {
                    
                    guard let id = item["id"] as? Int else {
                        print("Id not found")
                        return
                    }
                    
                    guard let carwashName = item["carwash_name"] as? String else {
                        print("Carwash name not found")
                        return
                    }
                    
                    guard let serviceName = item["service_name"] as? String else {
                        print("Service name not found")
                        return
                    }
                    
                    guard let carType = item["car_type"] as? String else {
                        print("Car type not found")
                        return
                    }
                    
                    guard let price = item["price"] as? Int else {
                        print("Price not found")
                        return
                    }
                    
                    guard let status = item["status"] as? Int else {
                        print("Status not found")
                        return
                    }
                    
                    guard let startTime = item["start_time"] as? String else {
                        print("Start time not found")
                        return
                    }
                    
                    guard let endTime = item["end_time"] as? String else {
                        print("Start time not found")
                        return
                    }
                    
                    let order = Order()
                    order.id = String(id)
                    order.carwashName = carwashName
                    order.serviceName = serviceName
                    order.carType = carType
                    order.price = String(price)
                    order.status = String(status)
                    order.startTime = startTime
                    order.endTime = endTime
                    orderArray.append(order)
                }
                
                completion(orderArray)
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
        task.resume()

    }
    
    static func getFavoriteCarWashes(token: String, userId: String, completion: @escaping ([CarWash]) -> ()) {
        
        guard let url = URL(string: "https://propropro.herokuapp.com/api/v1/favorites/\(userId)") else {
            return
        }
        
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.addValue("Token token=\"\(token)\"", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                
                guard let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any] else {
                    return
                }
                
                guard let favorites = json["favorite_carwashes"] as? [[String : Any]] else {
                    return
                }
                
                guard let carwashArray = favorites.valuesForCarwashs() else {
                    return
                }
                
                completion(carwashArray)
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    static func getIndividualOrder(token: String, orderId: String, completion: @escaping (_ carwash: Order) -> ()) {
        
        print("This is order id : \(orderId)")
        
        guard let url = URL(string: "https://propropro.herokuapp.com/api/v1/orders/\(orderId)") else {
            return
        }
        
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.addValue("Token token=\"\(token)\"", forHTTPHeaderField: "Authorization")
        
        print(#function)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                print("Error found")
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any] else {
                    return
                }
                
                guard let id = json["id"] as? Int else {
                    print("Id not found")
                    return
                }
                
                guard let carwashName = json["carwash_name"] as? String else {
                    print("Carwash name not found")
                    return
                }
                
                guard let serviceName = json["service_name"] as? String else {
                    print("Service name not found")
                    return
                }
                
                guard let carType = json["car_type"] as? String else {
                    print("Car type not found")
                    return
                }
                
                guard let price = json["price"] as? Int else {
                    print("Price not found")
                    return
                }
                
                guard let address = json["carwash_address"] as? String else {
                    print("Carwash address not found")
                    return
                }
                
                guard let status = json["status"] as? Int else {
                    print("Status not found")
                    return
                }
                
                guard let startTime = json["start_time"] as? String else {
                    print("Start time not found")
                    return
                }
                
                guard let endTime = json["end_time"] as? String else {
                    print("End time not found")
                    return
                }
                
                let order = Order()
                order.id = String(id)
                order.carwashName = carwashName
                order.serviceName = serviceName
                order.carType = carType
                order.price = String(price)
                order.status = String(status)
                order.startTime = startTime
                order.endTime = endTime
                order.address = address
                
                completion(order)
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    static func deleteOrder(token: String, orderId: String, completion: @escaping () -> ()) {
        
        guard let url = URL(string: "https://propropro.herokuapp.com/api/v1/orders/\(orderId)") else {
            print("URL not found")
            return
        }
        
        let sesssion = URLSession.shared
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "DELETE"
        
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("Token token=\"\(token)\"", forHTTPHeaderField: "Authorization")
        
        let task = sesssion.dataTask(with: request as URLRequest) { (data, response, error) in
            
            let statusCode = (response as! HTTPURLResponse).statusCode
            
            if statusCode >= 200 && statusCode <= 299 {
                print("cancelled")
                completion()
            }
        }
        
        task.resume()
    }
    
}
