//
//  IAPHelper.swift
//  InsomniOwl
//
//  Created by 王振 on 2020/9/3.
//  Copyright © 2020 Razeware LLC. All rights reserved.
//

import Foundation
import StoreKit

//表示产品的标识符
public typealias ProductIdentifier = String

public typealias ProductsRequestCompletionHandler = (_ succ: Bool, _ products: [SKProduct]?) -> Void


class IAPHelper: NSObject {
  
  private let productIdentifiers: Set<String>
  
  private var productsRequest: SKProductsRequest?
  private var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
  
  init(productIDs: Set<String>) {
    productIdentifiers = productIDs
    super.init()
  }
  
  
  
}


extension IAPHelper {
  
  func requestProducts(completionHandler: @escaping ProductsRequestCompletionHandler) {
    
    //取消当期的请求，创建一个新的请求
    productsRequest?.cancel()
    
    
    
  }
  
}
