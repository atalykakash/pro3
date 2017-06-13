//
//  AccountView.swift
//  Pro3
//
//  Created by Admin on 6/11/17.
//  Copyright © 2017 AAkash. All rights reserved.
//

import UIKit
import RealmSwift

class AccountView: UIView {
    
    let screenBounds = UIScreen.main.bounds
    
    lazy var proNameLabel = UILabel()
    lazy var nameLabel = UILabel()
    lazy var proPhoneLabel = UILabel()
    lazy var phoneLabel = UILabel()
    lazy var proCarLabel = UILabel()
    lazy var carLabel = UILabel()
    lazy var proCityLabel = UILabel()
    lazy var cityLabel = UILabel()
    lazy var contactButton = UIButton()
    lazy var proExitLabel = UILabel()
    lazy var exitLabel = UILabel()
    var exitButton = UIButton()
    lazy var aboutButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        
        updateData()
    }
    
    func updateData() {
        
        let realm = try! Realm()
        let user = realm.objects(User.self)
        
        if(user.count>0) {
            nameLabel.text = user[0].name
            phoneLabel.text = "+7\(user[0].phoneNumber)"
            carLabel.text = user[0].carTypeName
            cityLabel.text = user[0].cityName
        }
    }
    
    func setup() {
        
        self.backgroundColor = UIColor.white
        
        proNameLabel = UILabel(frame: CGRect(x: 20, y: 0, width: self.screenBounds.width-40, height: self.screenBounds.height*0.07))
        proNameLabel.text = "Имя"
        proNameLabel.font = UIFont().risingSunSmall()
        proNameLabel.textColor = UIColor().mainColor()
        self.addSubview(proNameLabel)
        
        nameLabel = UILabel(frame: CGRect(x: 20, y: self.screenBounds.height*0.05, width: self.screenBounds.width-40, height: self.screenBounds.height*0.07))
        nameLabel.text = "Имя"
        nameLabel.font = UIFont().risingSunRegularBig()
        nameLabel.textColor = UIColor.black
        self.addSubview(nameLabel)
        
        proPhoneLabel = UILabel(frame: CGRect(x: 20, y: self.screenBounds.height*0.10, width: self.screenBounds.width-40, height: self.screenBounds.height*0.07))
        proPhoneLabel.text = "Телефон"
        proPhoneLabel.font = UIFont().risingSunSmall()
        proPhoneLabel.textColor = UIColor().mainColor()
        self.addSubview(proPhoneLabel)
        
        phoneLabel = UILabel(frame: CGRect(x: 20, y: self.screenBounds.height*0.15, width: self.screenBounds.width-40, height: self.screenBounds.height*0.07))
        phoneLabel.text = "Имя"
        phoneLabel.font = UIFont().risingSunRegularBig()
        phoneLabel.textColor = UIColor.black
        self.addSubview(phoneLabel)
        
        proCarLabel = UILabel(frame: CGRect(x: 20, y: self.screenBounds.height*0.20, width: self.screenBounds.width-40, height: self.screenBounds.height*0.07))
        proCarLabel.text = "Автомобиль"
        proCarLabel.font = UIFont().risingSunSmall()
        proCarLabel.textColor = UIColor().mainColor()
        self.addSubview(proCarLabel)
        
        carLabel = UILabel(frame: CGRect(x: 20, y: self.screenBounds.height*0.25, width: self.screenBounds.width-40, height: self.screenBounds.height*0.07))
        carLabel.text = "Имя"
        carLabel.font = UIFont().risingSunRegularBig()
        carLabel.textColor = UIColor.black
        self.addSubview(carLabel)
        
        proCityLabel = UILabel(frame: CGRect(x: 20, y: self.screenBounds.height*0.30, width: self.screenBounds.width-40, height: self.screenBounds.height*0.07))
        proCityLabel.text = "Город"
        proCityLabel.font = UIFont().risingSunSmall()
        proCityLabel.textColor = UIColor().mainColor()
        self.addSubview(proCityLabel)
        
        cityLabel = UILabel(frame: CGRect(x: 20, y: self.screenBounds.height*0.35, width: self.screenBounds.width-40, height: self.screenBounds.height*0.07))
        cityLabel.text = "Имя"
        cityLabel.font = UIFont().risingSunRegularBig()
        cityLabel.textColor = UIColor.black
        self.addSubview(cityLabel)
        
        proExitLabel = UILabel(frame: CGRect(x: 20, y: self.screenBounds.height*0.40, width: self.screenBounds.width-40, height: self.screenBounds.height*0.07))
        proExitLabel.text = "Аккаунт"
        proExitLabel.font = UIFont().risingSunSmall()
        proExitLabel.textColor = UIColor().mainColor()
        self.addSubview(proExitLabel)
        
        exitLabel = UILabel(frame: CGRect(x: 20, y: self.screenBounds.height*0.45, width: self.screenBounds.width-40, height: self.screenBounds.height*0.07))
        exitLabel.text = "Выйти"
        exitLabel.font = UIFont().risingSunRegularBig()
        exitLabel.textColor = UIColor.black
        self.addSubview(exitLabel)
        
        exitButton = UIButton(frame: CGRect(x: 20, y: self.screenBounds.height*0.45, width: self.screenBounds.width-40, height: self.screenBounds.height*0.07))
        self.addSubview(exitButton)
        
        contactButton = UIButton(frame: CGRect(x: 20, y: self.screenBounds.height*0.55, width: self.screenBounds.width*0.5-25, height: 40))
        contactButton.setTitle("Контакты", for: .normal)
        contactButton.setTitleColor(UIColor().mainColor(), for: .normal)
        contactButton.titleLabel?.font = UIFont().risingSun()
        contactButton.layer.cornerRadius = 20
        contactButton.backgroundColor = UIColor.white
        contactButton.layer.borderColor = UIColor().mainColor().cgColor
        contactButton.layer.borderWidth = 0.5
        self.addSubview(contactButton)
        
        aboutButton = UIButton(frame: CGRect(x: self.screenBounds.width*0.5+5, y: self.screenBounds.height*0.55, width: self.screenBounds.width*0.5-25, height: 40))
        aboutButton.setTitle("О Проекте", for: .normal)
        aboutButton.setTitleColor(UIColor().mainColor(), for: .normal)
        aboutButton.titleLabel?.font = UIFont().risingSun()
        aboutButton.layer.cornerRadius = 20
        aboutButton.backgroundColor = UIColor.white
        aboutButton.layer.borderColor = UIColor().mainColor().cgColor
        aboutButton.layer.borderWidth = 0.5
        self.addSubview(aboutButton)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
