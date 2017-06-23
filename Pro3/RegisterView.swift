//
//  SignUpView.swift
//  Pro3
//
//  Created by Admin on 5/1/17.
//  Copyright © 2017 AAkash. All rights reserved.
//

import UIKit
import RealmSwift

protocol DismissRegisterViewControllerDelegate : class {
    func dismissViewController()
    func presentAlertController(message: String)
}

class RegisterView: UIView, SelectCityDelegate, SelectCarDelegate, UITextFieldDelegate {
    
    var nameLabel = UILabel()
    var nameTextfield = ProTextField()
    var phoneLabel = UILabel()
    var phoneTextfield = ProTextField()
    var passwordLabel = UILabel()
    var passwordTextfield = ProTextField()
    var confirmPasswordLabel = UILabel()
    var confirmPasswordTextfield = ProTextField()
    var cityTypeLabel = UILabel()
    var cityLabel = UILabel()
    var cityImageView = UIImageView()
    var cityButton = UIButton()
    var autoTypeLabel = UILabel()
    var autoLabel = UILabel()
    var autoImageView = UIImageView()
    var autoButton = UIButton()
    var createButton = UIButton()
    var loginButton = UIButton()
    var closeButton = UIButton()
    var progressView = ProgressIndicatorView()
    
    let blurEffect = UIBlurEffect(style: .light)
    var visualEffectView = UIVisualEffectView()
    
    var cityView = CityView()
    var carView = CarView()
    
    var cityId: String?
    var carId: String?
    
    let screenBounds = UIScreen.main.bounds
    
    weak var delegate: DismissRegisterViewControllerDelegate?
    
    var formattedString = NSMutableString()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
        self.addViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cityButtonPressed() {
        
        self.animateCityView()
        
        self.cityView.activityIndicatorView.startAnimating()
        
        ApiHelper.getCities { (cities) in
            self.cityView.citiesArray = cities
                    
            DispatchQueue.main.async {
                self.cityView.tableView.reloadData()
                self.cityView.activityIndicatorView.stopAnimating()
            }
        }
    }
    
    func autoButtonPressed() {
        
        self.animateCarView()
        
        self.carView.activityIndicatorView.startAnimating()
        
        ApiHelper.getCars { (cars) in
            self.carView.carsArray = cars
            
            DispatchQueue.main.async {
                self.carView.tableView.reloadData()
                self.carView.activityIndicatorView.stopAnimating()
            }
        }
    }
    
    func createButtonPressed() {
        
        guard let phoneNumber = self.phoneTextfield.text else {
            self.delegate?.presentAlertController(message: "Enter phone number")
            return
        }
        
        let phoneString = NSMutableString()
        
        for i in phoneNumber.unicodeScalars {
            if i.value >= 48 && i.value <= 57 {
                phoneString.append(String(Character(i)))
            }
        }
        
        guard let name = self.nameTextfield.text else {
            self.delegate?.presentAlertController(message: "Введите ваше имя")
            return
        }
        
        guard let password = self.passwordTextfield.text else {
            self.delegate?.presentAlertController(message: "Введите пароль")
            return
        }
        
        guard let confirmPassword = self.confirmPasswordTextfield.text else {
            self.delegate?.presentAlertController(message: "Потвердите пароль")
            return
        }
        
        if password != confirmPassword {
            self.delegate?.presentAlertController(message: "Проверьте совпадение пароля")
            return
        }
        
        if phoneNumber.characters.count == 0 || name.characters.count == 0 ||
           name.characters.count == 0 || password.characters.count == 0 || confirmPassword.characters.count == 0 {
            self.progressView.isHidden = true
            self.delegate?.presentAlertController(message: "Пожалуйста, заполните пустые поля")
        }
    
        guard let city = self.cityId else {
            self.delegate?.presentAlertController(message: "Мы будем рады если вы укажите ваш город :)")
            return
        }
        
        guard let car = self.carId else {
            self.delegate?.presentAlertController(message: "Пожалуйста, укажите ваш тип автомобиля")
            return
        }
        
        self.progressView.isHidden = false
        
        ApiHelper.registerUser(phoneNumber: phoneString as String, name: name, password: password, confirmPassword: confirmPassword, cityId: city, carId: car, completion: {
            self.delegate?.presentAlertController(message: "Ошибка аутентификации")
        }, dismissController: {
            self.delegate?.dismissViewController()
        })
    }
    
