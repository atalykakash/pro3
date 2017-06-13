//
//  SignUpViewController.swift
//  Pro3
//
//  Created by Admin on 5/1/17.
//  Copyright © 2017 AAkash. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, DismissRegisterViewControllerDelegate {
    
    let screenBounds = UIScreen.main.bounds
    
    var registerView = RegisterView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
        self.addViewConstraints()
    }
    
    func setup() {
        
        self.registerView.translatesAutoresizingMaskIntoConstraints = false
        self.registerView.delegate = self
        self.registerView.loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        self.view.addSubview(registerView)
    }
    
    func dismissViewController() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func loginButtonPressed() {
        self.present(LoginViewController(), animated: true, completion: nil)
    }
    
    func addViewConstraints() {
        
        let views = ["registerView" : registerView]
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[registerView]|", options: NSLayoutFormatOptions(), metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[registerView]|", options: NSLayoutFormatOptions(), metrics: nil, views: views))
    }
    
}
