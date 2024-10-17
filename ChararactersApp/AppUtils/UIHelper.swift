//
//  UIHelper.swift
//  
//
//  Created by Dina Mansour on 9/2/19.
//  Copyright © 2019 Dina Mansour. All rights reserved.
//

import Foundation
import UIKit
import Cartography
import SwiftMessages

class UIHelper: NSObject {
    @MainActor public static func showSuccessMessage(_ message: String){
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(.success)
        view.configureDropShadow()
        view.button?.removeFromSuperview()
        view.configureContent(title: "successTitle" , body: message)
        
        let config = UIHelper.getShowMessageConfig()
        SwiftMessages.show(config: config, view: view)
    }
    
    @MainActor public static func showErrorMessage(_ message: String){
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(.error)
        view.configureDropShadow()
        view.button?.removeFromSuperview()
        view.configureContent(title: "errorTitle", body: message)
        let config = UIHelper.getShowMessageConfig()
        SwiftMessages.show(config: config, view: view)
    }
    
    private static func getShowMessageConfig() -> SwiftMessages.Config{
        var config = SwiftMessages.Config()
        config.presentationStyle = .top
        config.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        config.dimMode = .gray(interactive: true)
        config.interactiveHide = true
        return config
    }
    
   
}
