//
//  LoginViewController.swift
//  JaberCauseway
//
//  Created by Ammar Al-Helali on 8/9/19.
//  Copyright © 2019 Ammar Al-Helali. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class LoginViewController: UIViewController {
    
    @IBOutlet var userName: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var loginBttn: UIButton!
    
    @IBOutlet var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        localizeArabic()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapEvent))
        view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    
    override func viewWillAppear(_ animated: Bool) {
        loginBttn.setGradientBackgroundCircle( colorTop: UIColor(hexString: "#41BCA6"), colorBottom: UIColor(hexString: "#306F86"))
//        userName.layer.borderWidth = 5
//        userName.layer.borderColor = UIColor(hexString: "#34BE9CFF").cgColor
//        userName.layer.cornerRadius = 15
//        password.layer.borderWidth = 5
//        password.layer.borderColor = UIColor(hexString: "#34BE9CFF").cgColor
//        password.layer.cornerRadius = 15
    }
    func localizeArabic(){
        userName.placeholder = userName.placeholder?.localized()
        password.placeholder = password.placeholder?.localized()
        label.text = label.text?.localized()
        
        loginBttn.setTitle(loginBttn.titleLabel?.text?.localized(), for: .normal)
        
        loginBttn.titleLabel?.adjustsFontSizeToFitWidth = true
        userName.placeHolderColor = .white
        password.placeHolderColor = .white
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        SVProgressHUD.show(withStatus:"Sign in".localized())
        let user = userName.text!
        let pass = password.text!
        let login = Login(user: user, pass: pass)
        login.post(Posturl: LOGIN) { result in
            switch result {
            case .success(let message):
                DispatchQueue.main.async {
                    if message.Description == "Success"{
                        SVProgressHUD.showSuccess(withStatus:message.Description.localized())
                        self.performSegue(withIdentifier: "loginSegue", sender: self)
                    }
                    else {
                        SVProgressHUD.showError(withStatus:message.Description.localized() )
                    }
                    
                }
                
                break;
            case .failure(_):
                SVProgressHUD.showError(withStatus: "Connection Error".localized());
                
            }
            SVProgressHUD.dismiss(withDelay: 1)
        }
        
        
    }
    
    
    @objc func tapEvent(){
        userName.endEditing(true)
        password.endEditing(true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension LoginViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
}
