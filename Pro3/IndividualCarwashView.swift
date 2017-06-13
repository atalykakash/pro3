//
//  IndividualCarwashView.swift
//  Pro3
//
//  Created by Admin on 5/9/17.
//  Copyright © 2017 AAkash. All rights reserved.
//

import UIKit
import RealmSwift

protocol MakeAndUnmakeFavoriteDelegate: class {
    func makeAndUnmakeFavorite(isFavorite: String)
}

class IndividualCarwashView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, HideTimeslotDelegate {
    
    let screenBounds = UIScreen.main.bounds
    
    lazy var chooseCarLabel = UILabel()
    lazy var chooseServiceLabel = UILabel()
    lazy var collectionView = UICollectionView()
    lazy var tableView = UITableView()
    lazy var priceLabel = UILabel()
    lazy var timeButton = UIButton()
    lazy var serviceLineView = UIView()
    
    let blurEffect = UIBlurEffect(style: .light)
    var visualEffectView = UIVisualEffectView()
    
    var timeslotView = TimeslotView()
    
    var carArray = [Car]()
    var carTypeArray = [CarType]()
    var serviceArray = [Service]()
    
    var selectedCar = Car()
    var selectedService = Service()
    var selectedCell = -1
    var selectedServiceCell = -1
    var isFavorite = String()
    var priceId = "2"
    
    var carwashValue: CarWash? {
        didSet {
            if let carwash = carwashValue {
                self.timeslotView.carwashValue = carwash
            }
        }
    }
    
    weak var delegate: MakeAndUnmakeFavoriteDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func parseServiceForCarTypes(carwashId: String, cityId: String) {
        
        let realm = try! Realm()
        
        let user = realm.objects(User.self)
        
        ApiHelper.getIndividualCarWash(token: user[0].token, carwashId: carwashId, cityId: cityId) { (carTypes, carWashInfo) in
            
            DispatchQueue.main.async {
                self.delegate?.makeAndUnmakeFavorite(isFavorite: carWashInfo.isFavorite)
                self.carTypeArray = carTypes
                self.getAllCars(carTypes: carTypes)
                self.collectionView.reloadData()
                self.selectedCar = self.carArray[0]
                self.getServicesForCarType(car: self.selectedCar)
            }
        }
        
        
    }
    
    func getAllCars(carTypes: [CarType]) {
        
        self.carArray.removeAll()
        
        var carSet = Set<String>()
        for carType in carTypes {
            let car = Car()
            car.id = carType.id
            car.name = carType.name
            if carSet.contains(car.name) == false {
                carSet.insert(car.name)
                self.carArray.append(car)
            }
        }
    }
    
    func getServicesForCarType(car: Car) {
        
        self.serviceArray.removeAll()
        
        var serviceSet = Set<String>()
        
        for item in self.carTypeArray {
            if item.name == car.name {
                let service = Service()
                service.id = item.serviceId
                service.name = item.serviceName
                service.priceId = item.priceId
                if serviceSet.contains(service.name) == false {
                    serviceSet.insert(service.name)
                    self.serviceArray.append(service)
                }
            }
        }
        
        self.serviceArray.sort { (service1, service2) -> Bool in
            return service1.name.characters.count < service2.name.characters.count
        }
    
        self.tableView.frame = CGRect(x: 10, y: self.screenBounds.height*0.4, width: self.screenBounds.width-20, height: CGFloat(self.serviceArray.count) * self.screenBounds.height*0.06)
        self.updateViewContraints()
        self.tableView.reloadData()
    }
 
