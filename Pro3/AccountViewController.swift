//
//  AccountViewController.swift
//  Pro3
//
//  Created by Admin on 5/1/17.
//  Copyright © 2017 AAkash. All rights reserved.
//

import UIKit
import RealmSwift

class AccountViewController: UIViewController {
    
    let screenBounds = UIScreen.main.bounds
    
    var accountView = AccountView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    func exitButtonPressed() {
        
        UserDefaults.standard.removeObject(forKey: "phoneNumber")
        UserDefaults.standard.removeObject(forKey: "password")
        
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
        
        self.present(LoginViewController(), animated: true, completion: nil)
    }
    
    func setup() {
        
        self.navigationItem.title = "Аккаунт"
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "RisingSun-Light", size: self.screenBounds.width*0.06)!]
        
        self.accountView = AccountView(frame: UIScreen.main.bounds)
        self.accountView.exitButton.addTarget(self, action: #selector(exitButtonPressed), for: .touchUpInside)
        self.view.addSubview(self.accountView)
    }

}
