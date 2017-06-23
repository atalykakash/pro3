//
//  IndividualOrderView.swift
//  Pro3
//
//  Created by Admin on 6/13/17.
//  Copyright © 2017 AAkash. All rights reserved.
//

import UIKit
import RealmSwift

class IndividualOrderView: UIView {

    let screenBounds = UIScreen.main.bounds
    
    lazy var proNameLabel = UILabel()
    lazy var nameLabel = UILabel()
    lazy var proAddressLabel = UILabel()
    lazy var addressLabel = UILabel()
    lazy var proTimeLabel = UILabel()
    lazy var timeLabel = UILabel()
    lazy var proServiceLabel = UILabel()
    lazy var serviceLabel = UILabel()
    lazy var proCarLabel = UILabel()
    lazy var carLabel = UILabel()
    lazy var proPriceLabel = UILabel()
    lazy var priceLabel = UILabel()
    lazy var proStatusLabel = UILabel()
    lazy var statusLabel = UILabel()
    lazy var cancelButton = UIButton()
    var progressView = ProgressIndicatorView()
    
    var order: Order? {
        didSet {
            if let order = order {
                updateData(order: order)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    func updateData(order: Order) {
        
        let realm = try! Realm()
        let user = realm.objects(User.self)
        
        if(user.count>0) {
            ApiHelper.getIndividualOrder(token: user[0].token, orderId: order.id, completion: { (order) in
                
                DispatchQueue.main.async { [weak self] in
                    
                    guard let strongSelf = self else {
                        return
                    }
                    
                    strongSelf.progressView.isHidden = true
                    
                    strongSelf.nameLabel.text = order.carwashName
                    strongSelf.addressLabel.text = order.address
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    let endDate = dateFormatter.date(from: order.endTime)
                    let startDate = dateFormatter.date(from: order.startTime)
                    
                    var calendar = Calendar.current
                    calendar.timeZone = TimeZone(identifier: "GMT")!
                    
                    let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: startDate!)
                    let month = components.month!
                    let day = components.day!
                    let year = components.year!
                    
                    let endComponents = calendar.dateComponents([.month, .day, .hour, .minute], from: endDate!)
                    let endHour = String(format: "%02d", Int(endComponents.hour!))
                    let endMinute = String(format: "%02d", Int(endComponents.minute!))
                    
                    let hour = String(format: "%02d", Int(components.hour!))
                    let minute = String(format: "%02d", Int(components.minute!))
                    
                    strongSelf.timeLabel.text = "\(day)/\(month)/\(year) в \(hour):\(minute) ~ \(endHour):\(endMinute)"
                    
                    strongSelf.carLabel.text = order.carType
                    strongSelf.serviceLabel.text = order.serviceName
                    strongSelf.priceLabel.text = order.price
                    
                    let minutes = Date().getCurrentLocalDate().minutes(from: endDate!)
                    
                    if order.status == "1" {
                        if minutes>0 {
                            strongSelf.statusLabel.text = "Завершен"
                            strongSelf.cancelButton.isHidden = true
                        } else {
                            strongSelf.statusLabel.text = "Активный"
                            strongSelf.cancelButton.isHidden = false
                        }
                    } else if order.status == "2" {
                        strongSelf.statusLabel.text = "Отменен"
                        strongSelf.cancelButton.isHidden = true
                    } else {
                        strongSelf.statusLabel.text = "Отказано"
                        strongSelf.cancelButton.isHidden = true
                    }
                }
            })
        }
    }
    
    @objc private func deleteOrder() {
        
        let realm = try! Realm()
        let user = realm.objects(User.self)
        
        progressView.messageLabel.text = "Отменяю заказ"
        progressView.isHidden = false
        
        if(user.count>0) {
            
            guard let orderItem = order else {
                return
            }
            
            ApiHelper.deleteOrder(token: user[0].token, orderId: orderItem.id, completion: {
                
                [weak self] in
                
                guard let strongSelf = self else {
                    return
                }
                
                guard let orderItem = strongSelf.order else {
                    return
                }
                
                strongSelf.updateData(order: orderItem)
            })
        }
    }
    
    func setup() {
        
        self.backgroundColor = UIColor.white
        
        proNameLabel = UILabel(frame: CGRect(x: 20, y: 0, width: self.screenBounds.width-40, height: self.screenBounds.height*0.07))
        proNameLabel.text = "Имя"
        proNameLabel.font = UIFont().risingSunSmall()
        proNameLabel.textColor = UIColor().mainColor()
        self.addSubview(proNameLabel)
        
        nameLabel = UILabel(frame: CGRect(x: 20, y: self.screenBounds.height*0.06, width: self.screenBounds.width-40, height: self.screenBounds.height*0.07))
        nameLabel.text = "Music video by Manga performing Cevapsiz Sorular"
        nameLabel.numberOfLines = 0
        nameLabel.font = UIFont().risingSunRegular()
        nameLabel.textColor = UIColor.black
        self.addSubview(nameLabel)
        
        proAddressLabel = UILabel(frame: CGRect(x: 20, y: self.screenBounds.height*0.11, width: self.screenBounds.width-40, height: self.screenBounds.height*0.07))
        proAddressLabel.text = "Адрес"
        proAddressLabel.font = UIFont().risingSunSmall()
        proAddressLabel.textColor = UIColor().mainColor()
        self.addSubview(proAddressLabel)
        
        addressLabel = UILabel(frame: CGRect(x: 20, y: self.screenBounds.height*0.17, width: self.screenBounds.width-40, height: self.screenBounds.height*0.07))
        addressLabel.text = "Music video by Manga performing Cevapsiz Sorular"
        addressLabel.font = UIFont().risingSunRegular()
        addressLabel.textColor = UIColor.black
        addressLabel.numberOfLines = 0
        self.addSubview(addressLabel)
        
        proTimeLabel = UILabel(frame: CGRect(x: 20, y: self.screenBounds.height*0.23, width: self.screenBounds.width-40, height: self.screenBounds.height*0.07))
        proTimeLabel.text = "На время"
        proTimeLabel.font = UIFont().risingSunSmall()
        proTimeLabel.textColor = UIColor().mainColor()
        self.addSubview(proTimeLabel)
        
        timeLabel = UILabel(frame: CGRect(x: 20, y: self.screenBounds.height*0.27, width: self.screenBounds.width-40, height: self.screenBounds.height*0.07))
        timeLabel.text = "16.06.2017 10:30-11:00"
        timeLabel.font = UIFont().risingSunRegular()
        timeLabel.textColor = UIColor.black
        self.addSubview(timeLabel)
        
        proServiceLabel = UILabel(frame: CGRect(x: 20, y: self.screenBounds.height*0.31, width: self.screenBounds.width-40, height: self.screenBounds.height*0.07))
        proServiceLabel.text = "Услуги"
        proServiceLabel.font = UIFont().risingSunSmall()
        proServiceLabel.textColor = UIColor().mainColor()
        self.addSubview(proServiceLabel)
        
        serviceLabel = UILabel(frame: CGRect(x: 20, y: self.screenBounds.height*0.35, width: self.screenBounds.width-40, height: self.screenBounds.height*0.07))
        serviceLabel.text = "Кузов+Салон"
        serviceLabel.font = UIFont().risingSunRegular()
        serviceLabel.textColor = UIColor.black
        self.addSubview(serviceLabel)
        
        proCarLabel = UILabel(frame: CGRect(x: 20, y: self.screenBounds.height*0.39, width: self.screenBounds.width-40, height: self.screenBounds.height*0.07))
        proCarLabel.text = "Автомобиль"
        proCarLabel.font = UIFont().risingSunSmall()
        proCarLabel.textColor = UIColor().mainColor()
        self.addSubview(proCarLabel)
        
        carLabel = UILabel(frame: CGRect(x: 20, y: self.screenBounds.height*0.43, width: self.screenBounds.width-40, height: self.screenBounds.height*0.07))
        carLabel.text = "Седан"
        carLabel.font = UIFont().risingSunRegular()
        carLabel.textColor = UIColor.black
        self.addSubview(carLabel)
        
        proPriceLabel = UILabel(frame: CGRect(x: 20, y: self.screenBounds.height*0.47, width: self.screenBounds.width-40, height: self.screenBounds.height*0.07))
        proPriceLabel.text = "Цена"
        proPriceLabel.font = UIFont().risingSunSmall()
        proPriceLabel.textColor = UIColor().mainColor()
        self.addSubview(proPriceLabel)
        
        priceLabel = UILabel(frame: CGRect(x: 20, y: self.screenBounds.height*0.51, width: self.screenBounds.width-40, height: self.screenBounds.height*0.07))
        priceLabel.text = "2500"
        priceLabel.font = UIFont().risingSunRegular()
        priceLabel.textColor = UIColor.black
        self.addSubview(priceLabel)
        
        proStatusLabel = UILabel(frame: CGRect(x: 20, y: self.screenBounds.height*0.54, width: self.screenBounds.width-40, height: self.screenBounds.height*0.07))
        proStatusLabel.text = "Статус"
        proStatusLabel.font = UIFont().risingSunSmall()
        proStatusLabel.textColor = UIColor().mainColor()
        self.addSubview(proStatusLabel)
        
        statusLabel = UILabel(frame: CGRect(x: 20, y: self.screenBounds.height*0.58, width: self.screenBounds.width-40, height: self.screenBounds.height*0.07))
        statusLabel.text = "Завершен"
        statusLabel.font = UIFont().risingSunRegular()
        statusLabel.textColor = UIColor.black
        self.addSubview(statusLabel)
        
        cancelButton = UIButton(frame: CGRect(x: 20, y: self.screenBounds.height*0.68, width: self.screenBounds.width-40, height: 40))
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.titleLabel?.font = UIFont().risingSun()
        cancelButton.layer.cornerRadius = 20
        cancelButton.backgroundColor = UIColor().mainColor()
        cancelButton.addTarget(self, action: #selector(deleteOrder), for: .touchUpInside)
        cancelButton.isHidden = true
        self.addSubview(cancelButton)
        
        self.progressView = ProgressIndicatorView(frame: CGRect(x: frame.width*0.35, y: frame.height*0.3, width: frame.width*0.3, height: frame.width*0.32))
        self.progressView.layer.cornerRadius = 5
        self.progressView.messageLabel.text = "Загружаю заказ"
        self.progressView.messageLabel.font = UIFont().risingSunSmall()
        self.addSubview(self.progressView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
