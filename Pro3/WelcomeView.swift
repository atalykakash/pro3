//
//  SignInView.swift
//  Pro3
//
//  Created by Admin on 5/2/17.
//  Copyright © 2017 AAkash. All rights reserved.
//

import Foundation
import UIKit

class WelcomeView : UIView, UITextFieldDelegate {
    
    let screenBounds = UIScreen.main.bounds
    
    var phoneTextfield = ProTextField()
    var registerButton = UIButton()
    var loginButton = UIButton()
    var formattedString = NSMutableString()
    
    var citiesArray = [City]()
    
    var cityView = CityView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
        self.addViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        
        self.backgroundColor = UIColor.blue
        
        self.phoneTextfield.backgroundColor = UIColor.white
        self.phoneTextfield.translatesAutoresizingMaskIntoConstraints = false
        self.phoneTextfield.layer.cornerRadius = 5
        self.phoneTextfield.placeholder = "Номер телефона в формате: (XXX) XXX-XX-XX"
        self.phoneTextfield.delegate = self
        self.addSubview(phoneTextfield)
        
        self.registerButton.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
        self.registerButton.setTitle("ЗАРЕГИСТРИРОВАТЬСЯ", for: .normal)
        self.registerButton.setTitleColor(UIColor.white, for: .normal)
        self.registerButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.registerButton)
        
        self.loginButton.setTitle("Войти", for: .normal)
        self.loginButton.setTitleColor(UIColor.white, for: .normal)
        self.loginButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.loginButton)
    }
    
    func addViewConstraints() {
        
        self.addConstraints([NSLayoutConstraint(item: self.phoneTextfield, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.screenBounds.width*0.8)])
        self.addConstraints([NSLayoutConstraint(item: self.phoneTextfield, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 1.0)])
        self.addConstraints([NSLayoutConstraint(item: self.phoneTextfield, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.screenBounds.height*0.07)])
        self.addConstraints([NSLayoutConstraint(item: self.phoneTextfield, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 1.0)])
        
        self.addConstraints([NSLayoutConstraint(item: self.registerButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.screenBounds.width*0.8)])
        self.addConstraints([NSLayoutConstraint(item: self.registerButton, attribute: .top, relatedBy: .equal, toItem: self.phoneTextfield, attribute: .bottom, multiplier: 1.0, constant: 10.0)])
        self.addConstraints([NSLayoutConstraint(item: self.registerButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.screenBounds.height*0.07)])
        self.addConstraints([NSLayoutConstraint(item: self.registerButton, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 1.0)])
        
        self.addConstraints([NSLayoutConstraint(item: self.loginButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.screenBounds.width*0.8)])
        self.addConstraints([NSLayoutConstraint(item: self.loginButton, attribute: .top, relatedBy: .equal, toItem: self.registerButton, attribute: .bottom, multiplier: 1.0, constant: 10.0)])
        self.addConstraints([NSLayoutConstraint(item: self.loginButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.screenBounds.height*0.07)])
        self.addConstraints([NSLayoutConstraint(item: self.loginButton, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 1.0)])
    }
    
    func validatePhoneNumber() -> Bool {
        
        ApiHelper.getCities { (citiesArray) in
            self.citiesArray = citiesArray
        }
    
        let phoneRegex = "(?:((?:\\(\\d\\d\\d\\)|\\d\\d\\d)\\s+)?)(\\d{3}\\-\\-?\\d{2}\\-\\-?\\d{2})"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
    
        return phonePredicate.evaluate(with: self.formattedString)
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.phoneTextfield.placeholder = "Номер телефона в формате: (XXX) XXX-XX-XX"
        
    }
    
   
}
