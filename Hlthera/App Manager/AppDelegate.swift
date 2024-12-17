//
//  AppDelegate.swift
//  Hlthera
//
//  Created by Fluper on 22/10/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import UIKit
import CoreLocation
import IQKeyboardManagerSwift
import FBSDKCoreKit
import GoogleSignIn
//import JBTabBarAnimation
import GoogleMaps
import GooglePlaces
import FirebaseCore
import FirebaseMessaging
//import MobileRTC
import MOLH
import netfox

var dictionaryProfileCreation = [String : Any]()
let gcmMessageIDKey = "gcm.message_id"

//KEY: ph8dB83NXUx3HB47Yv0EZtRxuA5iiCDLzYlB
//Secret: XBBolhhWB5xKFQq1Xo7p3BHLmRsD0C1aFhth
// Obtain your SDK Key and Secret and paste it here.
let sdkKey = "ph8dB83NXUx3HB47Yv0EZtRxuA5iiCDLzYlB"
let sdkSecret = "XBBolhhWB5xKFQq1Xo7p3BHLmRsD0C1aFhth"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var isVideoCallOn = false
    var isVoiceCallOn = false
    var isGroupCall = false
    var callingVariable = String()
    var currentState: UIApplication.State!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        IQKeyboardManager.shared.enable = true
        GIDSignIn.sharedInstance()?.clientID = "612012389926-p61sqdm04all9tjgpo0ip5u8o1o7iee8.apps.googleusercontent.com"
        GMSServices.provideAPIKey("AIzaSyDCzC3Cme-ZcS0CWWu2QfdtgReLsikSdsQ")
        GMSPlacesClient.provideAPIKey("AIzaSyDCzC3Cme-ZcS0CWWu2QfdtgReLsikSdsQ")
        FirebaseApp.configure()
        confrigNotification(application:application)
        LocationManager.sharedInstance.startUpdatingLocation()
        // MARK: - Localization handling
        //configureLocalization()
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        Messaging.messaging().delegate = self
//        setupSDK(sdkKey: sdkKey, sdkSecret: sdkSecret)
#if DEBUG
        NFX.sharedInstance().start()
#endif
        return true
    }
    
    func setupStatusBar() {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.first
            let topPadding = window?.safeAreaInsets.top
            let statusBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: topPadding ?? 0.0))
            statusBar.backgroundColor = UIColor(red: 245, green: 247, blue: 249, transparency: 1)
            UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.addSubview(statusBar)
        }
    }
    
//    func applicationWillTerminate(_ application: UIApplication) {
//        if let authorizationService = MobileRTC.shared().getAuthService() {
//            // Call logoutRTC() to log the user out.
//            authorizationService.logoutRTC()
//            // Notify MobileRTC of appWillTerminate call.
//            MobileRTC.shared().appWillTerminate()
//        }
//    }
    
    // Create a method that handles the initialization and authentication of the SDK
//    func setupSDK(sdkKey: String, sdkSecret: String) {
//        let context = MobileRTCSDKInitContext()
//        context.domain = "zoom.us"
//        context.enableLog = true
//        let sdkInitializedSuccessfully = MobileRTC.shared().initialize(context)
//        if sdkInitializedSuccessfully == true, let authorizationService = MobileRTC.shared().getAuthService() {
//            authorizationService.clientKey = sdkKey
//            authorizationService.clientSecret = sdkSecret
//            // Set the delegate
//            authorizationService.delegate = self
//            authorizationService.sdkAuth()
//        }
//    }
//
    // MARK: UISceneSession Lifecycle
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        return GIDSignIn.sharedInstance()!.handle(url)
        
    }
    
    func moveToWalkthrough() {
        let story = UIStoryboard(name: "Main", bundle:nil)
        guard let vc = story.instantiateViewController(withIdentifier: WalkthroughViewController.getStoryboardID()) as? WalkthroughViewController else { return }
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.setNavigationBarHidden(true, animated: true)
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
        
    }
    
    func moveToSplash() {
        let story = UIStoryboard(name: "Main", bundle:nil)
        guard let vc = story.instantiateViewController(withIdentifier: SplashScreenViewController.getStoryboardID()) as? SplashScreenViewController else { return }
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.setNavigationBarHidden(true, animated: true)
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    func moveToLoginScreen() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(identifier: LoginVC.getStoryboardID()) as! LoginVC
        //        let vc = storyBoard.instantiateViewController(identifier: LoginVc2.getStoryboardID()) as! LoginVc2
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.setNavigationBarHidden(true, animated: true)
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
        
        
    }
    
    func moveToHomeScreen(index:Int = 0) {
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyBoard.instantiateViewController(identifier: JBTabBarController.getStoryboardID()) as! JBTabBarController
        
        vc.selectedIndex = index
        
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.setNavigationBarHidden(true, animated: true)
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    func moveToLocationPermissionsScreen(){
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        
        let vc = storyBoard.instantiateViewController(identifier: LocationPermissionVC.getStoryboardID()) as! LocationPermissionVC
        
        
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.setNavigationBarHidden(true, animated: true)
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    //    func moveToHomeScreen() {
    //           let storyBoard = UIStoryboard(name: "Home", bundle: nil)
    //           let vc = storyBoard.instantiateViewController(identifier: MainTabBarVC.getStoryboardID()) as! MainTabBarVC
    //           let navigationController = UINavigationController(rootViewController: vc)
    //           navigationController.setNavigationBarHidden(true, animated: true)
    //           UIApplication.shared.windows.first?.rootViewController = navigationController
    //           UIApplication.shared.windows.first?.makeKeyAndVisible()
    //       }
    
    func logout() {
        kSharedUserDefaults.setUserLoggedIn(userLoggedIn: false)
        kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: [:])
        kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: "")
        moveToLoginScreen()
    }
    
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
    
    func configureLocalization() {
        MOLHLanguage.setDefaultLanguage("en")
        MOLH.shared.activate(true)
        MOLH.shared.specialKeyWords = ["Cancel","Done"]
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func confrigNotification(application:UIApplication) {
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions){_, _ in
        }
        self.registerForPushNotification(application)
        application.registerForRemoteNotifications()
        UIApplication.shared.registerForRemoteNotifications()
    }
    private func registerForPushNotification(_ application: UIApplication) {
        let current = UNUserNotificationCenter.current()
        current.delegate = self
        current.requestAuthorization(options: [.alert, .badge, .sound]) { (flag, error) in
            if error == nil {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        }
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in return String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        
        UserDefaults.standard.set(token, forKey: "device_token")
        kSharedUserDefaults.setDeviceToken(deviceToken: token)
        
        let dataDict:[String: String] = ["token": token]
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        print(userInfo)
    }
    
    //MARK:- when app is in foreground - this method gets called when a notification arrives
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = kSharedInstance.getDictionary(response.notification.request.content.userInfo)
        print(userInfo)
        let aps = userInfo[("aps")] as? NSDictionary
        let alert = aps?["alert"] as? NSDictionary
        let body = String.getString(alert?["body"])
        completionHandler()
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
        
        
    }
}

