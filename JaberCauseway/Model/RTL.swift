//
//  RTL.swift
//  JaberCauseway
//
//  Created by Ammar Al-Helali on 8/11/19.
//  Copyright © 2019 Ammar Al-Helali. All rights reserved.
//

import Foundation
import UIKit

var ISARABIC : Bool = false

func rtl() {
    if ISARABIC{
        UIView.appearance().semanticContentAttribute = .forceRightToLeft
    }else {
        UIView.appearance().semanticContentAttribute = .forceLeftToRight
    }
    }


