/*
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import StoreKit

class ProductCell: UITableViewCell {

  // MARK: - IBOutlets
  @IBOutlet weak var imgRandom: UIImageView!
  @IBOutlet weak var lblProductName: UILabel!
  @IBOutlet weak var lblPrice: UILabel!
  @IBOutlet weak var btnBuy: UIButton!
  @IBOutlet weak var imgCheckmark: UIImageView!
  
  //hanlder
  var buyButtonHandler: ((_ product: SKProduct) -> ())?
  var product: SKProduct? {
    didSet {
      guard let product = product else { return }
      if btnBuy.allTargets.count == 0 {
        btnBuy.addTarget(self, action: #selector(buyButtonTapped(_:)), for: .touchUpInside)
        
      }
      
      //显示
      lblProductName.text = product.localizedTitle
      
      imgRandom.isHidden = (product.productIdentifier != OwlProducts.randomProductID)
      
      if OwlProducts.store.isPurchased(product.productIdentifier) { //已购买
        
        btnBuy.isHidden = true
        imgCheckmark.isHidden = false
        
      } else if OwlProducts.productIDsNonRenewing.contains(product.productIdentifier) {//非自动续订
        
        btnBuy.isHidden = false
        imgCheckmark.isHidden = true
        
        if OwlProducts.daysRemaininOnSubscription() > 0 {
          btnBuy.setTitle("Renew", for: .normal)
          btnBuy.setImage(UIImage(named: "IconRenew"), for: .normal)
        } else {
          btnBuy.setTitle("Buy", for: .normal)
          btnBuy.setImage(UIImage(named: "IconBuy"), for: .normal)
        }
        
        ProductCell.priceFormatter.locale = product.priceLocale
        lblPrice.text = ProductCell.priceFormatter.string(from: product.price)
        
      } else {//未购买，显示价格
        ProductCell.priceFormatter.locale = product.priceLocale
        lblPrice.text = ProductCell.priceFormatter.string(from: product.price)
        
        btnBuy.isHidden = false
        imgCheckmark.isHidden = true
        
        btnBuy.setTitle("Buy", for: .normal)
        btnBuy.setImage(UIImage(named: "IconBuy"), for: .normal)
        
      }
      
    }
  }
  
  
  // MARK: - Properties
  static let priceFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.formatterBehavior = .behavior10_4
    formatter.numberStyle = .currency
    return formatter
  }()
  
  //购买按钮事件
  @objc func buyButtonTapped(_ sender: AnyObject) {
    guard let product = product, let buyButtonHandler = buyButtonHandler else { return }
    
    buyButtonHandler(product)
  }
  
}
