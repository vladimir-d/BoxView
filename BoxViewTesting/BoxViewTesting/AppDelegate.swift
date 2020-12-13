//
//  AppDelegate.swift
//  BoxViewTesting
//
//  Created by Vlad on 03.12.2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let isUnitTesting = ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
        guard !isUnitTesting else {
            print("App language: \(String(describing: Locale.current.languageCode))")
          return true
        }
        self.window = UIWindow()
        self.window?.backgroundColor = .red
        self.window?.makeKeyAndVisible()
        let vc = ViewController1()
        vc.runTestsOnLoad = true
        vc.view.backgroundColor = .yellow
        self.window?.rootViewController = vc
        
        return true
    }
}

