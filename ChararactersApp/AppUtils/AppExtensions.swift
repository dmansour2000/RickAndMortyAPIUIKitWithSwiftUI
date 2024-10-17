//
//  AppExtensions.swift
//  
//
//  Created by Dina Mansour on 9/2/19.
//  Copyright © 2019 Dina Mansour. All rights reserved.
//

import Foundation
import UIKit
import Cartography





extension UITextField {
    func addBottomBorder(string : String){
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:0.5).cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width + 50 , height: self.frame.size.height)
        
        self.textColor = UIColor.white
        self.backgroundColor = UIColor.clear
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        self.attributedPlaceholder = NSAttributedString(string: string,
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        
    }
    
    func addRedBottomBorder( string : String){
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.red.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width + 50 , height: self.frame.size.height)
        
        self.textColor = UIColor(red: 27.0 / 255.0, green: 36.0 / 255.0, blue: 49.0 / 255.0, alpha: 1.0)
        self.backgroundColor = UIColor.clear
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        self.attributedPlaceholder = NSAttributedString(string: string,
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        
    }
    
    func addGreyBottomBorder(string : String){
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width + 50 , height: self.frame.size.height)
        
        self.textColor = UIColor(red: 27.0 / 255.0, green: 36.0 / 255.0, blue: 49.0 / 255.0, alpha: 1.0)
        self.backgroundColor = UIColor.clear
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        self.attributedPlaceholder = NSAttributedString(string: string,
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    }
    
    func addGreyRedBottomBorder( string : String){
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.red.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width + 50 , height: self.frame.size.height)
        
        self.textColor = UIColor.darkGray
        self.backgroundColor = UIColor.clear
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        self.attributedPlaceholder = NSAttributedString(string: string,
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    }
}
extension UIView {
    
    func fillScreenLayoutConstrains() {
        constrain(self) { view in
            view.edges == view.superview!.edges
        }
    }
    func roundCorners(cornerRadius: Double, bordercolor: UIColor, borderwidth: CGFloat) {
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.layer.borderColor = bordercolor.cgColor;
        self.layer.borderWidth = borderwidth
        self.clipsToBounds = true
    }
    
    func dropShadow(withRadius radius: CGFloat, opacity: Float, withColor color: CGColor, size: CGSize) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = size
        self.layer.shadowRadius = radius
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func width() -> CGFloat {
        return self.frame.width
    }
    
    func height() -> CGFloat {
        return self.frame.height
    }
    
    func applyGradient(colors: [UIColor], cornerRadius: CGFloat? = 0, locations: [NSNumber]? = [0, 1]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.locations = locations
        gradientLayer.frame = self.layer.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
        
        gradientLayer.cornerRadius = cornerRadius ?? 0
        self.layer.cornerRadius = cornerRadius ?? 0
    }
    
}

extension UIButton {
    
    
    func addRoundedCorner( bg : UIColor){
        
        let width = CGFloat(2.0)
        
        
        
        
        self.roundCorners(cornerRadius: 15.0, bordercolor: UIColor(red: 222.0 / 255.0, green: 226.0 / 255.0, blue: 232.0 / 255.0, alpha: 1.0), borderwidth: width)
        
        self.backgroundColor = bg
        
        
        
    }
    
    
    
    
    func roundCorners(corners: UIRectCorner, radius: Int = 8) {
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: corners,
                                     cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
}

public enum AppFontStyle: Int {
    case bold, light, regular, ultraLight, medium, heavy, semibold, italic, black, thin, extraLight
}

public enum AppFontName: Int {
    case Monaco, SFProText, SFProDisplay, Cairo
}

extension UIFont {
    class func languageSpecificFont(style: [AppFontStyle], size: [CGFloat], font: [AppFontName]) -> UIFont {
       
            return UIFont.appFont(style: style[0], size: size[0], font: font[0])
      
    }
    
    class func appFont(style: AppFontStyle, size: CGFloat, font: AppFontName) -> UIFont {
        var fontName = ""
        switch font {
        case .Monaco:
            fontName = "Monaco"
            break
            
        case .SFProText:
            fontName = "SFProText"
            break
            
        case .SFProDisplay:
            fontName = "SFProDisplay"
            break
        case .Cairo:
            fontName = "Cairo"
            break
        }
        
