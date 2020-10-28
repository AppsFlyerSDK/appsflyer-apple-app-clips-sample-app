# A vanilla version without *AppsFlyer* SDK integration

# Apple App Clips Sample App

<img src="https://user-images.githubusercontent.com/61788924/88316733-f027a900-cd20-11ea-86d2-3c66cd8c9615.png">

## Table of content
- [Intro](#intro) 
- [Why App Clips?](#whyappclips)
- [Responding to Invocations](#invocations)
- [Share Data Between the App Clip and the App](#data-share)
- [Location verification](#location-verification)
- [8-hour notifications](#notifications)
- [Downloading the Full App](#download-full-app)

## <a id="intro"> 🔷 Intro

  With the release of `iOS14` we view [App Clips](https://developer.apple.com/documentation/app_clips) as an innovative step by Apple. 
  At AppsFlyer we see App Clips as the future and evolutions of apps, especially for apps that you do not use on a daily basis. 
  We've put together this sample app together with a [**comprehensive guide**](https://www.appsflyer.com/resources/others/apple-app-clips/) to assist you in developing your first App Clip and implement key features.

## <a id="whyappclips"> Why App Clips? Why now?

  Let’s imagine for a moment that you walk into a coffee shop and notice that there is a long line. Next to the cash register you see a sign inviting you to skip the line and purchase your coffee via the coffee shop’s app. 

Any first thoughts? 

Let me tell you, mine would be, “No way am I going to install an app that will take up precious real-estate on my device.” It would then lead me to question what kind of data they will collect about my life and then I will probably be spammed. No thanks. And all this just to skip the line...

**Skip the line without giving up on privacy**

Apple App Clips are about to change the way you think, and; moreover, they will probably change the way that we interact with our environment using our mobile devices. App Clips enable you to do *‘here-and-now’* activities using your device almost instantly without sacrificing privacy or sharing your geo location.

In the coffee shop example above, the QR code will invoke an App Clip where you are given the opportunity to identify using [Apple Sign-in](https://developer.apple.com/sign-in-with-apple/) and purchase using [Apple Pay](https://developer.apple.com/apple-pay/), allowing you to complete your purchase within seconds, effectively skipping the line. 

App Clips require app developers to understand a few new concepts and develop the App Clip alongside their app, which may require some refactoring.

**We hope you'll find this sample app useful.** 

**Any comments are appreciated and of course stars ⭐️**


## <a id="invocations"> 🔗 Responding to Invocations
  ```swift
     func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        
        // Get URL components from the incoming user activity
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let incomingURL = userActivity.webpageURL,
              let components = NSURLComponents(url: incomingURL,
              resolvingAgainstBaseURL: true)
        else {
            return
        }
              
        // Direct to the linked content in your app clip.
        if let fruitName = components.queryItems?.first(where: { $0.name == "fruit_name" })?.value {
          walkToViewWithParams(fruitName: fruitName)
        }
    }
  ```

## <a id="data-share"> 🔀 Share Data Between the App Clip and the App

### App clip

The following code uses the configured app group to create the shared UserDefaults instance and store a custom_user_id on first launch:

```swift
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
                 
        guard let sharedUserDefaults = UserDefaults(suiteName: "group.fruitapp.appClipMigration") else {
            return true
        }
        
        if sharedUserDefaults.string(forKey: "custom_user_id") == nil {
            sharedUserDefaults.set(UUID().uuidString, forKey: "custom_user_id")
        }
        
        return true
    }
```

### Full app

When users install the full app, it can access the shared user defaults. For example, to access the custom_user_id stored in the previous code:

```swift
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
```

## <a id="location-verification"> 📌 Location verification

  If you create an app clip that users invoke at a physical location, you may need to [confirm](https://developer.apple.com/documentation/app_clips/responding_to_invocations) the user’s location before allowing them to perform a task.

  ```swift
      func verifyUserLocation(activity: NSUserActivity?) {
        
        // Guard against faulty data.
        guard activity != nil else { return }
        guard activity!.activityType == NSUserActivityTypeBrowsingWeb else { return }
        guard let payload = activity!.appClipActivationPayload else { return }
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
  ```

## <a id="notifications"> ⏰ 8-hour notifications

  If notifications are important for your app clip’s functionality, enable it to schedule or receive notifications for up to 8 hours after each launch.

```swift
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
```

## <a id="download-full-app"> ⬇️ Downloading the Full App

  Use [SKOverlay](https://developer.apple.com/documentation/storekit/skoverlay) to recommend your full app to users and enable them to install it from within your app clip.

  ```swift
      @IBAction func downloadFullVersionPressed(_ sender: Any) {
        
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        let config = SKOverlay.AppClipConfiguration(position: .bottom)
        let overlay = SKOverlay(configuration: config)
        overlay.delegate = self
        overlay.present(in: scene)
        
    }
  ```


