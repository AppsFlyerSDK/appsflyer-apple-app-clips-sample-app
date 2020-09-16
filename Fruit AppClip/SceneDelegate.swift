//
//  SceneDelegate.swift
//  FruitAppClip
//
//  Created by Jonathan Wesfield on 12/07/2020.
//

import UIKit
import AppClip
import CoreLocation

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        
        // Get URL components from the incoming user activity
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let incomingURL = userActivity.webpageURL,
              let components = NSURLComponents(url: incomingURL,
              resolvingAgainstBaseURL: true)
        else {
            return
        }
              
        // log url
        print("AppClip invocation url is : \(incomingURL)")
        
        // verify user location
        self.verifyUserLocation(activity: userActivity)
 
        // Direct to the linked content in your app clip.
        if let fruitName = components.queryItems?.first(where: { $0.name == "fruit_name" })?.value {
          walkToViewWithParams(fruitName: fruitName)
        }
        
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        // Get URL components from the incoming user activity.
        guard let userActivity = connectionOptions.userActivities.first,
            userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let incomingURL = userActivity.webpageURL,
            let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: true)
        else {
            return
        }
                
        // log url
        print("AppClip invocation url is : \(incomingURL)")
        
        // verify user location
        self.verifyUserLocation(activity: userActivity)
 
        // Direct to the linked content in your app clip.
        if let fruitName = components.queryItems?.first(where: { $0.name == "fruit_name" })?.value {
          walkToViewWithParams(fruitName: fruitName)
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {

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
    
    
    // redirect user to desired UIViewController
    func walkToViewWithParams(fruitName: String) {
        
        // **** Important ****
        // The fruits pages are not still not implemented.
        // This function is currently here for reference only.
        
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

