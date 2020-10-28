//
//  SceneDelegate.swift
//  FruitAppClip
//
//  Created by Jonathan Wesfield on 12/07/2020.
//

import UIKit
import AppClip
import CoreLocation

import AppsFlyerLib

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?    
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        
        // Must for AppsFlyer attrib
        AppsFlyerLib.shared().continue(userActivity, restorationHandler: nil)
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let _ = (scene as? UIWindowScene) else { return }
        
        if let userActivity = connectionOptions.userActivities.first {
            self.scene(scene, continue: userActivity)
        }
        return
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Start the SDK
        AppsFlyerLib.shared().start()
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        
    }
    
    func verifyUserLocation(activity: NSUserActivity?) {
        
        // Guard against faulty data.
        guard activity != nil else { return }
        guard activity?.activityType == NSUserActivityTypeBrowsingWeb else { return }
        guard let payload = activity?.appClipActivationPayload else { return }
        guard let incomingURL = activity?.webpageURL else { return }

        // Create a CLRegion object.
        guard let region = location(from: incomingURL) else {
            return
        }
        
        // Verify that the invocation happened at the expected location.
        payload.confirmAcquired(in: region) { (inRegion, error) in
            guard let confirmationError = error as? APActivationPayloadError else {
                if inRegion {
                    print("The location of the NFC tag matches the user's location.")
                } else {
                    print("The location of the NFC tag doesn't match the records")
                }
                return
            }
            
            if confirmationError.code == .doesNotMatch {
                print("The scanned URL wasn't registered for the app clip")
            } else {
                print("The user denied location access, or the source of the app clip’s invocation wasn’t an NFC tag or visual code.")
            }
        }
    }
    
    func location(from url:URL) -> CLRegion? {
          let coordinates = CLLocationCoordinate2D(latitude: 37.334722,
                                                   longitude: 122.008889)
          return CLCircularRegion(center: coordinates,
                                  radius: 100,
                                  identifier: "Apple Park")
    }
   
}

