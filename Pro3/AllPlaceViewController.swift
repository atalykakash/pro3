//
//  AllPlaceViewController.swift
//  Pro3
//
//  Created by Admin on 5/1/17.
//  Copyright © 2017 AAkash. All rights reserved.
//

import UIKit
import RealmSwift

class AllPlaceViewController: UIViewController, AllPlaceViewDelegate {
    
    let screenBounds = UIScreen.main.bounds
    
    var allPlaceView = AllPlaceView()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
    
    }
    
    func selectItem(carwash: CarWash) {
        
        let individualCarwashViewController = IndividualCarwashViewController()
        individualCarwashViewController.carwash = carwash
        
        self.navigationController?.pushViewController(individualCarwashViewController, animated: true)
    }
    
    func locationBarButtonItemPressed() {
        self.allPlaceView.getAllCities()
    }
    
    func setNavBarTitle(cityName: String) {
        
         self.navigationItem.title = "\(cityName)"
    }
    
    func setup() {
        
        let realm = try! Realm()
        let user = realm.objects(User.self)
        
        self.navigationItem.title = (user.count>0) ? user[0].cityName : "Астана"
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "RisingSun-Light", size: self.screenBounds.width*0.06)!]
            
        let locationRightButtonItem = UIBarButtonItem(image: UIImage(named: "down")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(locationBarButtonItemPressed))
        self.navigationItem.rightBarButtonItem = locationRightButtonItem
        
        self.allPlaceView = AllPlaceView(frame: CGRect(x: 0, y: 0, width: self.screenBounds.width, height: self.screenBounds.height))
        self.allPlaceView.delegate = self
        self.view.addSubview(self.allPlaceView)
    }

}
