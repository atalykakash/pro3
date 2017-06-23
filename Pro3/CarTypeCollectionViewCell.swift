//
//  CarTypeCollectionViewCell.swift
//  Pro3
//
//  Created by Admin on 5/9/17.
//  Copyright © 2017 AAkash. All rights reserved.
//

import UIKit

class CarTypeCollectionViewCell: UICollectionViewCell {
    
    var picImageView = UIImageView()
    var checkImageView = UIImageView()
    var carLabel = UILabel()
    var blackView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
        self.addViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        
        self.backgroundColor = UIColor.clear
        
        self.clipsToBounds = true
        
        self.picImageView.image = UIImage(named: "auto")
        self.picImageView.translatesAutoresizingMaskIntoConstraints = false
        self.picImageView.layer.cornerRadius = 10
        self.picImageView.layer.masksToBounds = true 
        self.addSubview(self.picImageView)
        
        self.carLabel.textColor = UIColor.black
        self.carLabel.translatesAutoresizingMaskIntoConstraints = false
        self.carLabel.backgroundColor = UIColor.clear
        self.carLabel.textAlignment = .center
        self.carLabel.font = UIFont(name: "Helvetica-Light", size: frame.width*0.11)
        self.addSubview(self.carLabel)
        
        self.blackView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height*0.8))
        self.blackView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        self.blackView.layer.cornerRadius = 10
        self.blackView.isHidden = true
        self.addSubview(self.blackView)
        
        self.checkImageView.image = UIImage(named: "checked")
        self.checkImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.checkImageView)
    }
    
    func addViewConstraints() {
  
        self.addConstraints([NSLayoutConstraint(item: self.picImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: frame.width)])
        self.addConstraints([NSLayoutConstraint(item: self.picImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: frame.height*0.8)])
        self.addConstraints([NSLayoutConstraint(item: self.picImageView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)])
        self.addConstraints([NSLayoutConstraint(item: self.picImageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)])
        
        self.addConstraints([NSLayoutConstraint(item: self.carLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: frame.width)])
        self.addConstraints([NSLayoutConstraint(item: self.carLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: frame.height*0.25)])
        self.addConstraints([NSLayoutConstraint(item: self.carLabel, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)])
        self.addConstraints([NSLayoutConstraint(item: self.carLabel, attribute: .top, relatedBy: .equal, toItem: self.picImageView, attribute: .bottom, multiplier: 1, constant: 0)])
        
        self.addConstraints([NSLayoutConstraint(item: self.checkImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20)])
        self.addConstraints([NSLayoutConstraint(item: self.checkImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 18)])
        self.addConstraints([NSLayoutConstraint(item: self.checkImageView, attribute: .centerY, relatedBy: .equal, toItem: self.picImageView, attribute: .centerY, multiplier: 1, constant: 0)])
        self.addConstraints([NSLayoutConstraint(item: self.checkImageView, attribute: .centerX, relatedBy: .equal, toItem: self.picImageView, attribute: .centerX, multiplier: 1, constant: 0)])
    }
}
