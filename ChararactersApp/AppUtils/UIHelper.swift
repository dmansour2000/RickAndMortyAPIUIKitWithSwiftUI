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
    
    
    public static func validateEmail(enteredEmail:String) -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
        
    }
    
    public static func isStringAnInt(stringNumber: String) -> Bool {

        if let _ = Int(stringNumber) {
            return true
        }
        return false
    }
    
    public static func stringToUTF16String (stringaDaConvertire stringa: String) -> String {
        
        let encodedData = stringa.data(using: String.Encoding.utf16)!
        
        do {
            return try NSAttributedString(data: encodedData,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil).string
        } catch {
            print("error: ", error)
            return ""
        }
    }
}
