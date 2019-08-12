//
//  Person.swift
//  BaseProject
//
//  Created by 王振 on 2019/7/24.
//  Copyright © 2019 curefun. All rights reserved.
//

import UIKit

@objcMembers class Person: NSObject {
    
    dynamic var age = 18
    
    var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        return refreshControl
    }()

    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
    }
    
    var loginButton: UIButton {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("login", for: .normal)
        button.setTitleColor(.orange, for: .normal)
        button.addTarget(self, action: #selector(login), for: .touchUpInside)
        return button
    }
    
    
    @objc func login() {
    }
    
}
