//
//  Utils.swift
//  ChararactersApp
//
//  Created by Dina Mansour  on 15/10/2024.
//

import UIKit
import Localize_Swift


class Utils {
    
 
    
    public static func localizedString(forKey key: String) -> String {
        Localize.setCurrentLanguage("ar")
        let resutl = key.localized(using: "Localization", in: .main)
        return resutl;
    }
}
