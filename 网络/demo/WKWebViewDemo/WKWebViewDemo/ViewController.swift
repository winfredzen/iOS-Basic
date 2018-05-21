//
//  ViewController.swift
//  WKWebViewDemo
//
//  Created by 王振 on 2018/4/11.
//  Copyright © 2018年 wz. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, UITextFieldDelegate {

    var webView: WKWebView
    
    @IBOutlet weak var barView: UIView!
    
    @IBOutlet weak var urlField: UITextField!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    required init?(coder aDecoder: NSCoder) {

        let conf = WKWebViewConfiguration()
        //conf.userContentController.add(self, name: "OOXX")
        self.webView = WKWebView(frame: CGRect.zero)
        
        super.init(coder: aDecoder)
        
   
        
        webView.navigationDelegate = self
        webView.uiDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        barView.frame = CGRect(x:0, y: 0, width: 300, height: 30)
        
        view.insertSubview(webView, belowSubview: progressView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        
        let height = NSLayoutConstraint(item: webView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1, constant: -44)
        let width = NSLayoutConstraint(item: webView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0)
        view.addConstraints([height, width])
        
        webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
        
        let url = URL(string: "http://www.baidu.com")
        let request = URLRequest(url: url!)
        webView.load(request)
        
        backButton.isEnabled = false
        forwardButton.isEnabled = false
        
        
        
        
    }
    

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        //super.viewWillTransition(to: size, with: coordinator)
        //barView.frame = CGRect(x:0, y: 0, width: size.width, height: 30)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func back(sender: UIBarButtonItem) {
        webView.goBack()
    }
    
    @IBAction func forward(sender: UIBarButtonItem) {
        webView.goForward()
    }
    
    @IBAction func reload(sender: UIBarButtonItem) {
        let request = URLRequest(url:webView.url!)
        webView.load(request)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        
        if (keyPath == "loading") {
            backButton.isEnabled = webView.canGoBack
            forwardButton.isEnabled = webView.canGoForward
        }
        
        if keyPath == "estimatedProgress" {
            progressView.isHidden = webView.estimatedProgress == 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
        
        if keyPath == "title" {
            title = webView.title
        }
        
    }


}

extension ViewController {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        urlField.resignFirstResponder()
        if let text = urlField.text, let url = URL(string:text) {
            webView.load(URLRequest(url: url))
        }
        return false
    }
}

extension ViewController: WKNavigationDelegate {
    // 加载失败调用
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    
    // 加载完成调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.setProgress(0.0, animated: false)
    }
    
    // 是否可以加载某一个资源
    /*
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if (navigationAction.navigationType == WKNavigationType.linkActivated && !(navigationAction.request.url?.host?.lowercased().hasPrefix("www.appcoda.com"))!) {
            UIApplication.shared.openURL(navigationAction.request.url!)
            decisionHandler(WKNavigationActionPolicy.cancel)
        } else {
            decisionHandler(WKNavigationActionPolicy.allow)
        }
    }
     */
    
}

extension ViewController: WKUIDelegate {
    
    // alert 弹窗
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        let ac = UIAlertController(title: webView.title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
            completionHandler()
        }))
        
        self.present(ac, animated: true, completion: nil)
        
    }
    
}

extension ViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        
        
    }
    
}




















