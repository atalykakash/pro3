//
//  SlotCollectionViewCell.swift
//  Pro3
//
//  Created by Admin on 5/13/17.
//  Copyright © 2017 AAkash. All rights reserved.
//

import UIKit

class SlotCollectionViewCell: UICollectionViewCell {
    
    var timeLabel = UILabel()
    var circleView = UIView()
    var crossLineView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        
        self.backgroundColor = UIColor.clear
        
        self.timeLabel = UILabel(frame: CGRect(x: frame.width*0.2, y: 0, width: frame.width*0.6, height: frame.height))
        self.timeLabel.text = "10:00 - 11:00"
        self.timeLabel.textColor = UIColor.black
        self.timeLabel.textAlignment = .center
        self.addSubview(self.timeLabel)
        
        self.crossLineView = UIView(frame: CGRect(x: frame.width*0.2, y: frame.height*0.522, width: frame.width*0.6, height: 1))
        self.crossLineView.backgroundColor = UIColor.black
        self.addSubview(self.crossLineView)
    }

}
