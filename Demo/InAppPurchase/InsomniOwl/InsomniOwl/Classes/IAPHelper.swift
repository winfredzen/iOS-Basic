//
//  IAPHelper.swift
//  InsomniOwl
//
//  Created by 王振 on 2020/9/3.
//  Copyright © 2020 Razeware LLC. All rights reserved.
//

import Foundation
import StoreKit
import SwiftKeychainWrapper

//表示产品的标识符
public typealias ProductIdentifier = String

public typealias ProductsRequestCompletionHandler = (_ succ: Bool, _ products: [SKProduct]?) -> Void


class IAPHelper: NSObject {
  
  //已购买的产品
  public var purchasedProducts = Set<ProductIdentifier>()
  
  private let productIdentifiers: Set<String>
  
  private var productsRequest: SKProductsRequest?
  private var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
  
  init(productIDs: Set<String>) {
    productIdentifiers = productIDs
    
    //已购买的产品
    purchasedProducts = Set(productIDs.filter({
      KeychainWrapper.standard.bool(forKey: $0) ?? false
    }))
    
    super.init()
  }
  
  //是否购买了对应标识符的产品
  public func isPurchased(_ productIdentifier: ProductIdentifier) -> Bool {
    return purchasedProducts.contains(productIdentifier)
  }
  
}


extension IAPHelper {
  
  func requestProducts(completionHandler: @escaping ProductsRequestCompletionHandler) {
    
    //取消当期的请求，创建一个新的请求
    productsRequest?.cancel()
    
    productsRequestCompletionHandler = completionHandler
    
    productsRequest = SKProductsRequest.init(productIdentifiers: productIdentifiers)
    productsRequest?.delegate = self
    productsRequest?.start()
    
  }
  
  //购买
  func buyProduct(product: SKProduct) {
    let payment = SKPayment(product: product)
    SKPaymentQueue.default().add(payment)
  }
  
}


extension IAPHelper: SKProductsRequestDelegate {
  
  //成功
  func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
    
    productsRequestCompletionHandler?(true, response.products)
    productsRequestCompletionHandler = .none //不再适用，置为none
    productsRequest = .none
    
  }
  
  //失败
  func request(_ request: SKRequest, didFailWithError error: Error) {
    
    productsRequestCompletionHandler?(false, nil)
    productsRequestCompletionHandler = .none
    productsRequest = .none
    
  }
  
}
