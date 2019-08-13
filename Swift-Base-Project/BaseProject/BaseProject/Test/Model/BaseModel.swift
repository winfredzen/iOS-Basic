//
//  BaseModel.swift
//  BaseProject
//
//  Created by 王振 on 2019/8/13.
//  Copyright © 2019 curefun. All rights reserved.
//

import Foundation
import HandyJSON

class BaseModel: HandyJSON {
    var message: Int?
    var status: String?
    
    required init() {
        
    }
}

extension BaseModel: CustomStringConvertible {
    var description: String {
        //return "message: " + String(describing: message) + " status: " + (status ?? "")
        return "message: " + String(message ?? 0) + " status: " + (status ?? "")
    }
}
