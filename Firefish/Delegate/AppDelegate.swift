//
//  AppDelegate.swift
//  Firefish
//
//  Created by Brigitte on 2/10/18.
//  Copyright © 2018 Nativapps. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = UIColor(red: 68.0/255.0, green: 150.0/255.0, blue: 164.0/255.0, alpha: 1.0)
        }
        UIApplication.shared.statusBarStyle = .lightContent
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50.0))
        imageView.contentMode = .scaleAspectFill
        
        // 4
        let image = UIImage(named: "Banner")
        imageView.image = image
        UINavigationBar.appearance().addSubview(imageView)
        
        let userData = UserDefaultsData()
        if userData.getUserToken() != ""{
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let centerViewController = mainStoryboard.instantiateViewController(withIdentifier: "MainNav") as! UINavigationController
            window!.rootViewController = centerViewController
        }else{
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let centerViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            window!.rootViewController = centerViewController
        }
        // Override point for customization after application launch.
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

