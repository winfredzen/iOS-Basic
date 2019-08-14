//
//  AuthAPI.swift
//  BaseProject
//
//  Created by 王振 on 2019/8/14.
//  Copyright © 2019 curefun. All rights reserved.
//

import Foundation
import Moya
import SwiftHash

enum Auth {
    case login(phone: String, password: String)
}

extension Auth: TargetType {
    var baseURL: URL { return URL.init(string: APIConfig.AuthBaseURL)! }
    
    var path: String {
        switch self {
        case .login:
            return "/user/login"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case let .login(phone, password):
            return .requestParameters(parameters: ["phone" : phone, "password" : password], encoding: JSONEncoding.default)
        }
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var headers: [String : String]? {
        return nil
    }
    

}

extension Auth: AdditionalParametersProtocol {
    //sign签名
    var additionalParameters : [String : String]?  {
        
        let date = Date()
        let timeInterval = UInt64(date.timeIntervalSince1970 * 1000)
        let timestamp = String(format: "%llx", timeInterval)
        let name = "PBL"
        let sign = MD5(name + timestamp + path).lowercased()
        let dic = ["sign" : sign, "t" : String(timeInterval), "device_type" : "1", "token" : ""]
        
        return dic
    }
}
