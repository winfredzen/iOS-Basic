//
//  UserModel.swift
//  BaseProject
//
//  Created by 王振 on 2019/7/15.
//  Copyright © 2019 curefun. All rights reserved.
//

import Foundation
import SwiftyJSON

struct UserModel {
    
    var id: Int?
    var name: String?
    var username: String?
    var phone: String?
    var website: String?
    var company: CompanyModel?
    
    struct CompanyModel {
        var name: String?
        var catchPhrase: String?
        var bs: String?
        
        init(_ jsonData: JSON) {
            name = jsonData["name"].string
            catchPhrase = jsonData["catchPhrase"].string
            bs = jsonData["bs"].string
        }
    }
    
    init(jsonData: JSON) {
        id = jsonData["id"].int
        name = jsonData["name"].string
        username = jsonData["username"].string
        phone = jsonData["phone"].string
        website = jsonData["website"].string
        company = CompanyModel.init(jsonData["company"])
    }
    
}
