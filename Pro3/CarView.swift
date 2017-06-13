//
//  CarView.swift
//  Pro3
//
//  Created by Admin on 5/5/17.
//  Copyright © 2017 AAkash. All rights reserved.
//

import UIKit

protocol SelectCarDelegate: class {
    func returnSelectedCar(car: Car)
}

class CarView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: SelectCarDelegate?
    
    var tableView = UITableView()
    var activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    var carsArray = [Car]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        
        self.backgroundColor = UIColor.white
        
        self.activityIndicatorView.center = CGPoint(x: self.frame.origin.x/2, y: self.frame.origin.y/2)
        self.addSubview(self.activityIndicatorView)
        
        self.tableView = UITableView(frame: CGRect(x: 10, y: self.frame.size.height*0.1, width: self.frame.size.width-20, height: self.frame.size.height*0.9-10))
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CarCell")
        self.addSubview(self.tableView)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.carsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CarCell", for: indexPath)
        
        cell.textLabel?.text = self.carsArray[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.returnSelectedCar(car: self.carsArray[indexPath.row])
    }
}
