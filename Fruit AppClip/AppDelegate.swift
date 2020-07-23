//
//  AppDelegate.swift
//  FruitAppClip
//
//  Created by Jonathan Wesfield on 12/07/2020.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      
        guard let sharedUserDefaults = UserDefaults(suiteName: "group.fruitapp.appClipMigration") else {
            return true
        }
        
        if sharedUserDefaults.string(forKey: "custom_user_id") == nil {
            sharedUserDefaults.set(UUID().uuidString, forKey: "custom_user_id")
        }
        
        self.setNotification()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {

        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {

    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
       
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
       
    }
    
    func setNotification(){
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings(completionHandler: { settings in
            if settings.authorizationStatus == .ephemeral {
                
                let content = UNMutableNotificationContent()
                content.title = "Hello from the fruitapp"
                content.body = "Check out oour amazing fruit"
                content.categoryIdentifier = "alarm"
                content.userInfo = ["customData": "myData"]
                content.sound = UNNotificationSound.default
            
                // Configure the recurring date.
                var dateComponents = DateComponents()
                dateComponents.calendar = Calendar.current

                dateComponents.hour = 10    // 10:00 hours
                dateComponents.minute = 20  // 20 min
                   
                // Create the trigger as a repeating event.
                let trigger = UNCalendarNotificationTrigger(
                         dateMatching: dateComponents, repeats: true)
                
                
                // Create the request
                let uuidString = UUID().uuidString
                let request = UNNotificationRequest(identifier: uuidString,
                            content: content, trigger: trigger)

                // Schedule the request with the system.
                let notificationCenter = UNUserNotificationCenter.current()
                notificationCenter.add(request) { (error) in
                   if error != nil {
                      // Handle any errors.
                   }
                }
                
                   return
               }
        })
    }


}

