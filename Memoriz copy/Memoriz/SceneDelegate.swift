//
//  SceneDelegate.swift
//  Memoriz
//
//  Created by Oladele Abimbola on 7/6/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
//    func checkIfOnboarded(){
//        if UserDefaults.standard.bool(forKey: "hasOnboarded"){
//            print("user has been onboarded")
//        }else{
//           print("user has not been onboarded")
//        }
//    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.dataController.load()
        
        window = UIWindow(windowScene: scene)
        var controller: UIViewController!
        
        if UserDefaults.standard.bool(forKey: "hasOnboarded"){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            controller = storyboard.instantiateViewController(withIdentifier: "HomeNC") as! UINavigationController
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            controller = storyboard.instantiateViewController(withIdentifier: "OnboardingViewController")
//            UserDefaults.standard.set(0, forKey: "pix")
//            UserDefaults.standard.synchronize()
        }
        
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
    }
}

