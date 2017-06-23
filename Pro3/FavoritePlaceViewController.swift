//
//  FavoritePlaceViewController.swift
//  Pro3
//
//  Created by Admin on 5/1/17.
//  Copyright © 2017 AAkash. All rights reserved.
//

import UIKit

class FavoritePlaceViewController: UIViewController, SelectFavoriteDelegate {
    
    let screenBounds = UIScreen.main.bounds
    
    var favoritePlaceView = FavoritePlaceView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    func selectFavorite(carwash: CarWash) {
        
        let individualCarwashViewController = IndividualCarwashViewController()
        individualCarwashViewController.carwash = carwash
        
        self.navigationController?.pushViewController(individualCarwashViewController, animated: true)
    }
    
    func setup() {
        
        self.navigationItem.title = "Избранные"
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "RisingSun-Light", size: self.screenBounds.width*0.06)!]
        
        self.favoritePlaceView = FavoritePlaceView(frame: CGRect(x: 0, y: 0, width: self.screenBounds.width, height: self.screenBounds.height))
        favoritePlaceView.delegate = self
        self.view.addSubview(self.favoritePlaceView)
    }

}
