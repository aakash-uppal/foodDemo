//
//  AppDelegate.swift
//  FoodAppDemo
//
//  Created by Aakash Uppal on 16/05/21.
//  Copyright © 2021 Aakash Uppal. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        checkFavouriteData()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    private func checkFavouriteData() {
        guard let user_Data = Constant.userDefault.value(forKey: "favouriteMeals") as? Data else {
            return
        }
        do {
            let obj = try JSONDecoder().decode([Meals].self, from: user_Data)
            Constant.favouriteMeals = obj
        }
        catch let jsonError {
            print("Could Not Decode data From User Default\(jsonError)")
        }
    }
}

