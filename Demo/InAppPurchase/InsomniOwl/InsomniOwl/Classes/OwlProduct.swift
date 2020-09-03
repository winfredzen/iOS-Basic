//
//  OwlProduct.swift
//  InsomniOwl
//
//  Created by 王振 on 2020/9/3.
//  Copyright © 2020 Razeware LLC. All rights reserved.
//

import Foundation
import UIKit

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
  
}