    func returnSelectedCity(city: City) {
        DispatchQueue.main.async {
            self.cityLabel.text = city.name
            self.cityId = city.id
            self.animateCityView()
        }
    }
    
    func returnSelectedCar(car: Car) {
        DispatchQueue.main.async {
            self.autoLabel.text = car.name
            self.carId = car.id
            self.animateCarView()
        }
    }
    
    func closeButtonPressed() {
        
        UIView.animate(withDuration: 0.5) {
            self.cityView.frame = CGRect(x: self.screenBounds.width*0.15, y: self.screenBounds.height*1.25, width: self.screenBounds.width*0.7, height: self.screenBounds.height*0.5)
            self.carView.frame = CGRect(x: self.screenBounds.width*0.15, y: self.screenBounds.height*1.25, width: self.screenBounds.width*0.7, height: self.screenBounds.height*0.5)
            self.visualEffectView.isHidden = true
            self.closeButton.isHidden = true
        }
    }
    
    func animateCityView() {
        
        UIView.animate(withDuration: 0.5) {
            if(self.cityView.frame.origin.y == self.screenBounds.height*0.25) {
                self.cityView.frame = CGRect(x: self.screenBounds.width*0.15, y: self.screenBounds.height*1.25, width: self.screenBounds.width*0.7, height: self.screenBounds.height*0.5)
                self.visualEffectView.isHidden = true
                self.closeButton.isHidden = true
            } else {
                self.cityView.frame = CGRect(x: self.screenBounds.width*0.15, y: self.screenBounds.height*0.25, width: self.screenBounds.width*0.7, height: self.screenBounds.height*0.5)
                self.visualEffectView.isHidden = false
                self.closeButton.isHidden = false
            }
        }
    }
    
