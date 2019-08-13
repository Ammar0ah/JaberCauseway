//
//  customTextField.swift
//  JaberCauseway
//
//  Created by Ammar Al-Helali on 8/10/19.
//  Copyright © 2019 Ammar Al-Helali. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class customTextField : UITextField {
    func setup(){
       
        let width = CGFloat(5.0)
    
        self.layer.borderColor = UIColor(hexString: "#34BE9CFF").cgColor
        self.backgroundColor = UIColor(hexString: "#2F9994")
        self.layer.borderWidth = width
        
     //   self.layer.masksToBounds = true
        self.layer.cornerRadius = 15
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
      
    }
    override init(frame: CGRect) {
        super.init(frame: CGRect())
    }
}
