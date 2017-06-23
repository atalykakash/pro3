//
//  CityView.swift
//  Pro3
//
//  Created by Admin on 5/5/17.
//  Copyright © 2017 AAkash. All rights reserved.
//

import UIKit

protocol SelectCityDelegate: class {
    func returnSelectedCity(city: City)
}

class CityView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: SelectCityDelegate?
    
    var titleLabel = UILabel()
    var lineView = UIView()
    var tableView = UITableView()
    var activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    var citiesArray = [City]()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        
        self.backgroundColor = UIColor.white
        
        self.clipsToBounds = true
        
        self.titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height*0.2))
        self.titleLabel.text = "Выберите город"
        self.titleLabel.textAlignment = .center
        self.titleLabel.textColor = UIColor.white
        self.titleLabel.backgroundColor = UIColor().mainColor()
        self.addSubview(self.titleLabel)
        
        self.tableView = UITableView(frame: CGRect(x: 10, y: self.frame.height*0.2, width: self.frame.size.width-20, height: self.frame.height*0.8))
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CityCell")
        self.tableView.separatorStyle = .none
        self.tableView.rowHeight = self.frame.height*0.8/4
        self.addSubview(self.tableView)
        
        self.activityIndicatorView.center = CGPoint(x: self.frame.width/2, y: self.frame.height*0.6)
        self.activityIndicatorView.tintColor = UIColor().mainColor()
        self.addSubview(self.activityIndicatorView)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.citiesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath)
        cell.textLabel?.text = self.citiesArray[indexPath.row].name
        cell.textLabel?.textAlignment = .center
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.returnSelectedCity(city: self.citiesArray[indexPath.row])
    }
}
