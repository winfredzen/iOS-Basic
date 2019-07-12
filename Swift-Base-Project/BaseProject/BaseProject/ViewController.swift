//
//  ViewController.swift
//  BaseProject
//
//  Created by 王振 on 2019/7/9.
//  Copyright © 2019 curefun. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        Alamofire.request("https://jsonplaceholder.typicode.com/todos/1").responseJSON { response in
            print(response)
        }
        
    }


}

