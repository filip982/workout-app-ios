//
//  AppDelegate.swift
//  WorkoutApp
//
//  Created by Filip Miladinovic
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var appCoordinator: AppCoordinator?
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        
        let nc = UINavigationController()
        window?.rootViewController = nc
        
        appCoordinator = AppCoordinator(navigationController: nc)
        appCoordinator?.start()
        
        window?.makeKeyAndVisible()
                
        return true
    }
    
}

