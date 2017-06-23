//
//  AppDelegate.swift
//  Pro3
//
//  Created by Admin on 5/1/17.
//  Copyright © 2017 AAkash. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let tabBarController = UITabBarController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        return true
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        self.window?.makeKeyAndVisible()
        
        var tabItems = [UINavigationController]()
        
        let allPlaceViewController = AllPlaceViewController()
        let allPlaceNavigationController = UINavigationController(rootViewController: allPlaceViewController)
        allPlaceNavigationController.navigationBar.isTranslucent = false
        allPlaceNavigationController.tabBarItem.title = "Автомойки"
        allPlaceNavigationController.tabBarItem.image = UIImage(named: "home")?.withRenderingMode(.alwaysOriginal)
        allPlaceNavigationController.tabBarItem.selectedImage = UIImage(named: "homeSelected")?.withRenderingMode(.alwaysOriginal)
        tabItems.append(allPlaceNavigationController)
        
        let favoritePlaceViewController = FavoritePlaceViewController()
        let favoritePlaceNavigationController = UINavigationController(rootViewController: favoritePlaceViewController)
        favoritePlaceNavigationController.title = "Избранные"
        favoritePlaceNavigationController.tabBarItem.image = UIImage(named: "fav")?.withRenderingMode(.alwaysOriginal)
        favoritePlaceNavigationController.tabBarItem.selectedImage = UIImage(named: "favSelected")?.withRenderingMode(.alwaysOriginal)
        tabItems.append(favoritePlaceNavigationController)
        
        let orderViewController = OrderViewController()
        let orderNavigationController = UINavigationController(rootViewController: orderViewController)
        orderNavigationController.title = "Заказы"
        orderNavigationController.navigationBar.isTranslucent = false
        orderNavigationController.tabBarItem.image = UIImage(named: "order")?.withRenderingMode(.alwaysOriginal)
        tabItems.append(orderNavigationController)
        
        let accountViewController = AccountViewController()
        let accountNavigationController = UINavigationController(rootViewController: accountViewController)
        accountNavigationController.title = "Аккаунт"
        accountNavigationController.navigationBar.isTranslucent = false
        accountNavigationController.tabBarItem.image = UIImage(named: "user")?.withRenderingMode(.alwaysOriginal)
        tabItems.append(accountNavigationController)
    
        tabBarController.viewControllers = tabItems
        tabBarController.tabBar.isTranslucent = false
        
        tabBarController.selectedIndex = 0
        tabBarController.tabBar.layer.borderColor = UIColor.clear.cgColor
        tabBarController.tabBar.clipsToBounds = true
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.black], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : UIColor().mainColor()], for: .selected)
        
        UINavigationBar.appearance().tintColor = UIColor.blue
        
        self.window?.rootViewController = tabBarController
        
        if let phoneNumber = UserDefaults.standard.value(forKey: "phoneNumber") as? String, let password = UserDefaults.standard.value(forKey: "password") as? String {
            ApiHelper.loginUser(phoneNumber: phoneNumber, password: password) {}
        } else {
            self.window?.rootViewController?.present(LoginViewController(), animated: false, completion: nil)
        }
    
        sleep(1)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

