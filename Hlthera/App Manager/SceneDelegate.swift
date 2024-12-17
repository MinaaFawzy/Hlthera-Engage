//
//  SceneDelegate.swift
//  Hlthera
//
//  Created by Fluper on 22/10/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import MOLH
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    static let sharedInstanse = SceneDelegate()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        configureLocalization()
//        if kSharedUserDefaults.isAppInstalled() {
//            if kSharedUserDefaults.isUserLoggedIn() {
//                kSharedAppDelegate?.moveToLocationPermissionsScreen()
//
//            } else {
//                kSharedAppDelegate?.moveToLoginScreen()
//            }
//        }
//        else {
//            kSharedAppDelegate?.moveToWalkthrough()
//            kSharedUserDefaults.setAppInstalled(installed: false)
//        }
        if kSharedUserDefaults.isAppInstalled() {
            kSharedAppDelegate?.moveToSplash()

        }
        else {
            //kSharedAppDelegate?.moveToWalkthrough()
            kSharedUserDefaults.setAppInstalled(installed: true)
        }


    }
    
    func configureLocalization() {
        MOLHLanguage.setDefaultLanguage("en")
        MOLH.shared.activate(true)
        MOLH.shared.specialKeyWords = ["Cancel","Done"]
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }

        ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url,
            sourceApplication: nil,
            annotation: [UIApplication.OpenURLOptionsKey.annotation]
        )
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

extension SceneDelegate{

    //MARK:- Root View Controller
//    func moveToLoginScreen() {
//        guard  let vc = UIStoryboard.init(name: Storyboards.kMain, bundle: nil).instantiateViewController(withIdentifier: Identifiers.kLoginVc) as? LoginVC else {return}
//        let navigationController = UINavigationController(rootViewController: vc)
//        navigationController.navigationBar.isHidden = true
//        UIApplication.shared.windows.first?.rootViewController = navigationController
//        UIApplication.shared.windows.first?.makeKeyAndVisible()
//        window?.makeKeyAndVisible()
//    }
//
//    func moveToHomeScreen() {
//        let vc = UIStoryboard.init(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: "JBTabBarController")
//        let navigationController = UINavigationController(rootViewController: vc)
//        navigationController.navigationBar.isHidden = true
//        UIApplication.shared.windows.first?.rootViewController = navigationController
//        UIApplication.shared.windows.first?.makeKeyAndVisible()
//        window?.makeKeyAndVisible()
//    }
}

//extension SceneDelegate {
//
//    func reset() {
//        resetApp()
//    }
//
//    func resetApp() {
//        guard let window = window else { return }
//        let vc = UIStoryboard.init(name: "Home", bundle: nil).instantiateViewController(withIdentifier: JBTabBarController.getStoryboardID()) as! JBTabBarController
//        vc.selectedIndex = 0
//        let navigationController = UINavigationController(rootViewController: vc)
//        navigationController.setNavigationBarHidden(true, animated: true)
//        window.rootViewController = vc
//    }
//
//    func relaunchApp() {
////        let vc = UIStoryboard.init(name: "Home", bundle: nil).instantiateViewController(withIdentifier: JBTabBarController.getStoryboardID()) as! JBTabBarController
////        vc.selectedIndex = 0
////        window?.rootViewController = UINavigationController(rootViewController: vc)
//        resetApp()
//    }
//
//}
