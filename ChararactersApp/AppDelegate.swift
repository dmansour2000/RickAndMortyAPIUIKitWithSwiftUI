//
//  AppDelegate.swift
//  ChararactersApp
//
//  Created by Dina Mansour  on 14/10/2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
         

           let window = UIWindow(frame: UIScreen.main.bounds)
             self.window = window

            
                 //Initialize MainNavigationController
        let homeViewController = AllCharactersViewController(nibName: "AllCharactersViewController", bundle: nil)
             let rootNC = UINavigationController(rootViewController: homeViewController)
                     self.window?.rootViewController = rootNC
                     self.window?.makeKeyAndVisible()
               
             
      

         return true
     }

     func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
         if #available(iOS 13.0, *) {
             // In iOS 13 setup is done in SceneDelegate
         } else {
             self.window?.makeKeyAndVisible()
         }

         return true
     }


   
  

}

