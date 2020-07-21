//
//  AppDelegate.swift
//  Fruit App
//
//  Created by Jonathan Wesfield on 12/07/2020.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        guard let sharedUserDefaults = UserDefaults(suiteName: "group.fruitapp.appClipMigration"),
              let uuid = sharedUserDefaults.string(forKey: "custom_user_id")
        else {
            // no custom_user_id found from app clip
            return true
        }

        print("uuid is \(uuid)")
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {

        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {

    }


}