        switch style {
        case .bold:
            if font == .Monaco {
                fatalError("No bold style font added for Monaco.")
            } else if font == .SFProDisplay {
                let correctFont = fontName + "-Bold"
                fontName = correctFont
            } else if font == .SFProText {
                let correctFont = fontName + "-Bold"
                fontName = correctFont
            } else if font == .Cairo {
                let correctFont = fontName + "-Bold"
                fontName = correctFont
            }
            break
        case .light:
            if font == .Monaco {
                fatalError("No light style font added for Monaco.")
            } else if font == .SFProDisplay {
                let correctFont = fontName + "-Light"
                fontName = correctFont
            } else if font == .SFProText {
                let correctFont = fontName + "-Light"
                fontName = correctFont
            } else if font == .Cairo {
                let correctFont = fontName + "-Light"
                fontName = correctFont
            }
            break
        case .medium:
            if font == .Monaco {
                fatalError("No medium style font added for Monaco.")
            } else if font == .SFProDisplay {
                let correctFont = fontName + "-Medium"
                fontName = correctFont
            } else if font == .SFProText {
                let correctFont = fontName + "-Medium"
                fontName = correctFont
            } else if font == .Cairo {
                fatalError("No medium style font added for Cairo.")
            }
            break
        case .ultraLight:
            if font == .Monaco {
                fatalError("No ultralight style font added for Monaco.")
            } else if font == .SFProDisplay {
                let correctFont = fontName + "-Ultralight"
                fontName = correctFont
            } else if font == .SFProText {
                fatalError("No ultralight style font added for Monaco.")
            } else if font == .Cairo {
                fatalError("No ultralight style font added for Cairo.")
            }
            break
        case .regular:
            if font == .Monaco {
                fontName = "Monaco"
            } else if font == .SFProDisplay {
                let correctFont = fontName + "-Regular"
                fontName = correctFont
            } else if font == .SFProText {
                let correctFont = fontName + "-Regular"
                fontName = correctFont
            } else if font == .Cairo {
                let correctFont = fontName + "-Regular"
                fontName = correctFont
            }
            break
        case .heavy:
            if font == .Monaco {
                fatalError("No heavy style font added for Monaco.")
            } else if font == .SFProDisplay {
                let correctFont = fontName + "-Heavy"
                fontName = correctFont
            } else if font == .SFProText {
                let correctFont = fontName + "-Heavy"
                fontName = correctFont
            } else if font == .Cairo {
                fatalError("No heavy style font added for Cairo.")
            }
            break
        case .semibold:
            if font == .Monaco {
                fatalError("No semibold style font added for Monaco.")
            } else if font == .SFProDisplay {
                let correctFont = fontName + "-Semibold"
                fontName = correctFont
            } else if font == .SFProText {
                let correctFont = fontName + "-Semibold"
                fontName = correctFont
            } else if font == .Cairo {
                let correctFont = fontName + "-SemiBold"
                fontName = correctFont
            }
            break
        case .italic:
            if font == .Monaco {
                fatalError("No italic style font added for Monaco.")
            } else if font == .SFProDisplay {
                let correctFont = fontName + "-Italic"
                fontName = correctFont
            } else if font == .SFProText {
                let correctFont = fontName + "-Italic"
                fontName = correctFont
            } else if font == .Cairo {
                fatalError("No italic style font added for Cairo.")
            }
            break
        case .black:
            if font == .Monaco {
                fatalError("No black style font added for Monaco.")
            } else if font == .SFProDisplay {
                let correctFont = fontName + "-Black"
                fontName = correctFont
            } else if font == .SFProText {
                fatalError("No black style font added for Monaco.")
            } else if font == .Cairo {
                let correctFont = fontName + "-Black"
                fontName = correctFont
            }
            break
        case .thin:
            if font == .Monaco {
                fatalError("No thin style font added for Monaco.")
            } else if font == .SFProDisplay {
                let correctFont = fontName + "-Thin"
                fontName = correctFont
            } else if font == .SFProText {
                fatalError("No thin style font added for SFProText.")
            } else if font == .Cairo {
                fatalError("No thin style font added for Cairo.")
            }
            break
        case .extraLight:
            if font == .Monaco {
                fatalError("No extraLight style font added for Monaco.")
            } else if font == .SFProDisplay {
                fatalError("No extraLight style font added for SFProDisplay.")
            } else if font == .SFProText {
                fatalError("No extraLight style font added for SFProText.")
            } else if font == .Cairo {
                let correctFont = fontName + "-ExtraLight"
                fontName = correctFont
            }
            break
        }
        return UIFont.init(name: fontName, size: size)!
    }
}


extension UIColor {
    class func random() -> UIColor {
        let red:CGFloat = CGFloat(drand48())
        let green:CGFloat = CGFloat(drand48())
        let blue:CGFloat = CGFloat(drand48())
        return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
    }
    
    class func RGB(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor.init(red: r/255, green: g/255, blue: b/255, alpha: 1.0)
    }
    
    @nonobjc class var clearBlue: UIColor {
        return UIColor(red: 43.0 / 255.0, green: 132.0 / 255.0, blue: 1.0, alpha: 1.0)
    }
    @nonobjc class var brightSkyBlue: UIColor {
        return UIColor(red: 0.0, green: 177.0 / 255.0, blue: 1.0, alpha: 1.0)
    }
    
    @nonobjc class var dark20: UIColor {
        return UIColor(red: 27.0 / 255.0, green: 36.0 / 255.0, blue: 49.0 / 255.0, alpha: 0.2)
    }
    
    @nonobjc class var paleGrey: UIColor {
        return UIColor(red: 222.0 / 255.0, green: 226.0 / 255.0, blue: 232.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var dark8: UIColor {
        return UIColor(red: 27.0 / 255.0, green: 36.0 / 255.0, blue: 49.0 / 255.0, alpha: 0.08)
    }
    
    @nonobjc class var steel: UIColor {
        return UIColor(red: 125.0 / 255.0, green: 134.0 / 255.0, blue: 152.0 / 255.0, alpha: 1.0)
    }
    
    class func themeColor() -> UIColor {
        return RGB(r: 255, g: 255, b: 255)
    }
    
    class func darkColor() -> UIColor {
        return RGB(r: 27, g: 36, b: 49)
    }
}

extension NSTextAlignment {
    static func languagePrefersTextAlignment() -> NSTextAlignment {
        return  .left
    }
    
   
}

extension UISemanticContentAttribute {
    static func languagePrefersContentAlignment() -> UISemanticContentAttribute {
        return forceLeftToRight
    }
}

extension UIControl.ContentHorizontalAlignment {
    static func languagePrefersTextAlignment() -> UIControl.ContentHorizontalAlignment {
        return  .left
    }
    
 
}

extension CALayer {
    func applySketchShadow(color: UIColor = .black, alpha: Float = 0.5, x: CGFloat = 0, y: CGFloat = 2, blur: CGFloat = 4, spread: CGFloat = 0) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        masksToBounds = false
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
    
}

extension UIScreen {
    class func screenSize() -> CGSize {
        return self.main.bounds.size
    }
}

extension UIViewController {
    
    var sharedDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    // Hide keyboard if the user touch outside
    func hideKeyboardOnTouch()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}


