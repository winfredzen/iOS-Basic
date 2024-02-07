//
//  AppDelegate.swift
//  SimpleCounterApp
//
//  Created by 王振 on 2024/2/7.
//

import UIKit
import SimpleCounterFramework

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window?.rootViewController = CounterViewController()
        
        window?.makeKeyAndVisible()
        
        return true
    }



}

