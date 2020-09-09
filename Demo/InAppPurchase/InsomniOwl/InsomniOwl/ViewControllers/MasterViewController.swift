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

class MasterViewController: UIViewController {

  // MARK: - IBOutlets
  @IBOutlet weak var tableView: UITableView!

  // MARK: - Properties
  let showDetailSegueIdentifier = "showDetail"
  let randomImageSegueIdentifier = "randomImage"
  let refreshControl = UIRefreshControl()
  var products = [SKProduct]()

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    refreshControl.addTarget(self, action: #selector(requestAllProducts), for: .valueChanged)
    tableView.addSubview(refreshControl)
    refreshControl.beginRefreshing()
    requestAllProducts()


    setupNavigationBarButtons()
    
    //添加通知观察
    NotificationCenter.default.addObserver(self, selector: #selector(handlePurchaseNotification(_:)), name: Notification.Name.purchaseNotification, object: nil)

    
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    navigationItem.leftBarButtonItem?.title = "Sign Out"
    tableView.reloadData()
  }
  
  func setupNavigationBarButtons() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Restore", style: .plain, target: self, action: #selector(restoreTapped))
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: UIBarButtonItem.Style.plain, target: self, action: #selector(signOutTapped))
  }

  @objc func signOutTapped() {
    _ = navigationController?.popViewController(animated: true)
  }

  
  //请求所有的数据
  @objc func requestAllProducts() {
    
    OwlProducts.store.requestProducts { [weak self] success, products in
      
      if success, let products = products {
        self?.products = products
        self?.tableView.reloadData()
      }
      self?.refreshControl.endRefreshing()
      
    }
    
  }
  
  //处理购买通知
  @objc func handlePurchaseNotification(_ notification: NSNotification) {
    
    DispatchQueue.main.async {
      
      self.tableView.reloadData()
      
    }
    
  }

  //恢复购买事件
  @objc func restoreTapped(_ sender: AnyObject) {
    // Restore Consumables from Apple
    
    OwlProducts.store.restorePurchases()
    
  }

  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == showDetailSegueIdentifier {
      

      guard let viewController = segue.destination as? DetailViewController,
        let product = sender as? SKProduct else { return }
      
      if OwlProducts.store.isPurchased(product.productIdentifier) {
        let name = OwlProducts.resourceName(for: product.productIdentifier) ?? "default"
        viewController.productName = product.localizedTitle
        viewController.image = UIImage(named: name)
      } else {
        viewController.productName = "No owl"
        viewController.image = nil
      }
      
    }
  }
}

// MARK: - UITableViewDataSource
extension MasterViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return products.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cellProduct", for: indexPath) as! ProductCell

    let product = products[(indexPath as NSIndexPath).row]
    
    // supress warning
    print(product)
    
//    cell.lblProductName.text = product.localizedTitle
//    cell.lblPrice.text = ProductCell.priceFormatter.string(from: product.price)
    
    cell.product = product
    
    //购买事件
    cell.buyButtonHandler = { product  in
      OwlProducts.store.buyProduct(product: product)
      
    }


    return cell
  }
  
  
  
  
}

// MARK: - UITableViewDelegate
extension MasterViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let product = products[indexPath.row]
    performSegue(withIdentifier: showDetailSegueIdentifier, sender: product)
  }
  
  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    
    let product = products[indexPath.row]
    
    performSegue(withIdentifier: showDetailSegueIdentifier, sender: product)
    
  }
}
