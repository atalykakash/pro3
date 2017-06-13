//
//  FavoritePlaceView.swift
//  Pro3
//
//  Created by Admin on 5/1/17.
//  Copyright © 2017 AAkash. All rights reserved.
//

import UIKit
import RealmSwift

class FavoritePlaceView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let screenBounds = UIScreen.main.bounds
    
    lazy var collectionView = UICollectionView()
    var progressView = ProgressIndicatorView()
    var refreshControl = UIRefreshControl()
    
    var carwashArray = [CarWash]()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        
        getAllCarwashs()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getAllCarwashs() {
        
        let realm = try! Realm()
        
        let user = realm.objects(User.self)
        
        if user.count > 0 {
            
            ApiHelper.getFavoriteCarWashes(token: user[0].token, userId: user[0].id, completion: { (carwashes) in
                DispatchQueue.main.async {
                    print("working")
                    self.carwashArray = carwashes
                    self.collectionView.reloadData()
                    self.refreshControl.endRefreshing()
                    self.progressView.isHidden = true
                }
            })
        }
    }
    
    func refreshData() {
        
        self.refreshControl.beginRefreshing()
        
        self.getAllCarwashs()
    }
    
    func setup() {
        
        self.refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        self.refreshControl.tintColor = UIColor().mainColor()
        
        let layout = UICollectionViewFlowLayout()
        
        self.collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.screenBounds.width, height: self.screenBounds.height), collectionViewLayout: layout)
        self.collectionView.register(CarwashCollectionViewCell.self, forCellWithReuseIdentifier: "FavoriteCarwashCell")
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.addSubview(self.refreshControl)
        self.collectionView.alwaysBounceVertical = true
        self.addSubview(self.collectionView)
        
        self.progressView = ProgressIndicatorView(frame: CGRect(x: frame.width*0.35, y: frame.height*0.3, width: frame.width*0.3, height: frame.width*0.32))
        self.progressView.layer.cornerRadius = 5
        self.progressView.messageLabel.text = "Загружаю избранные"
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCarwashCell", for: indexPath) as! CarwashCollectionViewCell
        
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
        return self.screenBounds.width*0.025
    }

}
