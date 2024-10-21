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
    var navigationController: UINavigationController?

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
         

           let window = UIWindow(frame: UIScreen.main.bounds)
             self.window = window

            
                 //Initialize MainNavigationController
        let mainViewController = AllCharactersViewController(nibName: "AllCharactersViewController", bundle: nil)
        let navigationController = UINavigationController.init(rootViewController: mainViewController)
        self.window?.rootViewController = navigationController
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

