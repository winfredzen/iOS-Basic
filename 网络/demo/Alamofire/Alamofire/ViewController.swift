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
        
//        AF.request("https://httpbin.org/get").response { response in
//
//            print(type(of: response)) //DataResponse<Optional<Data>, AFError>
//
//        }
        
//        AF.request("https://swapi.dev/api/films").responseJSON { (response) in
//            print(type(of: response)) //DataResponse<Any, AFError>
//        }
        
        let url = URL(string: "https://httpbin.org/post")!
        var urlRequest = URLRequest(url: url)
        urlRequest.method = .post

        let parameters = ["foo": "bar"]

        do {
            urlRequest.httpBody = try JSONEncoder().encode(parameters)
        } catch {
            // Handle error.
        }

        urlRequest.headers.add(.contentType("application/json"))

        AF.request(urlRequest)
        
    }


}

