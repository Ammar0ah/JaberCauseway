//
//  ViewController.swift
//  JaberCauseway
//
//  Created by Ammar Al-Helali on 8/9/19.
//  Copyright © 2019 Ammar Al-Helali. All rights reserved.
//

import UIKit
import SVProgressHUD

let COLOR_TOP = #colorLiteral(red: 0.222992301, green: 0.7108014226, blue: 0.7135433555, alpha: 1)
let COLOR_BOTTOM = #colorLiteral(red: 0.2238664925, green: 0.2093349099, blue: 0.4644450545, alpha: 1)

class ViewController: UIViewController {
    
    @IBOutlet var engButton: UIButton!
    @IBOutlet var arButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *){
            overrideUserInterfaceStyle = .light
        }
        setupButtons()
        navigationController?.navigationBar.isHidden = true
        SVProgressHUD.setDefaultStyle(.dark)
        
        // Do any additional setup after loading the view.
    }
    func setupButtons(){
        engButton.setGradientBackgroundCircle( colorTop: UIColor(hexString: "#41BCA6"), colorBottom: UIColor(hexString: "#306F86"))
        arButton.setGradientBackgroundCircle( colorTop: UIColor(hexString: "#41BCA6"), colorBottom: UIColor(hexString: "#306F86"))
        //        engButton.layer.borderColor = UIColor(hexString: "#34BE9CFF").cgColor
        //        engButton.layer.borderWidth = 4
        //        engButton.layer.cornerRadius = 18
        //        arButton.layer.cornerRadius = 18
        //        arButton.layer.borderWidth = 4
        //        arButton.layer.borderColor = UIColor(hexString: "#34BE9CFF").cgColor
        
    }
    
    @IBAction func arabicClicked(_ sender: Any) {
        ISARABIC = true
        
    }
}

