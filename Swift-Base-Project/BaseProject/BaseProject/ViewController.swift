//
//  ViewController.swift
//  BaseProject
//
//  Created by 王振 on 2019/7/9.
//  Copyright © 2019 curefun. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    
    var person = Person()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        person.addObserver(self, forKeyPath: "age", options: .new, context: nil)
        
        /*
        let url = "https://free-api.heweather.net/s6/weather/now?location=CN101010100&key=75d498e399c14c6c9cc0c2c674eada5d"
        let parameters: Parameters = ["foo" : "bar"]
        Alamofire.request(url, parameters: parameters, encoding: URLEncoding(destination: .methodDependent)).responseJSON { response in
            
            print("Request: \(String(describing: response.request))")
            
        }
        */
        
        APIManager.requset(.login(phone: "18008657309", password: "123456"), completion: { result in
            
        })
  
    }


    @IBAction func kvoTest(_ sender: Any) {
        
        person.age = 100
        
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let change = change {
            let age = change[NSKeyValueChangeKey.newKey]
            print("\(age)")
        }
        
        
    }
}

