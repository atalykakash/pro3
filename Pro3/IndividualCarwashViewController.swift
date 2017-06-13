//
//  IndividualCarwashViewController.swift
//  Pro3
//
//  Created by Admin on 5/9/17.
//  Copyright © 2017 AAkash. All rights reserved.
//

import UIKit
import RealmSwift

class IndividualCarwashViewController: UIViewController, MakeAndUnmakeFavoriteDelegate {
    
    let screenBounds = UIScreen.main.bounds
    
    var carwash = CarWash()
    
    var individualCarwashView = IndividualCarwashView()
    var isFavorite = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
    }

    func setup() {
        
        self.navigationItem.title = carwash.name.uppercased()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "RisingSun-Light", size: self.screenBounds.width*0.06)!]
        
        let locationRightButtonItem = UIBarButtonItem(image: UIImage(named: "notfav")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(makeFavoriteButtonPressed))
        self.navigationItem.rightBarButtonItem = locationRightButtonItem
        
        let leftBackButtonItem = UIBarButtonItem(image: UIImage(named: "notfav")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(popViewController))
        self.navigationItem.leftBarButtonItem = leftBackButtonItem
        
        self.individualCarwashView = IndividualCarwashView(frame: CGRect(x: 0, y: 0, width: self.screenBounds.width, height: self.screenBounds.height))
        self.individualCarwashView.parseServiceForCarTypes(carwashId: carwash.id, cityId: carwash.carWashCityId)
        self.individualCarwashView.carwashValue = self.carwash
        self.individualCarwashView.delegate = self
        self.view.addSubview(self.individualCarwashView)
    }
    
    func popViewController() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func makeAndUnmakeFavorite(isFavorite: String) {
        
        self.isFavorite = isFavorite
        
        if self.isFavorite == "Yes" {
            let locationRightButtonItem = UIBarButtonItem(image: UIImage(named: "fav")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.makeFavoriteButtonPressed))
            self.navigationItem.rightBarButtonItem = locationRightButtonItem
        } else {
            let locationRightButtonItem = UIBarButtonItem(image: UIImage(named: "notfav")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.makeFavoriteButtonPressed))
            self.navigationItem.rightBarButtonItem = locationRightButtonItem
        }
    }
    
    func makeFavoriteButtonPressed() {
        
        let realm = try! Realm()
        let user = realm.objects(User.self)
        
        if self.isFavorite == "No" {
            ApiHelper.makeCarwashFavorite(token: user[0].token, carwashId: carwash.id) { () in
                DispatchQueue.main.async {
                    let locationRightButtonItem = UIBarButtonItem(image: UIImage(named: "fav")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.makeFavoriteButtonPressed))
                    self.navigationItem.rightBarButtonItem = locationRightButtonItem
                    self.isFavorite = "Yes"
                }
            }
        } else {
            ApiHelper.deleteCarwashFavorite(token: user[0].token, carwashId: carwash.id, completion: { 
                DispatchQueue.main.async {
                    let locationRightButtonItem = UIBarButtonItem(image: UIImage(named: "notfav")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.makeFavoriteButtonPressed))
                    self.navigationItem.rightBarButtonItem = locationRightButtonItem
                    self.isFavorite = "No"
                }
            })
        }
    }
}
