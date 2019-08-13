//
//  APIManager.swift
//  BaseProject
//
//  Created by 王振 on 2019/8/8.
//  Copyright © 2019 curefun. All rights reserved.
//

import Foundation
import Moya
import Alamofire
import SVProgressHUD

struct APIManager {
    
    typealias successCallback = (String) -> Void
    typealias failedCallback = (String) -> Void
    
    var isNetworkConnect: Bool {
        get {
            let network = NetworkReachabilityManager()
            return network?.isReachable ?? true
        }
    }
    
    
    ///网络请求的基本设置,这里可以拿到是具体的哪个网络请求，可以在这里做一些设置
    private static let myEndpointClosure = { (target: API) -> Endpoint in
        
        var url = target.baseURL.absoluteString + target.path
        var task = target.task
        
        //拼接签名
        let additionalParameters = target.additionalParameters
        var components: [(String, String)] = []
        for key in additionalParameters.keys.sorted(by: <) {
            let value = additionalParameters[key]!
            components.append((key, value))
        }
        let query = components.map { "\($0)=\($1)" }.joined(separator: "&")
        url += "?" + query
        
        
        let defaultEncoding = URLEncoding.default
        
        var endpoint = Endpoint(
            url: url,
            sampleResponseClosure: { .networkResponse(200, target.sampleData) },
            method: target.method,
            task: task,
            httpHeaderFields: target.headers
        )
        return endpoint;
    }
    
    //插件
    //网络活动插件
    private static let networkActivityPlugin: NetworkActivityPlugin = NetworkActivityPlugin {
        (changeType, target) in
        switch changeType {
        case .began:
            SVProgressHUD.show()
        case .ended:
            SVProgressHUD.dismiss()
        }
    }
    //日志插件
    private static let networkLoggerPlugin: NetworkLoggerPlugin = NetworkLoggerPlugin(verbose: true)
    private static let plugins: [PluginType] = [networkActivityPlugin, networkLoggerPlugin]
    
    static let provider = MoyaProvider<API>(endpointClosure: myEndpointClosure, plugins: plugins)
    
    static func requset(_ target: API, completion: @escaping Completion){
        
        provider.request(target) { result in
            
            switch result {
            case let .success(response):
                
                let data = response.data
                let statusCode = response.statusCode
                
                //处理json
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                if let baseModel = BaseModel.deserialize(from: json) {
                    print(baseModel)
                    print("\(baseModel.status) \(baseModel.message)")
                }
                
            case let .failure(error):
                
                print("\(error)")
                
            }
            
            
        }
        
    }
    
}