//extension AppDelegate: MobileRTCAuthDelegate {
//    // Result of calling sdkAuth(). MobileRTCAuthError_Success represents a successful authorization.
//    func onMobileRTCAuthReturn(_ returnValue: MobileRTCAuthError) {
//        switch returnValue {
//        case .success:
//            print("SDK successfully initialized.")
//            break
//        case .keyOrSecretEmpty:
//            assertionFailure("SDK Key/Secret was not provided. Replace sdkKey and sdkSecret at the top of this file with your SDK Key/Secret.")
//            break
//        case .keyOrSecretWrong, .unknown:
//            assertionFailure("SDK Key/Secret is not valid.")
//            break
//        default:
//            //assertionFailure("SDK Authorization failed with MobileRTCAuthError: \(returnValue).")
//            break
//        }
//    }
//
//    // Result of calling logIn()
//    func onMobileRTCLoginResult(_ resultValue: MobileRTCLoginFailReason) {
//        switch resultValue {
//        case .success:
//            print("Successfully logged in")
//
//            // This alerts the ViewController that log in was successful.
//            NotificationCenter.default.post(name: Notification.Name("userLoggedIn"), object: nil)
//        case .wrongPassword:
//            print("Password incorrect")
//        default:
//            print("Could not log in. Error code: \(resultValue)")
//
//        }
//    }
//
//    // Result of calling logoutRTC(). 0 represents a successful log out attempt.
//    func onMobileRTCLogoutReturn(_ returnValue: Int) {
//        switch returnValue {
//        case 0:
//            print("Successfully logged out")
//        default:
//            print("Could not log out. Error code: \(returnValue)")
//        }
//    }
//
//    @available(iOS 13.0, *)
//    func swichRoot() {
//        //Flip Animation before changing rootView
//        animateView()
//        // switch root view controllers
//        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
//        let nav = storyboard.instantiateViewController(withIdentifier: SplashScreenViewController.getStoryboardID()) as! SplashScreenViewController
//
//        let scene = UIApplication.shared.connectedScenes.first
//        if let sd : SceneDelegate = (scene?.delegate as? SceneDelegate) {
//            sd.window!.rootViewController = nav
//        }
//
//    }
//
//    @available(iOS 13.0, *)
//    func animateView() {
//        var transition = UIView.AnimationOptions.transitionFlipFromRight
//        if !MOLHLanguage.isRTLLanguage() {
//            transition = .transitionFlipFromLeft
//        }
//        animateView(transition: transition)
//    }
//
//    @available(iOS 13.0, *)
//    func animateView(transition: UIView.AnimationOptions) {
//        if let delegate = UIApplication.shared.connectedScenes.first?.delegate {
//            UIView.transition(with: (((delegate as? SceneDelegate)!.window)!), duration: 0.5, options: transition, animations: {}) { (f) in
//            }
//        }
//    }
//}

extension UIViewController {
    func setupStatusBar(red: Int = 245, green: Int = 247, blue: Int = 249) {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.first
            let topPadding = window?.safeAreaInsets.top
            let statusBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: topPadding ?? 0.0))
            statusBar.backgroundColor = UIColor(red: red, green: green, blue: blue, transparency: 1)
            UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.addSubview(statusBar)
        }
    }
}

//MARK: - MOLH
extension AppDelegate: MOLHResetable {
    func reset() {
        let nav = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: SplashScreenViewController.getStoryboardID()) as! SplashScreenViewController
        window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
    }
    
    func relaunchApp() {
        moveToSplash()
    }
}
