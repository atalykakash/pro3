//
//  OrderCollectionViewCell.swift
//  Pro3
//
//  Created by Admin on 5/23/17.
//  Copyright © 2017 AAkash. All rights reserved.
//

import UIKit

class OrderCollectionViewCell: UICollectionViewCell {
    
    var titleLabel = UILabel()
    var serviceLabel = UILabel()
    var dateLabel = UILabel()
    var priceLabel = UILabel()
    var activityLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        
        self.backgroundColor = UIColor().lightGrayBackgroundColor()
        
        self.titleLabel = UILabel(frame: CGRect(x: frame.width*0.05, y: frame.height*0.1, width: frame.width*0.9, height: frame.height*0.2))
        self.titleLabel.text = "EKA Car Wash"
        self.titleLabel.font = UIFont().risingSunBold()
        self.addSubview(self.titleLabel)
        
        self.activityLabel = UILabel(frame: CGRect(x: frame.width*0.7, y: frame.height*0.37, width: frame.width*0.25, height: frame.height*0.2))
        self.activityLabel.text = "Active"
        self.activityLabel.font = UIFont().risingSunRegular()
        self.addSubview(self.activityLabel)
        
        self.serviceLabel = UILabel(frame: CGRect(x: frame.width*0.05, y: frame.height*0.37, width: frame.width*0.6, height: frame.height*0.2))
        self.serviceLabel.text = "Malolitraj: Salon + Kuzov"
        self.serviceLabel.font = UIFont().risingSunRegular()
        self.addSubview(self.serviceLabel)
        
        self.dateLabel = UILabel(frame: CGRect(x: frame.width*0.05, y: frame.height*0.63, width: frame.width*0.6, height: frame.height*0.2))
        self.dateLabel.text = "23:05:2017"
        self.dateLabel.font = UIFont().risingSun()
        self.addSubview(self.dateLabel)
        
        self.priceLabel = UILabel(frame: CGRect(x: frame.width*0.7, y: frame.height*0.63, width: frame.width*0.25, height: frame.height*0.2))
        self.priceLabel.text = "2000"
        self.priceLabel.textAlignment = .right
        self.priceLabel.font = UIFont().risingSun()
        self.addSubview(self.priceLabel)
    
    }
}
