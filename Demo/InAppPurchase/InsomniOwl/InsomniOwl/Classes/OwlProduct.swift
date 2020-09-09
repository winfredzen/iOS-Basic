//
//  OwlProduct.swift
//  InsomniOwl
//
//  Created by 王振 on 2020/9/3.
//  Copyright © 2020 Razeware LLC. All rights reserved.
//

import Foundation
import UIKit
import SwiftKeychainWrapper

public struct OwlProducts {
  
  //非消耗型
  static let productIDsNonConsumables: Set<ProductIdentifier> = [
    "com.curefun.test.apppurchase.CarefreeOwl",
    "com.curefun.test.apppurchase.CouchOwl",
    "com.curefun.test.apppurchase.CryingOwl",
    "com.curefun.test.apppurchase.GoodJobOwl",
    "com.curefun.test.apppurchase.GoodNightOwl",
    "com.curefun.test.apppurchase.InLoveOwl",
    "com.curefun.test.apppurchase.LovelyOwl",
    "com.curefun.test.apppurchase.NightOwl"
  ]
  
  //消耗类型
  static let randomProductID = "com.curefun.test.apppurchase.RandomOwls"
  static let productIDsConsumables: Set<ProductIdentifier> = [randomProductID]
  
  //非续期订阅
  static let productIDsNonRenewing: Set<ProductIdentifier> = [
    "com.curefun.test.apppurchase.3MonthsOfRandom",
    "com.curefun.test.apppurchase.6MonthsOfRandom"
  ]
  
  static let randomImages = [
    UIImage(named: "CarefreeOwl"),
    UIImage(named: "GoodJobOwl"),
    UIImage(named: "CouchOwl"),
    UIImage(named: "NightOwl"),
    UIImage(named: "LonelyOwl"),
    UIImage(named: "ShyOwl"),
    UIImage(named: "CryingOwl"),
    UIImage(named: "GoodNightOwl"),
    UIImage(named: "InLoveOwl")
  ]
  
  static let store = IAPHelper.init(productIDs: OwlProducts.productIDsConsumables.union(OwlProducts.productIDsNonConsumables).union(OwlProducts.productIDsNonRenewing))
  
  public static func resourceName(for productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
  }
  
  public static func setRandomProduct(with paidUp: Bool) {
    if paidUp {//支付了
      KeychainWrapper.standard.set(true, forKey: randomProductID)
      store.purchasedProducts.insert(randomProductID)
    } else {//未支付
      KeychainWrapper.standard.set(false, forKey: randomProductID)
      store.purchasedProducts.remove(randomProductID)
    }
  }
  
  public static func daysRemaininOnSubscription() -> Int {
    if let expiryDate = UserSettings.shared.expirationDate {
      return Calendar.current.dateComponents([.day], from: Date(), to: expiryDate).day!
    }
    return 0
  }
  
  public static func getExpiryDateString() -> String {
    let remaining = daysRemaininOnSubscription()
    if remaining > 0, let expiryDate = UserSettings.shared.expirationDate {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "dd/MM/yyyy"
      return "Subscribed! \n Expires: \(dateFormatter.string(from: expiryDate)) (\(remaining) days"
    }
    return "Not Subscribed"
  }
  
  public static func paidUp() -> Bool {
    var paidUp = false
    if OwlProducts.daysRemaininOnSubscription() > 0 {
      paidUp = true
    } else if UserSettings.shared.randomRemaining > 0 {
      paidUp = true
    }
    setRandomProduct(with: paidUp)
    return paidUp
  }
  
  public static func handleMonthlySubscription(months: Int) {
    UserSettings.shared.increaseRandomExpirationDate(by: months)
    setRandomProduct(with: true)
  }
  
  static func handlePurchase(purchaseIdentifier: String) {
    
    //消耗类型
    if productIDsConsumables.contains(purchaseIdentifier) {
      UserSettings.shared.increaseRandomRemaining(by: 5)
    } else if productIDsNonRenewing.contains(purchaseIdentifier), purchaseIdentifier.contains("3Months") {//非续期订阅
      
      handleMonthlySubscription(months: 3)
      
    }  else if productIDsNonRenewing.contains(purchaseIdentifier), purchaseIdentifier.contains("6Months") {//非续期订阅
         
      handleMonthlySubscription(months: 6)
         
    } else if productIDsNonConsumables.contains(purchaseIdentifier) {//非消耗型
      store.purchasedProducts.insert(purchaseIdentifier) //购买产品
      
      KeychainWrapper.standard.set(true, forKey:purchaseIdentifier)
    }
  }
  
  
}
