//
//  SignInViewController.swift
//  Pro3
//
//  Created by Admin on 5/2/17.
//  Copyright © 2017 AAkash. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController, DismissViewControllerDelegate {
    
    let loginView = WelcomeView()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
        self.addViewConstraints()
    }
    
    func dismissViewController() {
        self.dismiss(animated: false, completion: nil)
    }

    func setup() {
        
        ApiHelper.delegate = self
        
        self.loginView.translatesAutoresizingMaskIntoConstraints = false
        self.loginView.registerButton.addTarget(self, action: #selector(self.registerButtonPressed), for: .touchUpInside)
        self.loginView.loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        self.view.addSubview(self.loginView)
    }
    
    func addViewConstraints() {
        
        let views = ["loginView" : loginView]
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[loginView]|", options: NSLayoutFormatOptions(), metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[loginView]|", options: NSLayoutFormatOptions(), metrics: nil, views: views))
    }
    
    func registerButtonPressed() {
        
        if self.loginView.validatePhoneNumber() {
            
            let registerViewController = RegisterViewController()
            registerViewController.registerView.phoneTextfield.text = self.loginView.phoneTextfield.text
        
            self.present(registerViewController, animated: true, completion: nil)
        }
    }
    
    func loginButtonPressed() {
        
        let loginViewController = LoginViewController()
        self.present(loginViewController, animated: true, completion: nil)
    }

}
