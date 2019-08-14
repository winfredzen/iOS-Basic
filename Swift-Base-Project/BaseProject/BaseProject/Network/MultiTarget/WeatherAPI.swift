//
//  WeatherAPI.swift
//  BaseProject
//
//  Created by 王振 on 2019/8/14.
//  Copyright © 2019 curefun. All rights reserved.
//

import Foundation
import Moya

enum Weatehr {
    case now(String, String)
}

extension Weatehr: TargetType {
    
    var baseURL: URL { return URL(string: APIConfig.WeatherBaseURL)! }
    
    var path: String {
        switch self {
        case .now:
            return "/no"
        }
    }
        
    var method: Moya.Method {
        switch self {
        case .now:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case let .now(location, key):
            return .requestParameters(parameters: ["location" : location, "key" : key], encoding: URLEncoding.default)
        }
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var headers: [String : String]? {
        return nil
    }
    
}

extension Weatehr: AdditionalParametersProtocol {
    var additionalParameters : [String : String]?  {
        return nil
    }
}
