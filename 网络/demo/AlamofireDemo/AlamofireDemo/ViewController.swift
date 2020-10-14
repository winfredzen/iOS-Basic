//
//  ViewController.swift
//  AlamofireDemo
//
//  Created by 王振 on 2020/10/14.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        AF.request("https://jsonplaceholder.typicode.com/todos/1").response { response in
            debugPrint(response)
        }
        
    }


}

