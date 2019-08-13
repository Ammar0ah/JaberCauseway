//
//  customNavigationController.swift
//  JaberCauseway
//
//  Created by Ammar Al-Helali on 8/13/19.
//  Copyright © 2019 Ammar Al-Helali. All rights reserved.
//

import UIKit

class customNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
       self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()

    }
    

}