    func animateCarView() {
        
        UIView.animate(withDuration: 0.5) {
            if(self.carView.frame.origin.y == self.screenBounds.height*0.25) {
                self.carView.frame = CGRect(x: self.screenBounds.width*0.15, y: self.screenBounds.height*1.25, width: self.screenBounds.width*0.7, height: self.screenBounds.height*0.5)
                self.visualEffectView.isHidden = true
                self.closeButton.isHidden = true
            } else {
                self.carView.frame = CGRect(x: self.screenBounds.width*0.15, y: self.screenBounds.height*0.25, width: self.screenBounds.width*0.7, height: self.screenBounds.height*0.5)
                self.visualEffectView.isHidden = false
                self.closeButton.isHidden = false
            }
        }
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
    
    func hideKeyboard() {
        
        phoneTextfield.resignFirstResponder()
        nameTextfield.resignFirstResponder()
        passwordTextfield.resignFirstResponder()
        confirmPasswordTextfield.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        phoneTextfield.resignFirstResponder()
        nameTextfield.resignFirstResponder()
        passwordTextfield.resignFirstResponder()
        confirmPasswordTextfield.resignFirstResponder()
        return false
    }
    
    func setup() {
        
        self.backgroundColor = UIColor.white
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.addGestureRecognizer(tapRecognizer)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = "Имя"
        nameLabel.font = UIFont().risingSunSmall()
        nameLabel.textColor = UIColor().mainColor()
        self.addSubview(nameLabel)
        
        nameTextfield.backgroundColor = UIColor.clear
        nameTextfield.placeholder = "Ваше имя"
        nameTextfield.translatesAutoresizingMaskIntoConstraints = false
        nameTextfield.layer.cornerRadius = 5
        nameTextfield.font = UIFont().risingSunRegular()
        nameTextfield.textColor = UIColor.black
        self.addSubview(nameTextfield)
        
        phoneLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneLabel.text = "Номер телефона"
        phoneLabel.font = UIFont().risingSunSmall()
        phoneLabel.textColor = UIColor().mainColor()
        self.addSubview(phoneLabel)
        
        phoneTextfield.backgroundColor = UIColor.clear
        phoneTextfield.placeholder = "(XXX) XXX-XX-XX"
        phoneTextfield.translatesAutoresizingMaskIntoConstraints = false
        phoneTextfield.font = UIFont().risingSunRegular()
        phoneTextfield.textColor = UIColor.black
        phoneTextfield.delegate = self
        self.addSubview(phoneTextfield)
        
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.text = "Пароль"
        passwordLabel.font = UIFont().risingSunSmall()
        passwordLabel.textColor = UIColor().mainColor()
        self.addSubview(passwordLabel)
        
        passwordTextfield.backgroundColor = UIColor.clear
        passwordTextfield.placeholder = "******"
        passwordTextfield.translatesAutoresizingMaskIntoConstraints = false
        passwordTextfield.font = UIFont().risingSunRegular()
        passwordTextfield.textColor = UIColor.black
        self.addSubview(passwordTextfield)
        
        confirmPasswordLabel.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordLabel.text = "Потвердите пароль"
        confirmPasswordLabel.font = UIFont().risingSunSmall()
        confirmPasswordLabel.textColor = UIColor().mainColor()
        self.addSubview(confirmPasswordLabel)
        
        confirmPasswordTextfield.backgroundColor = UIColor.clear
        confirmPasswordTextfield.placeholder = "******"
        confirmPasswordTextfield.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordTextfield.font = UIFont().risingSunRegular()
        confirmPasswordTextfield.textColor = UIColor.black
        self.addSubview(confirmPasswordTextfield)
        
        cityTypeLabel.text = "Ваш город"
        cityTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        cityTypeLabel.font = UIFont().risingSunSmall()
        cityTypeLabel.textColor = UIColor().mainColor()
        self.addSubview(cityTypeLabel)
        
        cityImageView.translatesAutoresizingMaskIntoConstraints = false
        cityImageView.image = UIImage(named: "down")
        self.addSubview(cityImageView)
        
        cityLabel.text = "Выберите город из списка"
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.font = UIFont().risingSunRegular()
        cityLabel.textColor = UIColor.black
        self.addSubview(cityLabel)
        
        cityButton.backgroundColor = UIColor.clear
        cityButton.translatesAutoresizingMaskIntoConstraints = false
        cityButton.layer.cornerRadius = 5
        cityButton.addTarget(self, action: #selector(cityButtonPressed), for: .touchUpInside)
        cityButton.setTitleColor(UIColor.black, for: .normal)
        self.addSubview(cityButton)
        
        autoLabel.text = "Выберите авто из списка"
        autoLabel.translatesAutoresizingMaskIntoConstraints = false
        autoLabel.font = UIFont().risingSunRegular()
        autoLabel.textColor = UIColor.black
        self.addSubview(autoLabel)
        
        autoTypeLabel.text = "Тип вашего авто"
        autoTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        autoTypeLabel.font = UIFont().risingSunSmall()
        autoTypeLabel.textColor = UIColor().mainColor()
        self.addSubview(autoTypeLabel)
        
        autoImageView.translatesAutoresizingMaskIntoConstraints = false
        autoImageView.image = UIImage(named: "down")
        self.addSubview(autoImageView)
        
        autoButton.backgroundColor = UIColor.clear
        autoButton.translatesAutoresizingMaskIntoConstraints = false
        autoButton.layer.cornerRadius = 5
        autoButton.addTarget(self, action: #selector(autoButtonPressed), for: .touchUpInside)
        autoButton.setTitleColor(UIColor.black, for: .normal)
        self.addSubview(autoButton)
        
        createButton.setTitle("Создать аккаунт", for: .normal)
        createButton.setTitleColor(UIColor.white, for: .normal)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.layer.cornerRadius = 20
        createButton.addTarget(self, action: #selector(createButtonPressed), for: .touchUpInside)
        createButton.backgroundColor = UIColor().mainColor()
        createButton.titleLabel?.font = UIFont().risingSun()
        self.addSubview(createButton)
        
        loginButton.setTitle("Войти", for: .normal)
        loginButton.setTitleColor(UIColor.black, for: .normal)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.layer.cornerRadius = 20
        loginButton.backgroundColor = UIColor().lightGrayBackgroundColor()
        loginButton.titleLabel?.font = UIFont().risingSun()
        self.addSubview(loginButton)
        
        self.visualEffectView = UIVisualEffectView(effect: blurEffect)
        self.visualEffectView.frame = self.screenBounds
        self.visualEffectView.isHidden = true
        self.addSubview(self.visualEffectView)
        
        self.cityView = CityView(frame: CGRect(x: self.screenBounds.width*0.15, y: self.screenBounds.height*1.25, width: self.screenBounds.width*0.7, height: self.screenBounds.height*0.5))
        self.cityView.layer.cornerRadius = 5
        self.cityView.delegate = self
        self.addSubview(self.cityView)
        
        self.carView = CarView(frame: CGRect(x: self.screenBounds.width*0.15, y: self.screenBounds.height*1.25, width: self.screenBounds.width*0.7, height: self.screenBounds.height*0.5))
        self.carView.layer.cornerRadius = 5
        self.carView.delegate = self
        self.addSubview(self.carView)
    
        self.progressView = ProgressIndicatorView(frame: CGRect(x: self.screenBounds.width*0.35, y: self.screenBounds.height*0.41, width: self.screenBounds.width*0.3, height: self.screenBounds.height*0.18))
        self.progressView.layer.cornerRadius = 5
        self.progressView.messageLabel.text = "Создаю аккаунт"
        self.progressView.messageLabel.font = UIFont().risingSunSmall()
        self.progressView.isHidden = true
        self.addSubview(self.progressView)
        
        self.closeButton = UIButton(frame: CGRect(x: self.screenBounds.width*0.5-27, y: self.screenBounds.height*0.8, width: 54, height: 54))
        self.closeButton.setImage(UIImage(named: "close"), for: .normal)
        self.closeButton.addTarget(self, action: #selector(self.closeButtonPressed), for: .touchUpInside)
        self.closeButton.isHidden = true
        self.addSubview(self.closeButton)
    }
    
    func addViewConstraints() {
        
        let views = ["nameTextfield"            : nameTextfield,
                     "phoneTextfield"           : phoneTextfield,
                     "passwordTextfield"        : passwordTextfield,
                     "confirmPasswordTextfield" : confirmPasswordTextfield,
                     "createButton"             : createButton,
                     "cityTypeLabel"            : cityTypeLabel,
                     "nameLabel"                : nameLabel] as [String : Any]
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(screenBounds.width*0.1)-[nameLabel]-\(screenBounds.width*0.1)-|", options: NSLayoutFormatOptions(), metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(screenBounds.height*0.1)-[nameLabel(\(screenBounds.height*0.03))]", options: NSLayoutFormatOptions(), metrics: nil, views: views))
        
        self.addConstraints([NSLayoutConstraint(item: self.nameTextfield, attribute: .width, relatedBy: .equal, toItem: self.nameLabel, attribute: .width, multiplier: 1.0, constant: 1.0)])
        self.addConstraints([NSLayoutConstraint(item: self.nameTextfield, attribute: .top, relatedBy: .equal, toItem: self.nameLabel, attribute: .bottom, multiplier: 1.0, constant: 1.0)])
        self.addConstraints([NSLayoutConstraint(item: self.nameTextfield, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: screenBounds.height*0.07)])
        self.addConstraints([NSLayoutConstraint(item: self.nameTextfield, attribute: .left, relatedBy: .equal, toItem: self.nameLabel, attribute: .left, multiplier: 1.0, constant: 1.0)])
        
        self.addConstraints([NSLayoutConstraint(item: self.phoneLabel, attribute: .width, relatedBy: .equal, toItem: self.nameTextfield, attribute: .width, multiplier: 1.0, constant: 1.0)])
        self.addConstraints([NSLayoutConstraint(item: self.phoneLabel, attribute: .top, relatedBy: .equal, toItem: self.nameTextfield, attribute: .bottom, multiplier: 1.0, constant: 1.0)])
        self.addConstraints([NSLayoutConstraint(item: self.phoneLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: screenBounds.height*0.03)])
        self.addConstraints([NSLayoutConstraint(item: self.phoneLabel, attribute: .left, relatedBy: .equal, toItem: self.nameTextfield, attribute: .left, multiplier: 1.0, constant: 1.0)])
        
        self.addConstraints([NSLayoutConstraint(item: self.phoneTextfield, attribute: .width, relatedBy: .equal, toItem: self.nameTextfield, attribute: .width, multiplier: 1.0, constant: 1.0)])
        self.addConstraints([NSLayoutConstraint(item: self.phoneTextfield, attribute: .left, relatedBy: .equal, toItem: self.nameLabel, attribute: .left, multiplier: 1.0, constant: 1.0)])
        self.addConstraints([NSLayoutConstraint(item: self.phoneTextfield, attribute: .top, relatedBy: .equal, toItem: self.phoneLabel, attribute: .bottom, multiplier: 1.0, constant: 0)])
        self.addConstraints([NSLayoutConstraint(item: self.phoneTextfield, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: screenBounds.height*0.07)])
        
        self.addConstraints([NSLayoutConstraint(item: self.passwordLabel, attribute: .width, relatedBy: .equal, toItem: self.nameTextfield, attribute: .width, multiplier: 1.0, constant: 1.0)])
        self.addConstraints([NSLayoutConstraint(item: self.passwordLabel, attribute: .top, relatedBy: .equal, toItem: self.phoneTextfield, attribute: .bottom, multiplier: 1.0, constant: 1.0)])
        self.addConstraints([NSLayoutConstraint(item: self.passwordLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: screenBounds.height*0.03)])
        self.addConstraints([NSLayoutConstraint(item: self.passwordLabel, attribute: .left, relatedBy: .equal, toItem: self.nameTextfield, attribute: .left, multiplier: 1.0, constant: 1.0)])
        
        self.addConstraints([NSLayoutConstraint(item: self.passwordTextfield, attribute: .width, relatedBy: .equal, toItem: self.phoneTextfield, attribute: .width, multiplier: 1.0, constant: 1.0)])
        self.addConstraints([NSLayoutConstraint(item: self.passwordTextfield, attribute: .top, relatedBy: .equal, toItem: self.passwordLabel, attribute: .bottom, multiplier: 1.0, constant: 0)])
        self.addConstraints([NSLayoutConstraint(item: self.passwordTextfield, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: screenBounds.height*0.07)])
        self.addConstraints([NSLayoutConstraint(item: self.passwordTextfield, attribute: .left, relatedBy: .equal, toItem: self.nameTextfield, attribute: .left, multiplier: 1.0, constant: 1.0)])
        
        self.addConstraints([NSLayoutConstraint(item: self.confirmPasswordLabel, attribute: .width, relatedBy: .equal, toItem: self.passwordTextfield, attribute: .width, multiplier: 1.0, constant: 1.0)])
        self.addConstraints([NSLayoutConstraint(item: self.confirmPasswordLabel, attribute: .top, relatedBy: .equal, toItem: self.passwordTextfield, attribute: .bottom, multiplier: 1.0, constant: 0)])
        self.addConstraints([NSLayoutConstraint(item: self.confirmPasswordLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: screenBounds.height*0.03)])
        self.addConstraints([NSLayoutConstraint(item: self.confirmPasswordLabel, attribute: .left, relatedBy: .equal, toItem: self.passwordTextfield, attribute: .left, multiplier: 1.0, constant: 1.0)])
        
        self.addConstraints([NSLayoutConstraint(item: self.confirmPasswordTextfield, attribute: .width, relatedBy: .equal, toItem: self.passwordTextfield, attribute: .width, multiplier: 1.0, constant: 1.0)])
        self.addConstraints([NSLayoutConstraint(item: self.confirmPasswordTextfield, attribute: .top, relatedBy: .equal, toItem: self.confirmPasswordLabel, attribute: .bottom, multiplier: 1.0, constant: 0)])
        self.addConstraints([NSLayoutConstraint(item: self.confirmPasswordTextfield, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: screenBounds.height*0.07)])
        self.addConstraints([NSLayoutConstraint(item: self.confirmPasswordTextfield, attribute: .left, relatedBy: .equal, toItem: self.passwordTextfield, attribute: .left, multiplier: 1.0, constant: 1.0)])
        
        self.addConstraints([NSLayoutConstraint(item: self.createButton, attribute: .width, relatedBy: .equal, toItem: self.nameLabel, attribute: .width, multiplier: 1.0, constant: 0)])
        self.addConstraints([NSLayoutConstraint(item: self.createButton, attribute: .top, relatedBy: .equal, toItem: self.autoButton, attribute: .bottom, multiplier: 1.0, constant: 10)])
        self.addConstraints([NSLayoutConstraint(item: self.createButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40)])
        self.addConstraints([NSLayoutConstraint(item: self.createButton, attribute: .left, relatedBy: .equal, toItem: self.nameTextfield, attribute: .left, multiplier: 1.0, constant: 1.0)])
        
        self.addConstraints([NSLayoutConstraint(item: self.loginButton, attribute: .width, relatedBy: .equal, toItem: self.createButton, attribute: .width, multiplier: 1.0, constant: 0)])
        self.addConstraints([NSLayoutConstraint(item: self.loginButton, attribute: .top, relatedBy: .equal, toItem: self.createButton, attribute: .bottom, multiplier: 1.0, constant: 15)])
        self.addConstraints([NSLayoutConstraint(item: self.loginButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40)])
        self.addConstraints([NSLayoutConstraint(item: self.loginButton, attribute: .left, relatedBy: .equal, toItem: self.nameTextfield, attribute: .left, multiplier: 1.0, constant: 1.0)])
        
        self.addConstraints([NSLayoutConstraint(item: self.cityTypeLabel, attribute: .width, relatedBy: .equal, toItem: self.nameLabel, attribute: .width, multiplier: 1.0, constant: 0)])
        self.addConstraints([NSLayoutConstraint(item: self.cityTypeLabel, attribute: .top, relatedBy: .equal, toItem: self.confirmPasswordTextfield, attribute: .bottom, multiplier: 1.0, constant: 0)])
        self.addConstraints([NSLayoutConstraint(item: self.cityTypeLabel, attribute: .left, relatedBy: .equal, toItem: self.nameTextfield, attribute: .left, multiplier: 1.0, constant: 1.0)])
        self.addConstraints([NSLayoutConstraint(item: self.cityTypeLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: screenBounds.height*0.03)])
        
        self.addConstraints([NSLayoutConstraint(item: self.cityLabel, attribute: .top, relatedBy: .equal, toItem: self.cityTypeLabel, attribute: .bottom, multiplier: 1.0, constant: 0)])
        self.addConstraints([NSLayoutConstraint(item: self.cityLabel, attribute: .left, relatedBy: .equal, toItem: self.cityTypeLabel, attribute: .left, multiplier: 1.0, constant: 1.0)])
        self.addConstraints([NSLayoutConstraint(item: self.cityLabel, attribute: .width, relatedBy: .equal, toItem: self.cityTypeLabel, attribute: .width, multiplier: 1.0, constant: 1.0)])
        self.addConstraints([NSLayoutConstraint(item: self.cityLabel, attribute: .height, relatedBy: .equal, toItem: self.nameTextfield, attribute: .height, multiplier: 1.0, constant: 1.0)])
        
        self.addConstraints([NSLayoutConstraint(item: self.cityImageView, attribute: .top, relatedBy: .equal, toItem: self.cityTypeLabel, attribute: .bottom, multiplier: 1.0, constant: screenBounds.height*0.07*0.3)])
        self.addConstraints([NSLayoutConstraint(item: self.cityImageView, attribute: .right, relatedBy: .equal, toItem: self.cityTypeLabel, attribute: .right, multiplier: 1.0, constant: 1.0)])
        self.addConstraints([NSLayoutConstraint(item: self.cityImageView, attribute: .width, relatedBy: .equal, toItem: self.cityTypeLabel, attribute: .height, multiplier: 1.0, constant: 1.0)])
        self.addConstraints([NSLayoutConstraint(item: self.cityImageView, attribute: .height, relatedBy: .equal, toItem: self.nameTextfield, attribute: .height, multiplier: 0.4, constant: 1.0)])
        
        self.addConstraints([NSLayoutConstraint(item: self.cityButton, attribute: .top, relatedBy: .equal, toItem: self.cityTypeLabel, attribute: .bottom, multiplier: 1.0, constant: 5.0)])
        self.addConstraints([NSLayoutConstraint(item: self.cityButton, attribute: .left, relatedBy: .equal, toItem: self.cityTypeLabel, attribute: .left, multiplier: 1.0, constant: 1.0)])
        self.addConstraints([NSLayoutConstraint(item: self.cityButton, attribute: .width, relatedBy: .equal, toItem: self.cityTypeLabel, attribute: .width, multiplier: 1.0, constant: 1.0)])
        self.addConstraints([NSLayoutConstraint(item: self.cityButton, attribute: .height, relatedBy: .equal, toItem: self.nameTextfield, attribute: .height, multiplier: 1.0, constant: 1.0)])
        
        self.addConstraints([NSLayoutConstraint(item: self.autoTypeLabel, attribute: .width, relatedBy: .equal, toItem: self.cityTypeLabel, attribute: .width, multiplier: 1.0, constant: 1.0)])
        self.addConstraints([NSLayoutConstraint(item: self.autoTypeLabel, attribute: .top, relatedBy: .equal, toItem: self.cityButton, attribute: .bottom, multiplier: 1.0, constant: 1.0)])
        self.addConstraints([NSLayoutConstraint(item: self.autoTypeLabel, attribute: .height, relatedBy: .equal, toItem: self.cityTypeLabel, attribute: .height, multiplier: 1.0, constant: 1.0)])
        self.addConstraints([NSLayoutConstraint(item: self.autoTypeLabel, attribute: .left, relatedBy: .equal, toItem: self.nameTextfield, attribute: .left, multiplier: 1.0, constant: 1.0)])
        
        self.addConstraints([NSLayoutConstraint(item: self.autoLabel, attribute: .top, relatedBy: .equal, toItem: self.autoTypeLabel, attribute: .bottom, multiplier: 1.0, constant: 0)])
        self.addConstraints([NSLayoutConstraint(item: self.autoLabel, attribute: .left, relatedBy: .equal, toItem: self.autoTypeLabel, attribute: .left, multiplier: 1.0, constant: 1.0)])
        self.addConstraints([NSLayoutConstraint(item: self.autoLabel, attribute: .width, relatedBy: .equal, toItem: self.autoTypeLabel, attribute: .width, multiplier: 1.0, constant: 1.0)])
        self.addConstraints([NSLayoutConstraint(item: self.autoLabel, attribute: .height, relatedBy: .equal, toItem: self.nameTextfield, attribute: .height, multiplier: 1.0, constant: 1.0)])
        
        self.addConstraints([NSLayoutConstraint(item: self.autoImageView, attribute: .top, relatedBy: .equal, toItem: self.autoTypeLabel, attribute: .bottom, multiplier: 1.0, constant: screenBounds.height*0.07*0.3)])
        self.addConstraints([NSLayoutConstraint(item: self.autoImageView, attribute: .right, relatedBy: .equal, toItem: self.cityTypeLabel, attribute: .right, multiplier: 1.0, constant: 1.0)])
        self.addConstraints([NSLayoutConstraint(item: self.autoImageView, attribute: .width, relatedBy: .equal, toItem: self.cityTypeLabel, attribute: .height, multiplier: 1.0, constant: 1.0)])
        self.addConstraints([NSLayoutConstraint(item: self.autoImageView, attribute: .height, relatedBy: .equal, toItem: self.nameTextfield, attribute: .height, multiplier: 0.4, constant: 1.0)])
        
        self.addConstraints([NSLayoutConstraint(item: self.autoButton, attribute: .top, relatedBy: .equal, toItem: self.autoTypeLabel, attribute: .bottom, multiplier: 1.0, constant: 5.0)])
        self.addConstraints([NSLayoutConstraint(item: self.autoButton, attribute: .left, relatedBy: .equal, toItem: self.autoTypeLabel, attribute: .left, multiplier: 1.0, constant: 1.0)])
        self.addConstraints([NSLayoutConstraint(item: self.autoButton, attribute: .width, relatedBy: .equal, toItem: self.autoTypeLabel, attribute: .width, multiplier: 1.0, constant: 1.0)])
        self.addConstraints([NSLayoutConstraint(item: self.autoButton, attribute: .height, relatedBy: .equal, toItem: self.nameTextfield, attribute: .height, multiplier: 1.0, constant: 1.0)])
    }

}
