//
//  customButton.swift
//  JaberCauseway
//
//  Created by Ammar Al-Helali on 8/10/19.
//  Copyright © 2019 Ammar Al-Helali. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class customButton : UIButton {
    func setup(){
        self.backgroundColor = UIColor(hexString: "#2F9994")
        self.layer.borderColor = UIColor(hexString: "#34BE9C").cgColor
        self.layer.borderWidth = 5
        self.layer.cornerRadius = 20
        self.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    override init(frame: CGRect) {
        super.init(frame: CGRect())
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    @IBInspectable var adjustsTitleFontSizeToFitWidth: Bool = false {
        didSet {
            
            self.titleLabel?.adjustsFontSizeToFitWidth = adjustsTitleFontSizeToFitWidth
        }
    }
    
}
