//
//  AppDelegate.swift
//  RESTLightning
//
//  Created by Matthew Ramsden on 1/3/19.
//  Copyright © 2019 Matthew Ramsden. All rights reserved.
//

import UIKit
import RESTLightningFramework

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        let storyboard = UIStoryboard(name: "NavigationViewController", bundle: Bundle(for: NavigationViewController.self))
//        let vc = storyboard.instantiateViewController(withIdentifier: "NavigationViewController")
//        let navigationController = UINavigationController(rootViewController: vc)
//        self.window?.rootViewController = navigationController
//        self.window?.makeKeyAndVisible()
        
        let storyboard = UIStoryboard(name: "NavigationViewController", bundle: Bundle(for: NavigationViewController.self))
        
        return true
    }

}

