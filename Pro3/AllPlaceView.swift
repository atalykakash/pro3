//
//  AllPlaceView.swift
//  Pro3
//
//  Created by Admin on 5/7/17.
//  Copyright © 2017 AAkash. All rights reserved.
//

import UIKit
import RealmSwift

protocol AllPlaceViewDelegate: class {
    func selectItem(carwash: CarWash)
    func setNavBarTitle(cityName: String)
}

class AllPlaceView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SelectCityDelegate, UITabBarControllerDelegate {
    
    weak var delegate: AllPlaceViewDelegate?
    
    lazy var collectionView = UICollectionView()
    var cityView = CityView()
    var progressView = ProgressIndicatorView()
    var closeButton = UIButton()
    let refreshControl = UIRefreshControl()
    
    let screenBounds = UIScreen.main.bounds
    
    let blurEffect = UIBlurEffect(style: .light)
    var visualEffectView = UIVisualEffectView()
    
    var carwashArray = [CarWash]()
    var cityArray = [City]()

    override init(frame: CGRect) {
        super.init(frame: frame)
     
        self.setup()
        
        self.getAllCarwashs()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func refreshData() {
        
        self.refreshControl.beginRefreshing()
       
        self.getAllCarwashs()
    }
    
    func getAllCarwashs() {
        
        let realm = try! Realm()
        
        let user = realm.objects(User.self)
        
        if user.count > 0 {

            ApiHelper.getAllCarwashs(token: user[0].token, cityId: user[0].cityId) { (carwashs) in
                DispatchQueue.main.async {
                    self.carwashArray = carwashs
                    self.collectionView.reloadData()
                    self.progressView.isHidden = true
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    func getAllCities() {
        
        self.animateCityView()
        
        self.cityView.activityIndicatorView.startAnimating()
        
        ApiHelper.getCities { (cities) in
            
            DispatchQueue.main.async {
                self.cityView.citiesArray = cities
                self.cityView.tableView.reloadData()
                self.cityView.activityIndicatorView.stopAnimating()
            }
        }
    }
    
    func animateCityView() {
        
        UIView.animate(withDuration: 0.5) {
            if self.cityView.frame.origin.y == self.screenBounds.height*1.12 {
                self.cityView.frame = CGRect(x: self.screenBounds.width*0.2, y: self.screenBounds.height*0.12, width: self.screenBounds.width*0.6, height: self.screenBounds.height*0.4)
                self.visualEffectView.isHidden = false
                self.visualEffectView.alpha = 1
                self.closeButton.isHidden = false
            } else {
                self.cityView.frame = CGRect(x: self.screenBounds.width*0.2, y: self.screenBounds.height*1.12, width: self.screenBounds.width*0.6, height: self.screenBounds.height*0.4)
                self.visualEffectView.isHidden = true
                self.visualEffectView.alpha = 0
                self.closeButton.isHidden = true
            }
        }
    }
    
    func returnSelectedCity(city: City) {
        
        self.animateCityView()
        
        self.progressView.isHidden = false
        
        let realm = try! Realm()
        
        let user = realm.objects(User.self)
        
        if user.count > 0 {
            
            ApiHelper.getAllCarwashs(token: user[0].token, cityId: city.id) { (carwashs) in
                DispatchQueue.main.async {
                    self.carwashArray = carwashs
                    self.collectionView.reloadData()
                    self.progressView.isHidden = true
                }
            }
        }
        
        self.delegate?.setNavBarTitle(cityName: city.name)
    }
    
    func setup() {
        
        self.backgroundColor = UIColor.white
        
        self.refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        self.refreshControl.tintColor = UIColor().mainColor()
        
        let layout = UICollectionViewFlowLayout()
        
        self.collectionView = UICollectionView(frame: CGRect(x: 0, y: 5, width: self.screenBounds.width, height: self.screenBounds.height-100), collectionViewLayout: layout)
        self.collectionView.register(CarwashCollectionViewCell.self, forCellWithReuseIdentifier: "CarwashCell")
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.addSubview(self.refreshControl)
        self.collectionView.alwaysBounceVertical = true
        self.addSubview(self.collectionView)
        
        self.visualEffectView = UIVisualEffectView(effect: blurEffect)
        self.visualEffectView.frame = self.screenBounds
        self.visualEffectView.isHidden = true
        self.addSubview(self.visualEffectView)
        
        self.cityView = CityView(frame: CGRect(x: self.screenBounds.width*0.2, y: self.screenBounds.height*1.12, width: self.screenBounds.width*0.6, height: self.screenBounds.height*0.4))
        self.cityView.layer.cornerRadius = 5
        self.cityView.delegate = self
        self.addSubview(self.cityView)
        
        self.closeButton = UIButton(frame: CGRect(x: self.screenBounds.width*0.5-27, y: self.screenBounds.height*0.6, width: 54, height: 54))
        self.closeButton.setImage(UIImage(named: "close"), for: .normal)
        self.closeButton.addTarget(self, action: #selector(self.animateCityView), for: .touchUpInside)
        self.closeButton.isHidden = true
        self.addSubview(self.closeButton)
        
        self.progressView = ProgressIndicatorView(frame: CGRect(x: frame.width*0.35, y: frame.height*0.3, width: frame.width*0.3, height: frame.width*0.32))
        self.progressView.layer.cornerRadius = 5
        self.progressView.messageLabel.text = "Загружаю данные"
        self.progressView.messageLabel.font = UIFont().risingSunSmall()
        self.addSubview(self.progressView)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.carwashArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarwashCell", for: indexPath) as! CarwashCollectionViewCell
        
        cell.backgroundColor = UIColor.white
        cell.titleLabel.text = self.carwashArray[indexPath.row].name
        cell.addressLabel.text = self.carwashArray[indexPath.row].address
        cell.serviceLabel.text = "Кузов + Салон от \(self.carwashArray[indexPath.row].price) тг"
        cell.layer.cornerRadius = 5
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.screenBounds.width*0.95, height: self.screenBounds.height/5)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.screenBounds.width*0.035
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.selectItem(carwash: self.carwashArray[indexPath.row])
    }
    
}
