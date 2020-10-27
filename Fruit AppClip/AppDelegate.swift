//
//  AppDelegate.swift
//  FruitAppClip
//
//  Created by Jonathan Wesfield on 12/07/2020.
//

import UIKit

import AppsFlyerLib

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      
        // Get AppsFlyer preferences from .plist file
        guard let propertiesPath = Bundle.main.path(forResource: "afdevkey_donotpush", ofType: "plist"),
            let properties = NSDictionary(contentsOfFile: propertiesPath) as? [String:String] else {
                fatalError("Cannot find `afdevkey_donotpush`")
        }
        guard let appsFlyerDevKey = properties["appsFlyerDevKey"],
                   let appleAppID = properties["appleAppID"] else {
            fatalError("Cannot find `appsFlyerDevKey` or `appleAppID` key")
        }
        // 2 - Replace 'appsFlyerDevKey', `appleAppID` with your DevKey, Apple App ID
        AppsFlyerLib.shared().appsFlyerDevKey = appsFlyerDevKey
        AppsFlyerLib.shared().appleAppID = appleAppID
        // Set delegate for OneLink Callbacks
        AppsFlyerLib.shared().delegate = self
        //  Set isDebug to true to see AppsFlyer debug logs
        AppsFlyerLib.shared().isDebug = true
        
        guard let sharedUserDefaults = UserDefaults(suiteName: "group.fruitapp.appClipToFullApp") else {
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
                content.body = "Check out our amazing fruit"
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
    
    // redirect user to desired UIViewController
    func walkToViewWithParams(fruitName: String) {
                
        let destinationViewController = FruitViewController()
        
        switch fruitName {
        case "apples":
            destinationViewController.fruit = .apple
        case "peaches":
            destinationViewController.fruit = .peaches
        case "bananas":
            destinationViewController.fruit = .banana
        default:
            fatalError()
        }
        
        UIApplication.shared.windows.first?.rootViewController?.present(destinationViewController, animated: true, completion: nil)
    }   

}

extension AppDelegate: AppsFlyerLibDelegate {
     
    // Handle Organic/Non-organic installation
    func onConversionDataSuccess(_ data: [AnyHashable: Any]) {
        
        print("onConversionDataSuccess data:")
        for (key, value) in data {
            print(key, ":", value)
        }
    }
    
    func onConversionDataFail(_ error: Error) {
        print("\(error)")
    }
     
    // Handle Deeplink
    func onAppOpenAttribution(_ attributionData: [AnyHashable: Any]) {
        //Handle Deep Link Data
        print("onAppOpenAttribution data:")
        for (key, value) in attributionData {
            print(key, ":",value)
        }
                               
        if let thisFruitName = attributionData["fruit_name"] as? String {
            walkToViewWithParams(fruitName: thisFruitName)
        } else {
            print("Could find fruit_name in OneLink data")
        }
    }
    
    func onAppOpenAttributionFailure(_ error: Error) {
        print("\(error)")
    }
}

