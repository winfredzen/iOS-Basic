//
//  MultiTargetAPIManager.swift
//  BaseProject
//
//  Created by 王振 on 2019/8/14.
//  Copyright © 2019 curefun. All rights reserved.
//

import Foundation
import Moya
import SVProgressHUD

struct MultiTargetAPIManager {
    
    typealias RequestCompletion = (_ succ: Bool, _ result: [String : Any]?) -> Void
    
    ///网络请求的基本设置,这里可以拿到是具体的哪个网络请求，可以在这里做一些设置
    private static let myEndpointClosure = { (target: MultiTarget) -> Endpoint in
        
        var url = target.baseURL.absoluteString + target.path
        var task = target.task
        
        //拼接签名，遵循协议
        if let additionalTarget = target as? AdditionalParametersProtocol {
            if let additionalParameters = additionalTarget.additionalParameters {
                var components: [(String, String)] = []
                for key in additionalParameters.keys.sorted(by: <) {
                    let value = additionalParameters[key]!
                    components.append((key, value))
                }
                let query = components.map { "\($0)=\($1)" }.joined(separator: "&")
                if query.count > 0 {
                    url += "?" + query
                }
            }
        }

        
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
    
    static let provider = MoyaProvider<MultiTarget>(endpointClosure: myEndpointClosure, plugins: plugins)
    
    static func requset(_ target: MultiTarget, completion: @escaping RequestCompletion){
        
        provider.request(target) { result in
            
            switch result {
            case let .success(response):
                
                do {
                    try response.filterSuccessfulStatusAndRedirectCodes()
                    //let json = try JSON(response.mapJSON())
                    
                    let data = response.data
                    let statusCode = response.statusCode
                    
                    //处理json
                    let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                    if let baseModel = BaseModel.deserialize(from: json) {
                        print(baseModel)
                        print("\(baseModel.status) \(baseModel.message)")
                    }
                    
                    if let json = json {
                        completion(true, json)
                    } else {
                        completion(false, nil)
                    }
                } catch {
                    completion(false, nil)
                }
      
            case let .failure(error):
                
                print("failure: \(error)")
                completion(false, nil)
                
            }
            
            
        }
        
    }
    
}
