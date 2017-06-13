//
//  LoginView.swift
//  Pro3
//
//  Created by Admin on 5/5/17.
//  Copyright © 2017 AAkash. All rights reserved.
//

import UIKit

protocol PresentRegisterViewControllerDelegate : class {
    func presentRegisterViewController()
}

class LoginView: UIView, UITextFieldDelegate {
    
    let screenBounds = UIScreen.main.bounds
    
    var welcomeLabel = UILabel()
    var phoneTextfield = ProTextField()
    var phoneLineView = UIView()
    var passwordTextfield = ProTextField()
    var passwordLineView = UIView()
    var loginButton = UIButton()
    var signUpButton = UIButton()
    var formattedString = NSMutableString()
    var progressView = ProgressIndicatorView()
    
    weak var delegate: PresentRegisterViewControllerDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
        self.addViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func validatePhoneNumber() -> Bool {
        
        let phoneRegex = "(?:((?:\\(\\d\\d\\d\\)|\\d\\d\\d)\\s+)?)(\\d{3}\\-\\-?\\d{2}\\-\\-?\\d{2})"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        
        return phonePredicate.evaluate(with: self.formattedString)
    }
    
    func signUpButtonPressed() {
        
        delegate?.presentRegisterViewController()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneTextfield {
            
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let components = (newString as NSString).components(separatedBy: NSCharacterSet.decimalDigits.inverted)
            
            let decimalString = components.joined(separator: "") as NSString
            let length = decimalString.length
            let hasLeadingOne = length > 0 && decimalString.character(at: 0) == (1 as unichar)
            
            if length == 0 || (length > 10 && !hasLeadingOne) || length > 11 {
                let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
                
                return (newLength > 10) ? false : true
            }
            var index = 0 as Int
            self.formattedString = NSMutableString()
            
            if (length - index) > 3 {
                let areaCode = decimalString.substring(with: NSMakeRange(index, 3))
                formattedString.appendFormat("(%@) ", areaCode)
                index += 3
            }
            if length - index > 3 {
                let prefix = decimalString.substring(with: NSMakeRange(index, 3))
                formattedString.appendFormat("%@-", prefix)
                index += 3
            }
            if length - index > 2 {
                let prefix = decimalString.substring(with: NSMakeRange(index, 2))
                formattedString.appendFormat("%@-", prefix)
                index += 2
            }
            
            let remainder = decimalString.substring(from: index)
            formattedString.append(remainder)
            textField.text = formattedString as String
            return false
            
        } else {
            return true
        }
    }
    
