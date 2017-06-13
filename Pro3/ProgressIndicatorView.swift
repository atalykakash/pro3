//
//  ProgressIndicatorView.swift
//  Pro3
//
//  Created by Admin on 6/8/17.
//  Copyright © 2017 AAkash. All rights reserved.
//

import UIKit

class ProgressIndicatorView: UIView {
    
    var activityIndicatorView = UIActivityIndicatorView()
    var messageLabel = UILabel()
    
    var text: String? {
        didSet {
            messageLabel.text = text
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        
        self.backgroundColor = UIColor().mainColor()
        
        self.activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        self.activityIndicatorView.center = CGPoint(x: frame.width/2, y: frame.height*0.36)
        self.activityIndicatorView.startAnimating()
        self.addSubview(self.activityIndicatorView)
        
        self.messageLabel = UILabel(frame: CGRect(x: frame.width*0.1, y: frame.height*0.58, width: frame.width*0.8, height: frame.height*0.3))
        self.messageLabel.text = "Загружаю"
        self.messageLabel.textColor = UIColor.white
        self.messageLabel.textAlignment = .center
        self.messageLabel.numberOfLines = 0
        self.addSubview(self.messageLabel)
    }
    
    func startAnimating() {
        
        self.activityIndicatorView.startAnimating()
    }

}
