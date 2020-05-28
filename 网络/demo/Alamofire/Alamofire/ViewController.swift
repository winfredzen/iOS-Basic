//
//  ViewController.swift
//  Alamofire
//
//  Created by 王振 on 2020/5/28.
//  Copyright © 2020 curefun. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        AF.request("https://httpbin.org/get").response { response in
            
            print(type(of: response)) //DataResponse<Optional<Data>, AFError>
            
            print("\n")
            
            debugPrint(response)
        }
        
    }


}

