//
//  ViewExtension.swift
//  jabercauseway
//
//  Created by Ammar Al-Helali on 10/6/19.
//  Copyright © 2019 Ammar Al-Helali. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    
    @IBInspectable
    var stShadow: Bool {
        get {
            return layer.shadowRadius > 0
        }
        set {
            if newValue
            {
                layer.shadowOpacity = 0.3
                layer.shadowOffset = CGSize(width: 1, height: 1)
                layer.shadowRadius = 0.5
            }
            else
            {
                layer.shadowRadius = 0
                layer.shadowOpacity = 0
                layer.shadowOffset = CGSize(width: 0, height: 0)
                
            }
        }
    }
    
    
    @IBInspectable
    var stRounded: Bool {
        get {
            return layer.masksToBounds
        }
        set {
            if newValue
            {
                layer.masksToBounds = true
                let width = frame.width < frame.height ? frame.width : frame.height
                layer.cornerRadius = width / 2
            }
            else
            {
                layer.masksToBounds = false
                layer.cornerRadius = 0
                
            }
        }
    }
    
    @IBInspectable
    var stSoftEdges: Bool {
        get {
            return layer.cornerRadius > 0
        }
        set {
            if newValue
            {
               
                layer.cornerRadius = 5
            }
            else
            {
                layer.cornerRadius = 0
                
            }
        }
    }
    
    @IBInspectable
    var stBorder: Bool {
        get {
            return layer.borderWidth > 0
        }
        set {
            if newValue
            {
                layer.borderWidth = 0.5
                layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)

            }
            else
            {
                layer.borderWidth = 0
                layer.borderColor = nil

            }
        }
    }
    
    
    
    @IBInspectable
    var masksToBounds: Bool {
        get {
            return layer.masksToBounds
        }
        set {
            layer.masksToBounds = newValue
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return 0
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
//
//    @IBInspectable
//    var colorTop:UIColor?{
//        get{
//            return #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        }
//        set{
//            self.colorTop = newValue
//        }
//    }
//
//    @IBInspectable
//       var colorBottom:UIColor?{
//           get{
//               return #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//           }
//           set{
//               self.colorBottom = newValue
//           }
//       }
//
//    @IBInspectable
//    var gradientBackground:CALayer{
//        get {
//            return CALayer()
//        }
//        set{
//            setGradientBackgroundCircle(colorTop: self.colorTop!, colorBottom: self.colorBottom!)
//        }
//    }

    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    
    func setGradientBackgroundCircle(locationY:NSNumber = 1 ,colorTop:UIColor = COLOR_TOP , colorBottom:UIColor = COLOR_BOTTOM) {
          let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ colorTop.cgColor,colorBottom.cgColor]
         gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.locations = [0, locationY]
          gradientLayer.frame = bounds
        
          layer.insertSublayer(gradientLayer, at: 0)
}
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
           let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
           let mask = CAShapeLayer()
           mask.path = path.cgPath
           layer.mask = mask
       }
}

@IBDesignable class GradientView: UIView {

@IBInspectable var startColor: UIColor = .blue {
    didSet {
        setNeedsLayout()
    }
}

@IBInspectable var endColor: UIColor = .green {
    didSet {
        setNeedsLayout()
    }
}



@IBInspectable var shadowX: CGFloat = 0 {
    didSet {
        setNeedsLayout()
    }
}

@IBInspectable var shadowY: CGFloat = -3 {
    didSet {
        setNeedsLayout()
    }
}

@IBInspectable var shadowBlur: CGFloat = 3 {
    didSet {
        setNeedsLayout()
    }
}

@IBInspectable var startPointX: CGFloat = 0 {
    didSet {
        setNeedsLayout()
    }
}

@IBInspectable var startPointY: CGFloat = 0 {
    didSet {
        setNeedsLayout()
    }
}

@IBInspectable var endPointX: CGFloat = 0 {
    didSet {
        setNeedsLayout()
    }
}

@IBInspectable var endPointY: CGFloat = 0 {
    didSet {
        setNeedsLayout()
    }
}


override class var layerClass: AnyClass {
    return CAGradientLayer.self
}

override func layoutSubviews() {
    let gradientLayer = layer as! CAGradientLayer
    gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    gradientLayer.startPoint = CGPoint(x: startPointX, y: startPointY)
    gradientLayer.endPoint = CGPoint(x: endPointX, y: endPointY)
    layer.cornerRadius = cornerRadius
    layer.shadowColor = shadowColor?.cgColor
    layer.shadowOffset = CGSize(width: shadowX, height: shadowY)
    layer.shadowRadius = shadowBlur
    layer.shadowOpacity = 1
}
}
