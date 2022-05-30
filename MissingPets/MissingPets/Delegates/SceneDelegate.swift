//
//  SceneDelegate.swift
//  MissingPets
//
//  Created by Artyom Butorin on 18.05.22.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    weak var handle: AuthStateDidChangeListenerHandle?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
           guard let windowScene = (scene as? UIWindowScene) else { return }
           window = UIWindow(frame: UIScreen.main.bounds)
           handle = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
               if ((user) != nil) {
                   print("User logged in")
                   let home = TabBarController()
                   
//                   let home = self?.window?.rootViewController as? TabBarController()
                   self?.window?.rootViewController = home
                 
               } else {
                   print("Not Logged in")
                   let signup = AuthVC()
                   self?.window?.rootViewController = signup

                   }
               
           }
           window?.makeKeyAndVisible()
           window?.windowScene = windowScene
       }

//    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        guard let _ = (scene as? UIWindowScene) else { return }
//
//        guard let windowScene = (scene as? UIWindowScene) else { return }
//        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
//        window?.windowScene = windowScene
//        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
//            if user != nil {
//                print("User logged in")
//                let test = AuthVC()
//                self.window?.rootViewController = test
//            } else {
//                print("User not log in")
//                let home = TabBarController()
//                self.window?.rootViewController = home
//            }
//        }
////        window?.rootViewController = test
//
//        window?.makeKeyAndVisible()
//    }

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