    func setup() {
        
        self.backgroundColor = UIColor.white
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        self.chooseCarLabel = UILabel(frame: CGRect(x: 10, y: 0, width: frame.width-20, height: frame.height*0.05))
        self.chooseCarLabel.text = "Автомобиль"
        self.chooseCarLabel.textAlignment = .center
        self.chooseCarLabel.font = UIFont(name: "Helvetica-Light", size: frame.width*0.05)
        self.addSubview(self.chooseCarLabel)
        
        self.collectionView = UICollectionView(frame:  CGRect(x: 10, y: frame.height*0.05, width: self.screenBounds.width-20, height: self.screenBounds.height*0.29), collectionViewLayout: layout)
        self.collectionView.register(CarTypeCollectionViewCell.self, forCellWithReuseIdentifier: "CarTypeCell")
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.addSubview(self.collectionView)
        
        self.chooseServiceLabel = UILabel(frame: CGRect(x: 10, y: self.screenBounds.height*0.35, width: frame.width-20, height: frame.height*0.05))
        self.chooseServiceLabel.text = "Сервис"
        self.chooseServiceLabel.font = UIFont(name: "RisingSun-Light", size: frame.width*0.05)
        self.chooseServiceLabel.textAlignment = .left
        self.chooseServiceLabel.textColor = UIColor().mainColor()
        self.addSubview(self.chooseServiceLabel)
        
        self.tableView = UITableView(frame: CGRect(x: 10, y: self.screenBounds.height*0.35, width: self.screenBounds.width-20, height: self.screenBounds.height*0.25), style: .plain)
        self.tableView.register(ServiceTableViewCell.self, forCellReuseIdentifier: "ServiceCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.rowHeight = self.screenBounds.height*0.06
        self.addSubview(self.tableView)
        
        self.serviceLineView = UIView(frame: CGRect(x: 10, y: self.screenBounds.height*0.41, width: self.screenBounds.width-20, height: 0.5))
        self.serviceLineView.backgroundColor = UIColor().mainColor()
        self.addSubview(self.serviceLineView)
        
        self.priceLabel.text = "Price"
        self.priceLabel.backgroundColor = UIColor.red
        self.priceLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.priceLabel)
        
        self.timeButton.backgroundColor = UIColor.blue
        self.timeButton.translatesAutoresizingMaskIntoConstraints = false
        self.timeButton.addTarget(self, action: #selector(animateTimeslotView), for: .touchUpInside)
        self.addSubview(self.timeButton)
        
        self.visualEffectView = UIVisualEffectView(effect: blurEffect)
        self.visualEffectView.frame = self.screenBounds
        self.visualEffectView.isHidden = true
        self.addSubview(self.visualEffectView)
        
        self.timeslotView = TimeslotView(frame: CGRect(x: self.screenBounds.width*0.15, y: self.screenBounds.height*1.1, width: self.screenBounds.width*0.7, height: self.screenBounds.height*0.6))
        self.timeslotView.layer.cornerRadius = 10
        self.timeslotView.hideTimeslotDelegate = self
        self.addSubview(self.timeslotView)
    }
    
    func updateViewContraints() {
        
        self.addConstraints([NSLayoutConstraint(item: self.priceLabel, attribute: .top, relatedBy: .equal, toItem: self.tableView, attribute: .bottom, multiplier: 1, constant: 10)])
        self.addConstraints([NSLayoutConstraint(item: self.priceLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.screenBounds.width*0.3)])
        self.addConstraints([NSLayoutConstraint(item: self.priceLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.screenBounds.height*0.1)])
        
        self.addConstraints([NSLayoutConstraint(item: self.timeButton, attribute: .top, relatedBy: .equal, toItem: self.tableView, attribute: .bottom, multiplier: 1, constant: 10)])
        self.addConstraints([NSLayoutConstraint(item: self.timeButton, attribute: .left, relatedBy: .equal, toItem: self.priceLabel, attribute: .right, multiplier: 1, constant: 10)])
        self.addConstraints([NSLayoutConstraint(item: self.timeButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.screenBounds.width*0.3)])
        self.addConstraints([NSLayoutConstraint(item: self.timeButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.screenBounds.height*0.1)])
    }
    
    func animateTimeslotView() {
        print("\(self.priceId) is my id")
        self.timeslotView.priceId = self.priceId
        if self.timeslotView.frame.origin.y == self.screenBounds.height*0.1 {
            UIView.animate(withDuration: 0.5, animations: {
                self.timeslotView.frame = CGRect(x: self.screenBounds.width*0.15, y: self.screenBounds.height*1.1, width: self.screenBounds.width*0.7, height: self.screenBounds.height*0.6)
                self.visualEffectView.isHidden = true
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.timeslotView.frame = CGRect(x: self.screenBounds.width*0.15, y: self.screenBounds.height*0.1, width: self.screenBounds.width*0.7, height: self.screenBounds.height*0.6)
                self.visualEffectView.isHidden = false
            })
        }
    }
    
    func hideTimeslotView() {
        UIView.animate(withDuration: 0.4, animations: {
            self.timeslotView.frame = CGRect(x: self.screenBounds.width*0.15, y: self.screenBounds.height*1.1, width: self.screenBounds.width*0.7, height: self.screenBounds.height*0.6)
            self.visualEffectView.isHidden = true
        })
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.carArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.screenBounds.height*0.25, height: self.screenBounds.height*0.27)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarTypeCell", for: indexPath) as! CarTypeCollectionViewCell
        cell.carLabel.text = self.carArray[indexPath.row].name
        cell.blackView.isHidden = true
        if selectedCell == indexPath.row {
            cell.blackView.isHidden = false
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.selectedCell = indexPath.row
        self.selectedCar = self.carArray[indexPath.row]
        
        for carType in carTypeArray {
            if carType.id == self.selectedCar.id && carType.serviceId == self.selectedService.id {
                self.priceLabel.text = carType.priceString
                self.priceId = carType.priceId
                print("\(self.priceId) is collect")
            }
        }
        
        self.getServicesForCarType(car: self.selectedCar)
        
        self.collectionView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.serviceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceCell", for: indexPath) as! ServiceTableViewCell
        cell.serviceLabel.text = self.serviceArray[indexPath.row].name
        cell.picImageView.isHidden = true
        if selectedServiceCell == indexPath.row {
            cell.picImageView.isHidden = false
            print("\(self.priceId) is cell row")
        }
        if (selectedServiceCell == -1 && self.serviceArray[indexPath.row].name == "Кузов + Салон") {
            cell.picImageView.isHidden = false
            self.priceId = self.serviceArray[indexPath.row].priceId
            //print("\(self.serviceArray[indexPath.row].priceId) is cell row")
        }
        print("\(self.serviceArray[indexPath.row].priceId) is cell row")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedService = self.serviceArray[indexPath.row]
        self.selectedServiceCell = indexPath.row
        
        for carType in carTypeArray {
            if carType.id == self.selectedCar.id && carType.serviceId == self.selectedService.id {
                self.priceLabel.text = carType.priceString
                self.priceId = carType.priceId
                print("\(self.priceId) is price id")
            }
        }
        
        self.tableView.reloadData()
    }
}
