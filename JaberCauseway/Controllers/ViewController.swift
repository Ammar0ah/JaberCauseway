//
//  ViewController.swift
//  JaberCauseway
//
//  Created by Ammar Al-Helali on 8/9/19.
//  Copyright © 2019 Ammar Al-Helali. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
   
    @IBOutlet var engButton: UIButton!
    @IBOutlet var arButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        navigationController?.navigationBar.isHidden = true
    
    
        
        // Do any additional setup after loading the view.
    }
    func setupButtons(){
      
        engButton.layer.borderColor = UIColor(hexString: "#34BE9CFF").cgColor
        engButton.layer.borderWidth = 4
        engButton.layer.cornerRadius = 18
        arButton.layer.cornerRadius = 18
        arButton.layer.borderWidth = 4
        arButton.layer.borderColor = UIColor(hexString: "#34BE9CFF").cgColor
    }

    @IBAction func arabicClicked(_ sender: Any) {
        ISARABIC = true
        
    }
}

