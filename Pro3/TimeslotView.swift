//
//  TimeslotView.swift
//  Pro3
//
//  Created by Admin on 5/11/17.
//  Copyright © 2017 AAkash. All rights reserved.
//

import UIKit
import RealmSwift

protocol HideTimeslotDelegate: class {
    
    func hideTimeslotView()
}

class TimeslotView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    weak var hideTimeslotDelegate: HideTimeslotDelegate?

    lazy var collectionView = UICollectionView()
    lazy var todayButton = UIButton()
    lazy var tomorrowButton = UIButton()
    lazy var cancelButton = UIButton()
    lazy var submitButton = UIButton()
    
    let screenBounds = UIScreen.main.bounds
    
    let weekDayArray = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]
    
    var interval = 30
    var slots = Int()
    var startTime = Int()
    var selectedTimeCell = -1
    
    var midnight = 1
    var boxArray = [Box]()
    var timeIntervals = [BoxTimeInterval]()
    var todayOrTomorrow = "today"
    var dayOfWeek = Date().dayOfWeek(day: "today")
    var priceId = String()
    var index: Int?
    
    var carwashValue : CarWash? {
        didSet {
            if let carwash = carwashValue {
                getTimetableCarwash(carwash: carwash)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
    }
    
    func getTimetableCarwash(carwash: CarWash) {
        
        let realm = try! Realm()
        let user = realm.objects(User.self)
        
        ApiHelper.getTimetableCarWash(token: user[0].token, carwashId: carwash.id, dayOfWeek: self.dayOfWeek, interval: self.interval, completion: { (startTime, endTime) in
            
            self.timeIntervals = self.getIntervals(start: startTime, end: endTime)
            
            self.getBoxesCarwash(carwash: carwash, start: startTime, end: endTime)
        })
    }
    
    func getBoxesCarwash(carwash: CarWash, start: String, end: String) {
        
        let realm = try! Realm()
        let user = realm.objects(User.self)
        
        ApiHelper.getBoxesCarWash(token: user[0].token, carwashId: carwash.id, todayOrTomorrow: self.todayOrTomorrow, start: start, end: end, timeInterval: self.interval) { (boxArray) in

            DispatchQueue.main.async {
                self.boxArray = boxArray
                self.collectionView.reloadData()
            }
        }
    }
    
    func getIntervals(start: String, end: String)->[BoxTimeInterval]{
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        guard var fromDate = formatter.date(from: start) else {
            return []
        }
        let calendar = Calendar.current
        let component = calendar.dateComponents([.hour, .minute], from: fromDate)
        fromDate = calendar.date(bySettingHour: component.hour!, minute: component.minute!, second: 0, of: fromDate)!
        
        if end == "23:59" {
            midnight = 0
        }
        
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
    
    func dayOfWeekPressed(sender: UIButton) {
    
        
        guard let buttonTitle = sender.currentTitle else {
            return
        }
        
        if buttonTitle == "Сегодня" {
            self.todayOrTomorrow = "today"
            self.dayOfWeek = Date().dayOfWeek(day: "today")
        } else {
            self.todayOrTomorrow = "tomorrow"
            self.dayOfWeek = Date().dayOfWeek(day: "tomorrow")
        }
        
        guard let carwash = carwashValue else {
            return
        }
        
        let realm = try! Realm()
        let user = realm.objects(User.self)
        
        ApiHelper.getTimetableCarWash(token: user[0].token, carwashId: carwash.id, dayOfWeek: self.dayOfWeek, interval: self.interval, completion: { (startTime, endTime) in
            
            DispatchQueue.main.async {
                
                self.timeIntervals = self.getIntervals(start: startTime, end: endTime)
                self.getBoxesCarwash(carwash: carwash, start: startTime, end: endTime)
            }
        })
    }
    
    func hideTimeslot() {
        
        self.selectedTimeCell = -1
        
        self.collectionView.reloadData()
        
        self.index = nil
        
        self.hideTimeslotDelegate?.hideTimeslotView()
    }
    
    func submitButtonPressed() {
        
        guard let indexRow = index else {
            return
        }
        
        let day = Date().dateOfDay(day: self.todayOrTomorrow)
        
        let startTime = "\(day) \(String(format: "%02d", self.timeIntervals[indexRow].startHour)):\(String(format: "%02d", self.timeIntervals[indexRow].startMinute))"
        
        let minute = self.timeIntervals[indexRow].startMinute + self.interval
        let endTime = "\(day) \(String(format: "%02d", self.timeIntervals[indexRow].startHour + minute/60)):\(String(format: "%02d", minute%60))"
        
        let realm = try! Realm()
        let user = realm.objects(User.self)
        
        for box in self.boxArray {
            if box.timeIntervals[indexRow].isAvailable {
                ApiHelper.bookTimeSlot(token: user[0].token, boxId: box.id, priceId: priceId, startTime: startTime, endTime: endTime)
                print("ordered")
                break
            }
        }
        
        guard let carwash = carwashValue else {
            return
        }
        
        self.getTimetableCarwash(carwash: carwash)
        
        self.selectedTimeCell = -1
        
        self.collectionView.reloadData()
        
        hideTimeslot()
    }
    
    func setup() {
        
        self.backgroundColor = UIColor().lightGrayBackgroundColor()
        
        let layout = UICollectionViewFlowLayout()
        
        self.collectionView = UICollectionView(frame: CGRect(x: 0, y: frame.height*0.13, width: frame.width, height: frame.height*0.74), collectionViewLayout: layout)
        self.collectionView.register(SlotCollectionViewCell.self, forCellWithReuseIdentifier: "SlotCell")
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.allowsMultipleSelection = false
        self.addSubview(self.collectionView)
        
        self.todayButton = UIButton(frame: CGRect(x: 0, y: 0, width: frame.width*0.5, height: frame.height*0.13))
        self.todayButton.setTitle("Сегодня", for: .normal)
        self.todayButton.setTitleColor(UIColor.black, for: .normal)
        self.todayButton.addTarget(self, action: #selector(dayOfWeekPressed(sender:)), for: .touchUpInside)
        self.todayButton.titleLabel?.font = UIFont().risingSun()
        self.addSubview(self.todayButton)
        
        self.tomorrowButton = UIButton(frame: CGRect(x: frame.width*0.5, y: 0, width: frame.width*0.5, height: frame.height*0.13))
        self.tomorrowButton.setTitle("Завтра", for: .normal)
        self.tomorrowButton.setTitleColor(UIColor.black, for: .normal)
        self.tomorrowButton.addTarget(self, action: #selector(dayOfWeekPressed(sender:)), for: .touchUpInside)
        self.tomorrowButton.titleLabel?.font = UIFont().risingSun()
        self.addSubview(self.tomorrowButton)
        
        self.cancelButton = UIButton(frame: CGRect(x: frame.width*0.05, y: frame.height*0.87, width: frame.width*0.4, height: frame.height*0.12))
        self.cancelButton.setTitle("Отмена", for: .normal)
        self.cancelButton.setTitleColor(UIColor.black, for: .normal)
        self.cancelButton.addTarget(self, action: #selector(hideTimeslot), for: .touchUpInside)
        self.cancelButton.titleLabel?.font = UIFont().risingSun()
        self.addSubview(self.cancelButton)
        
        self.submitButton = UIButton(frame: CGRect(x: frame.width*0.5, y: frame.height*0.87, width: frame.width*0.45, height: frame.height*0.12))
        self.submitButton.setTitle("Потвердить", for: .normal)
        self.submitButton.setTitleColor(UIColor.black, for: .normal)
        self.submitButton.addTarget(self, action: #selector(submitButtonPressed), for: .touchUpInside)
        self.submitButton.titleLabel?.font = UIFont().risingSun()
        self.addSubview(self.submitButton)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.timeIntervals.count - self.midnight
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SlotCell", for: indexPath) as! SlotCollectionViewCell
        cell.isUserInteractionEnabled = false
        cell.crossLineView.isHidden = false
        cell.timeLabel.textColor = UIColor.black
        cell.backgroundColor = UIColor.white
        
        let minute = self.timeIntervals[indexPath.row].startMinute + self.interval
        let endTime = "\(String(format: "%02d", (self.timeIntervals[indexPath.row].startHour + minute/60)%24)):\(String(format: "%02d", minute%60))"
        
        cell.timeLabel.text = "\(String(format: "%02d", self.timeIntervals[indexPath.row].startHour)):\(String(format: "%02d", self.timeIntervals[indexPath.row].startMinute)) - \(endTime)"
        
        self.timeIntervals[indexPath.row].isAvailable = false
        
        for box in self.boxArray {
            if box.timeIntervals[indexPath.row].isAvailable {
                self.timeIntervals[indexPath.row].isAvailable = true
            }
        }
       
        if self.timeIntervals[indexPath.row].isAvailable {
            cell.isUserInteractionEnabled = true
            cell.crossLineView.isHidden = true
        }
        
        if selectedTimeCell == indexPath.row {
            if self.timeIntervals[selectedTimeCell].isAvailable {
                cell.backgroundColor = UIColor().mainColor()
                cell.timeLabel.textColor = UIColor.white
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: frame.height*0.74/5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.selectedTimeCell = indexPath.row
        
        self.index = indexPath.row
        
        self.collectionView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
