//
//  AppDelegate.swift
//  SamplePeripheral
//
//  Created by Erica Awada on 2018/05/23.
//  Copyright © 2018年 Erica Awada. All rights reserved.
//

import UIKit
import Firebase


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var message: String?
    
    //Firebase初期化
   /* override init(){
        super.init()
        //FirebaseApp.configure()
    }*/
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        
        //tabbar 配列
        var viewControllers: [UIViewController] = []
        
        //1ページ目
        let firstTab = AttendanceViewController()
        firstTab.tabBarItem = UITabBarItem(title: "attend", image: UIImage(named: "dash"), tag: 1)
        viewControllers.append(firstTab)
        
        //2ページ目
//        let secondTab = LogViewController()
//        secondTab.tabBarItem = UITabBarItem(title: "log", image: UIImage(named: "clock"), tag: 2)
//        viewControllers.append(secondTab)
        
        //3ページ目
//        let thirdTab = StatusViewController()
//        thirdTab.tabBarItem = UITabBarItem(title: "status", image: UIImage(named: "pin"), tag: 3)
//        viewControllers.append(thirdTab)
        
        //4ページ目
//        let fourthTab = InfoViewController()
//        fourthTab.tabBarItem = UITabBarItem(title: "list", image: UIImage(named: "desk"), tag: 4)
//        viewControllers.append(fourthTab)
        
        //5ページ目
        let fifthTab = ExitViewController()
        fifthTab.tabBarItem = UITabBarItem(title: "exit", image: UIImage(named: "bord"), tag: 5)
        viewControllers.append(fifthTab)
        
        
        //セット
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers(viewControllers, animated: false)
        
        let colorKey = UIColor(red: 249/255, green: 161/255, blue: 188/255, alpha: 1.0)
        UITabBar.appearance().tintColor = colorKey
        
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        
        

        
        
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