    //MARK - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.phoneTextfield.placeholder = "(XXX) XXX-XX-XX"
    }

    func setup() {
        
        self.backgroundColor = UIColor.white
        
        self.welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.welcomeLabel.text = "Добро пожаловать"
        self.welcomeLabel.numberOfLines = 0
        self.welcomeLabel.font = UIFont(name: "RisingSun-Light", size: self.screenBounds.width*0.13)
        self.addSubview(self.welcomeLabel)
        
        self.phoneTextfield.backgroundColor = UIColor.white
        self.phoneTextfield.translatesAutoresizingMaskIntoConstraints = false
        self.phoneTextfield.placeholder = "(xxx) xxx-xx-xx"
        self.phoneTextfield.delegate = self
        self.phoneTextfield.font = UIFont().risingSunRegularBig()
        self.addSubview(self.phoneTextfield)
        
        self.passwordTextfield.backgroundColor = UIColor.white
        self.passwordTextfield.translatesAutoresizingMaskIntoConstraints = false
        self.passwordTextfield.placeholder = "******"
        self.passwordTextfield.font = UIFont().risingSunRegularBig()
        self.addSubview(self.passwordTextfield)
        
        self.phoneLineView.translatesAutoresizingMaskIntoConstraints = false
        self.phoneLineView.backgroundColor = UIColor.black
        self.addSubview(self.phoneLineView)
        
        self.passwordLineView.translatesAutoresizingMaskIntoConstraints = false
        self.passwordLineView.backgroundColor = UIColor.black
        self.addSubview(self.passwordLineView)
        
        self.loginButton.backgroundColor = UIColor().mainColor()
        self.loginButton.setTitle("Войти", for: .normal)
        self.loginButton.setTitleColor(UIColor.white, for: .normal)
        self.loginButton.translatesAutoresizingMaskIntoConstraints = false
        self.loginButton.layer.cornerRadius = self.screenBounds.height*0.035
        self.loginButton.titleLabel?.font = UIFont().risingSun()
        self.addSubview(self.loginButton)
        
        self.signUpButton.backgroundColor = UIColor().lightGrayBackgroundColor()
        self.signUpButton.setTitle("Создать аккаунт", for: .normal)
        self.signUpButton.setTitleColor(UIColor.black, for: .normal)
        self.signUpButton.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        self.signUpButton.translatesAutoresizingMaskIntoConstraints = false
        self.signUpButton.layer.cornerRadius = self.screenBounds.height*0.035
        self.signUpButton.titleLabel?.font = UIFont().risingSun()
        self.addSubview(self.signUpButton)
        
        self.progressView = ProgressIndicatorView(frame: CGRect(x: frame.width*0.35, y: frame.height*0.41, width: frame.width*0.3, height: frame.height*0.18))
        self.progressView.layer.cornerRadius = 5
        self.progressView.messageLabel.text = "Проверка данных"
        self.progressView.messageLabel.font = UIFont().risingSunSmall()
        self.progressView.isHidden = true
        self.addSubview(self.progressView)
    }
    
    func addViewConstraints() {
        
        let views = ["phoneTextfield"    : phoneTextfield,
                     "passwordTextfield" : passwordTextfield,
                     "welcomeLabel"      : welcomeLabel] as [String : Any]
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(screenBounds.width*0.1)-[welcomeLabel]-\(screenBounds.width*0.1)-|", options: NSLayoutFormatOptions(), metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(screenBounds.height*0.15)-[welcomeLabel(\(screenBounds.height*0.2))]", options: NSLayoutFormatOptions(), metrics: nil, views: views))
        
        self.addConstraints([NSLayoutConstraint(item: self.phoneTextfield, attribute: .top, relatedBy: .equal, toItem: self.welcomeLabel, attribute: .bottom, multiplier: 1, constant: 20)])
        self.addConstraints([NSLayoutConstraint(item: self.phoneTextfield, attribute: .width, relatedBy: .equal, toItem: self.welcomeLabel, attribute: .width, multiplier: 1, constant: 0.7)])
        self.addConstraints([NSLayoutConstraint(item: self.phoneTextfield, attribute: .left, relatedBy: .equal, toItem: self.welcomeLabel, attribute: .left, multiplier: 1, constant: 0)])
        self.addConstraints([NSLayoutConstraint(item: self.phoneTextfield, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: screenBounds.height*0.07)])
        
        self.addConstraints([NSLayoutConstraint(item: self.phoneLineView, attribute: .top, relatedBy: .equal, toItem: self.phoneTextfield, attribute: .bottom, multiplier: 1, constant: 5)])
        self.addConstraints([NSLayoutConstraint(item: self.phoneLineView, attribute: .width, relatedBy: .equal, toItem: self.phoneTextfield, attribute: .width, multiplier: 1, constant: 1)])
        self.addConstraints([NSLayoutConstraint(item: self.phoneLineView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1)])
        self.addConstraints([NSLayoutConstraint(item: self.phoneLineView, attribute: .left, relatedBy: .equal, toItem: self.phoneTextfield, attribute: .left, multiplier: 1, constant: 0)])
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(screenBounds.width*0.1)-[passwordTextfield]-\(screenBounds.width*0.1)-|", options: NSLayoutFormatOptions(), metrics: nil, views: views))
        self.addConstraints([NSLayoutConstraint(item: self.passwordTextfield, attribute: .top, relatedBy: .equal, toItem: self.phoneLineView, attribute: .bottom, multiplier: 1.0, constant: 10.0)])
        self.passwordTextfield.addConstraints([NSLayoutConstraint(item: self.passwordTextfield, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: screenBounds.height*0.07)])
        
        self.addConstraints([NSLayoutConstraint(item: self.passwordLineView, attribute: .top, relatedBy: .equal, toItem: self.passwordTextfield, attribute: .bottom, multiplier: 1, constant: 5)])
        self.addConstraints([NSLayoutConstraint(item: self.passwordLineView, attribute: .width, relatedBy: .equal, toItem: self.passwordTextfield, attribute: .width, multiplier: 1, constant: 1)])
        self.addConstraints([NSLayoutConstraint(item: self.passwordLineView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1)])
        self.addConstraints([NSLayoutConstraint(item: self.passwordLineView, attribute: .left, relatedBy: .equal, toItem: self.passwordTextfield, attribute: .left, multiplier: 1, constant: 0)])
        
        self.addConstraints([NSLayoutConstraint(item: self.loginButton, attribute: .top, relatedBy: .equal, toItem: self.passwordLineView, attribute: .bottom, multiplier: 1, constant: self.screenBounds.height*0.07)])
        self.addConstraints([NSLayoutConstraint(item: self.loginButton, attribute: .width, relatedBy: .equal, toItem: self.passwordLineView, attribute: .width, multiplier: 1, constant: 0)])
        self.addConstraints([NSLayoutConstraint(item: self.loginButton, attribute: .left, relatedBy: .equal, toItem: self.passwordLineView, attribute: .left, multiplier: 1, constant: 0)])
        self.addConstraints([NSLayoutConstraint(item: self.loginButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)])
        
        self.addConstraints([NSLayoutConstraint(item: self.signUpButton, attribute: .top, relatedBy: .equal, toItem: self.loginButton, attribute: .bottom, multiplier: 1, constant: 15)])
        self.addConstraints([NSLayoutConstraint(item: self.signUpButton, attribute: .width, relatedBy: .equal, toItem: self.loginButton, attribute: .width, multiplier: 1, constant: 0)])
        self.addConstraints([NSLayoutConstraint(item: self.signUpButton, attribute: .left, relatedBy: .equal, toItem: self.loginButton, attribute: .left, multiplier: 1, constant: 0)])
        self.addConstraints([NSLayoutConstraint(item: self.signUpButton, attribute: .height, relatedBy: .equal, toItem: self.loginButton, attribute: .height, multiplier: 1, constant: 1)])
    }

}
