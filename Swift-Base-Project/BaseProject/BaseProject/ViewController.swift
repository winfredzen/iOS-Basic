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
        
        
//        Alamofire.request("https://httpbin.org/get").responseJSON { response in
//            debugPrint(response)
//
//            if let json = response.result.value {
//                print("JSON: \(json)")
//            }
//        }
        
        let url = "https://free-api.heweather.net/s6/weather/now?location=CN101010100&key=75d498e399c14c6c9cc0c2c674eada5d"
        let parameters: Parameters = ["foo" : "bar"]
        Alamofire.request(url, parameters: parameters, encoding: URLEncoding(destination: .methodDependent)).responseJSON { response in
            
            print("Request: \(String(describing: response.request))")
            
        }

        
        
//        let url = "https://free-api.heweather.net/s6/weather/now?location=CN101010100&key=75d498e399c14c6c9cc0c2c674eada5d"
//
//        Alamofire.request(url).responseJSON { response in
//            print("Request: \(String(describing: response.request))")   // original url request
//            print("Response: \(String(describing: response.response))") // http url response
//            print("Result: \(response.result)")                         // response serialization result
//
//            if let json = response.result.value {
//                print("JSON: \(json)") // serialized json response
//            }
//
//            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//                print("Data: \(utf8Text)") // original server data as UTF8 string
//            }
//        }
        
        //JSON 测试
//        let jsonStr = """
//                    [
//                        {
//                            "name": "hangge",
//                            "age": 100,
//                            "phones": [
//                                {
//                                    "name": "公司",
//                                    "number": "123456"
//                                },
//                                {
//                                    "name": "家庭",
//                                    "number": "001"
//                                }
//                            ]
//                        },
//                        {
//                            "name": "big boss",
//                            "age": 1,
//                            "phones": [
//                                {
//                                    "name": "公司",
//                                    "number": "111111"
//                                }
//                            ]
//                        }
//                    ]
//                    """
        
//        if let jsonData = jsonStr.data(using: .utf8, allowLossyConversion: false) {
//
//            if let userArray = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [[String : AnyObject]] {
//
//                if let phones = userArray[0]["phones"] as? [[String: AnyObject]],
//                    let number = phones[0]["number"] as? String {
//                    // 找到电话号码
//                    print("第一个联系人的第一个电话号码：",number)
//                }
//
//            }
//
//        }
        
//        if let jsonData = jsonStr.data(using: String.Encoding.utf8, allowLossyConversion: false) {
//            if let userArray = try? JSONSerialization.jsonObject(with: jsonData,
//                                                                 options: .allowFragments) as? [[String: AnyObject]],
//                let phones = userArray[0]["phones"] as? [[String: AnyObject]],
//                let number = phones[0]["number"] as? String {
//                // 找到电话号码
//                print("第一个联系人的第一个电话号码：",number)
//            }
//        }
//
//
//        if let jsonData = jsonStr.data(using: String.Encoding.utf8, allowLossyConversion: false) {
//            if let json = try? JSON(data: jsonData) {
//                if let number = json[0]["phones"][0]["number"].string {
//                    print(number)
//                }
//            }
//        }
        
        
//        let userJson = """
//                    [
//                      {
//                        "id": 1,
//                        "name": "Leanne Graham",
//                        "username": "Bret",
//                        "email": "Sincere@april.biz",
//                        "address": {
//                          "street": "Kulas Light",
//                          "suite": "Apt. 556",
//                          "city": "Gwenborough",
//                          "zipcode": "92998-3874",
//                          "geo": {
//                            "lat": "-37.3159",
//                            "lng": "81.1496"
//                          }
//                        },
//                        "phone": "1-770-736-8031 x56442",
//                        "website": "hildegard.org",
//                        "company": {
//                          "name": "Romaguera-Crona",
//                          "catchPhrase": "Multi-layered client-server neural-net",
//                          "bs": "harness real-time e-markets"
//                        }
//                      },
//                      {
//                        "id": 2,
//                        "name": "Ervin Howell",
//                        "username": "Antonette",
//                        "email": "Shanna@melissa.tv",
//                        "address": {
//                          "street": "Victor Plains",
//                          "suite": "Suite 879",
//                          "city": "Wisokyburgh",
//                          "zipcode": "90566-7771",
//                          "geo": {
//                            "lat": "-43.9509",
//                            "lng": "-34.4618"
//                          }
//                        },
//                        "phone": "010-692-6593 x09125",
//                        "website": "anastasia.net",
//                        "company": {
//                          "name": "Deckow-Crist",
//                          "catchPhrase": "Proactive didactic contingency",
//                          "bs": "synergize scalable supply-chains"
//                        }
//                      }
//                    ]
//                    """
//
//
//        if let data = userJson.data(using: .utf8, allowLossyConversion: false) {
//            let users = try! JSON(data:data)
//            print(users)
//            print(users[0])
//            let userModel = UserModel(jsonData: users[0])
//            print(userModel)
//        }
        

//        let users = JSON(userJson)
  
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

