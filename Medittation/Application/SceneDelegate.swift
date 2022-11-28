//
//  SceneDelegate.swift
//  Medittation
//
//  Created by Алина Матюха on 24.11.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    let userDefault = UserDefaults.standard

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        guard let _ = (scene as? UIWindowScene) else { return }
        
        let wasLaunched = userDefault.bool(forKey: "wasLaunched")
        let wasLogin = userDefault.string(forKey: "token")
        if wasLaunched != true {
            let onBoarding = UIStoryboard(name: "OnBoarding", bundle: nil)
            let vc: UIViewController
            vc = onBoarding.instantiateInitialViewController()!
            self.window?.rootViewController = vc
        }
        if wasLogin != nil {
            let onBoarding = UIStoryboard(name: "MainScreen", bundle: nil)
            let vc: UIViewController
            vc = onBoarding.instantiateInitialViewController()!
            self.window?.rootViewController = vc
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


}

