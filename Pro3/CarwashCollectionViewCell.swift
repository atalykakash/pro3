//
//  CarwashCollectionViewCell.swift
//  Pro3
//
//  Created by Admin on 5/7/17.
//  Copyright © 2017 AAkash. All rights reserved.
//

import UIKit

class CarwashCollectionViewCell: UICollectionViewCell {
    
    var picImageView = UIImageView()
    var titleLabel = UILabel()
    var addressLabel = UILabel()
    var serviceLabel = UILabel()
    var distanceLabel = UILabel()
    var favView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
        self.addViewContraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        
        self.contentView.clipsToBounds = true
        
        self.contentView.layer.cornerRadius = 2.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        
        self.layer.shadowColor = UIColor(red: 236/255, green:  236/255, blue:  236/255, alpha: 1.0).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
        
        self.favView.backgroundColor = UIColor.white
        self.favView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.favView)
        
        self.picImageView.image = UIImage(named: "auto")
        self.picImageView.backgroundColor = UIColor.red
        self.picImageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.picImageView)
        
        self.titleLabel.textColor = UIColor.black
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.font = UIFont().risingSunBold()
        self.contentView.addSubview(self.titleLabel)
        
        self.addressLabel.textColor = UIColor.black
        self.addressLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addressLabel.font = UIFont().risingSunRegular()
        self.addressLabel.numberOfLines = 0
        self.contentView.addSubview(self.addressLabel)
        
        self.serviceLabel.textColor = UIColor.black
        self.serviceLabel.translatesAutoresizingMaskIntoConstraints = false
        self.serviceLabel.font = UIFont().risingSunSmall()
        self.contentView.addSubview(self.serviceLabel)
    }
    
    func addViewContraints() {
        
        let frameBounds = self.frame.size
        
        self.addConstraints([NSLayoutConstraint(item: self.favView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 2)])
        self.addConstraints([NSLayoutConstraint(item: self.favView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: frameBounds.height)])
        self.addConstraints([NSLayoutConstraint(item: self.favView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)])
        self.addConstraints([NSLayoutConstraint(item: self.favView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)])
        
        self.addConstraints([NSLayoutConstraint(item: self.picImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: frameBounds.height)])
        self.addConstraints([NSLayoutConstraint(item: self.picImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: frameBounds.height)])
        self.addConstraints([NSLayoutConstraint(item: self.picImageView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0)])
        self.addConstraints([NSLayoutConstraint(item: self.picImageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)])
        
        self.addConstraints([NSLayoutConstraint(item: self.titleLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: frameBounds.width-frameBounds.height-20)])
        self.addConstraints([NSLayoutConstraint(item: self.titleLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: frameBounds.height*0.3)])
        self.addConstraints([NSLayoutConstraint(item: self.titleLabel, attribute: .left, relatedBy: .equal, toItem: self.favView, attribute: .left, multiplier: 1, constant: 10)])
        self.addConstraints([NSLayoutConstraint(item: self.titleLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: -4)])
        
        self.addConstraints([NSLayoutConstraint(item: self.addressLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: frameBounds.width-frameBounds.height-20)])
        self.addConstraints([NSLayoutConstraint(item: self.addressLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: frameBounds.height*0.5)])
        self.addConstraints([NSLayoutConstraint(item: self.addressLabel, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 10)])
        self.addConstraints([NSLayoutConstraint(item: self.addressLabel, attribute: .top, relatedBy: .equal, toItem: self.titleLabel, attribute: .bottom, multiplier: 1, constant: -2)])
        
        self.addConstraints([NSLayoutConstraint(item: self.serviceLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: frameBounds.width-frameBounds.height-20)])
        self.addConstraints([NSLayoutConstraint(item: self.serviceLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: frameBounds.height*0.3)])
        self.addConstraints([NSLayoutConstraint(item: self.serviceLabel, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 10)])
        self.addConstraints([NSLayoutConstraint(item: self.serviceLabel, attribute: .top, relatedBy: .equal, toItem: self.addressLabel, attribute: .bottom, multiplier: 1, constant: -5)])
    }
}
