//
//  LoginViewController.swift
//  Pro3
//
//  Created by Admin on 5/6/17.
//  Copyright © 2017 AAkash. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, DismissViewControllerDelegate, PresentRegisterViewControllerDelegate {
    
    var loginView = LoginView()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
    }
    
    func loginButtonPressed() {
    
        guard let phoneNumber = self.loginView.phoneTextfield.text else {
            print("Enter phone number")
            return
        }
        
        let phoneString = NSMutableString()
        
        for i in phoneNumber.unicodeScalars {
            if i.value >= 48 && i.value <= 57 {
                phoneString.append(String(Character(i)))
            }
        }
        
        guard let password = self.loginView.passwordTextfield.text else {
            return
        }
        
        ApiHelper.delegate = self
        
        self.loginView.progressView.isHidden = false
        
        let alertController = UIAlertController(title: "Ошибка аутентификации", message: "Проверьте корректность данных", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Отмена", style: .default, handler: nil)
        alertController.addAction(alertAction)
        
        ApiHelper.loginUser(phoneNumber: String(phoneString), password: password) {
            DispatchQueue.main.async {
                self.loginView.progressView.isHidden = true
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func dismissViewController() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }

    func presentRegisterViewController() {
        self.present(RegisterViewController(), animated: true, completion: nil)
    }
    
    func setup() {
        
        self.loginView = LoginView(frame: UIScreen.main.bounds)
        self.loginView.loginButton.addTarget(self, action: #selector(self.loginButtonPressed), for: .touchUpInside)
        self.loginView.delegate = self
        self.view.addSubview(self.loginView)
    }

}
