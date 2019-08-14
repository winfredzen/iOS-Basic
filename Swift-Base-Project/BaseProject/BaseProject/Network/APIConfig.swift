//
//  APIKeys.swift
//  BaseProject
//
//  Created by 王振 on 2019/8/8.
//  Copyright © 2019 curefun. All rights reserved.
//

import Foundation
import Moya

protocol AdditionalParametersProtocol {
    var additionalParameters: [String : String]? { get }
}

//extension TargetType {
//    var additionalParameters: [String : String]?
//}

struct APIConfig {
    static let AuthBaseURL = "http://xxxx.xxxx.com"
    static let WeatherBaseURL = "https://free-api.heweather.net/s6/weather"
}


