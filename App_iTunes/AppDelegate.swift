//
//  AppDelegate.swift
//  App_iTunes
//
//  Created by formador on 19/4/17.
//  Copyright © 2017 formador. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        customUI()
        
        //Notificacion
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateFavoriteBadgeNotification(_:)),
                                               name: Notification.Name("updateFavoriteBadgeNotification"),
                                               object: nil)
        
        let dataProvider = LocalCoreDataService()
        dataProvider.updatefavoriteBadge()
        
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
    
    func customUI(){
        let navBar = UINavigationBar.appearance()
        let tabBar = UITabBar.appearance()
        
        navBar.barTintColor = CONSTANTES.COLORES_BASE.COLOR_GRIS_TAB_NAV_BAR
        navBar.tintColor = CONSTANTES.COLORES_BASE.COLOR_ROJO_GENERAL
        navBar.titleTextAttributes = [NSForegroundColorAttributeName : CONSTANTES.COLORES_BASE.COLOR_ROJO_GENERAL]
        
        tabBar.tintColor = CONSTANTES.COLORES_BASE.COLOR_ROJO_GENERAL
        tabBar.barTintColor = CONSTANTES.COLORES_BASE.COLOR_GRIS_TAB_NAV_BAR
        
    }
    
    //NOTIFICACION
    func updateFavoriteBadgeNotification(_ notification : Notification){
        
        let tabBarVC = self.window?.rootViewController as! UITabBarController
        let favNavVC = tabBarVC.viewControllers?.last as! UINavigationController
        if let total = notification.object as? Int{
            if total != 0{
                favNavVC.tabBarItem.badgeValue = "\(total)"
            }else{
                favNavVC.tabBarItem.badgeValue = nil
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    


}

