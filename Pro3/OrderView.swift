//
//  OrderView.swift
//  Pro3
//
//  Created by Admin on 5/23/17.
//  Copyright © 2017 AAkash. All rights reserved.
//

import UIKit
import RealmSwift

protocol SelectOrderDelegate : class {
    func selectOrder(order: Order)
}

class OrderView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    lazy var collectionView = UICollectionView()
    var progressView = ProgressIndicatorView()
    var refreshControl = UIRefreshControl()
    
    let screenBounds = UIScreen.main.bounds
    
    var orders = [Order]()
    
    weak var delegate : SelectOrderDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        
        loadAllOrders()
    }
    
    func loadAllOrders() {
        
        let realm = try! Realm()
        let user = realm.objects(User.self)
        
        if user.count > 0 {
        
            ApiHelper.getAllOrders(token: user[0].token) { (orders) in
                
                DispatchQueue.main.async {
                    self.orders = orders
                    self.collectionView.reloadData()
                    self.progressView.isHidden = true
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    func refreshData() {
        
        self.refreshControl.beginRefreshing()
        
        self.loadAllOrders()
    }
    
    func setup() {
        
        self.backgroundColor = UIColor.white
        
        self.refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        self.refreshControl.tintColor = UIColor().mainColor()
        
        let layout = UICollectionViewFlowLayout()
        
        self.collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height), collectionViewLayout: layout)
        self.collectionView.register(OrderCollectionViewCell.self, forCellWithReuseIdentifier: "OrderCell")
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.addSubview(self.refreshControl)
        self.collectionView.alwaysBounceVertical = true
        self.addSubview(self.collectionView)
        
        self.progressView = ProgressIndicatorView(frame: CGRect(x: frame.width*0.35, y: frame.height*0.3, width: frame.width*0.3, height: frame.width*0.32))
        self.progressView.layer.cornerRadius = 5
        self.progressView.messageLabel.text = "Загружаю заказы"
        self.progressView.messageLabel.font = UIFont().risingSunSmall()
        self.addSubview(self.progressView)
    }
    
    func compareDate(dateInitial:Date, dateFinal:Date) -> Bool {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "GMT")!
        let order = calendar.compare(dateInitial, to: dateFinal, toGranularity: .minute)
        switch order {
        case .orderedAscending:
            print("\(dateFinal) is after \(dateInitial)")
            return true
        case .orderedDescending:
            return false
        case .orderedSame:
            return false
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.orders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderCell", for: indexPath) as! OrderCollectionViewCell
        
        cell.titleLabel.text = self.orders[indexPath.row].carwashName
        cell.serviceLabel.text = self.orders[indexPath.row].serviceName
        cell.priceLabel.text = self.orders[indexPath.row].price
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let endDate = dateFormatter.date(from: self.orders[indexPath.row].endTime)
        let startDate = dateFormatter.date(from: self.orders[indexPath.row].startTime)
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "GMT")!
        
        let components = calendar.dateComponents([.month, .day, .hour, .minute], from: startDate!)
        let month = components.month!
        let day = components.day!
        
        let endComponents = calendar.dateComponents([.month, .day, .hour, .minute], from: endDate!)
        let endHour = String(format: "%02d", Int(endComponents.hour!))
        let endMinute = String(format: "%02d", Int(endComponents.minute!))
    
        let hour = String(format: "%02d", Int(components.hour!))
        let minute = String(format: "%02d", Int(components.minute!))
        
        cell.dateLabel.text = "\(day)/\(month) в \(hour):\(minute) ~ \(endHour):\(endMinute)"
        
        let minutes = Date().getCurrentLocalDate().minutes(from: endDate!)
    
        if self.orders[indexPath.row].status == "1" {
            if minutes>0 {
                cell.activityLabel.text = "Завершен"
                cell.activityLabel.textColor = UIColor.black
            } else {
                cell.activityLabel.text = "Активный"
                cell.activityLabel.textColor = UIColor().mainColor()
            }
        } else if self.orders[indexPath.row].status == "2" {
            cell.activityLabel.text = "Отменен"
        } else {
            cell.activityLabel.text = "Отказано"
        }
        
        cell.backgroundColor = (indexPath.row%2 != 0) ? UIColor.white : UIColor().lightGrayBackgroundColor()
        
        cell.layer.cornerRadius = 5
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.screenBounds.width*0.95, height: self.screenBounds.height/5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.screenBounds.width*0.025
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.selectOrder(order: orders[indexPath.row])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
