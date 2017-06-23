//
//  IndividualOrderViewController.swift
//  Pro3
//
//  Created by Admin on 6/13/17.
//  Copyright © 2017 AAkash. All rights reserved.
//

import UIKit

class IndividualOrderViewController: UIViewController {

    let screenBounds = UIScreen.main.bounds
    var order = Order()
    
    var individualOrderView = IndividualOrderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func popViewController() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func setup() {
        
        self.navigationItem.title = "Заказ"
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "RisingSun-Light", size: self.screenBounds.width*0.06)!]
        
        let leftBackButtonItem = UIBarButtonItem(image: UIImage(named: "back")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(popViewController))
        self.navigationItem.leftBarButtonItem = leftBackButtonItem
        
        self.individualOrderView = IndividualOrderView(frame: UIScreen.main.bounds)
        self.individualOrderView.order = order
        self.view.addSubview(self.individualOrderView)
    }

}
