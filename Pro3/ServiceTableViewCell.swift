//
//  ServiceTableViewCell.swift
//  Pro3
//
//  Created by Admin on 5/10/17.
//  Copyright © 2017 AAkash. All rights reserved.
//

import UIKit

class ServiceTableViewCell: UITableViewCell {
    
    var serviceLabel = UILabel()
    var picImageView = UIImageView()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setup()
        
        self.addViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        
        self.picImageView = UIImageView(frame: CGRect(x: 0, y: frame.height/2-9, width: 20, height: 18))
        self.picImageView.image = UIImage(named: "checked")
        self.addSubview(self.picImageView)
        
        self.serviceLabel.translatesAutoresizingMaskIntoConstraints = false
        self.serviceLabel.font = UIFont(name: "RisingSun-Light", size: frame.width*0.05)
        self.addSubview(self.serviceLabel)
    }
    
    func addViewConstraints() {
        
        self.addConstraints([NSLayoutConstraint(item: self.serviceLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)])
        self.addConstraints([NSLayoutConstraint(item: self.serviceLabel, attribute: .left, relatedBy: .equal, toItem: self.picImageView, attribute: .right, multiplier: 1, constant: 10)])
        self.addConstraints([NSLayoutConstraint(item: self.serviceLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: frame.width)])
        self.addConstraints([NSLayoutConstraint(item: self.serviceLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: frame.height)])
    }

}
