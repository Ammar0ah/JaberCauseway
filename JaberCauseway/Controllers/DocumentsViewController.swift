//
//  DetailsViewController.swift
//  JaberCauseway
//
//  Created by Ammar Al-Helali on 8/10/19.
//  Copyright © 2019 Ammar Al-Helali. All rights reserved.
//

import UIKit

class DocumentsViewController: UIViewController  , QRcode{
   
    @IBOutlet var documentSearchLbl: UILabel!
    
    @IBOutlet private var assetGroup : UITextField!
    @IBOutlet private var hostpot : UITextField!
    @IBOutlet private var document : UITextField!
    var reqTextField : UITextField?
    
    
     let request = Request()
    override func viewDidLoad() {
        super.viewDidLoad()
               rtl()
        if ISARABIC {
            self.navigationController?.view.semanticContentAttribute = .forceRightToLeft
            assetGroup.placeholder = assetGroup.placeholder?.localized()
            assetGroup.placeHolderColor = .black
            hostpot.placeholder = hostpot.placeholder?.localized()
            hostpot.placeHolderColor = .black
            document.placeholder = document.placeholder?.localized()
            document.placeHolderColor = .black
            documentSearchLbl.text = documentSearchLbl.text?.localized()
        }
        assetGroup.becomeFirstResponder()
      
       
        
        // Do any additional setup after loading the view.
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapEvent))
        self.view.addGestureRecognizer(gesture)
    }
  
    @IBAction func exitClicked(_ sender: Any) {
        //print("MyString".localized("en"))
        let alert = UIAlertController(title: "Exit the App?".localized(), message: "press ok to proceed".localized(), preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok".localized(), comment: ""), style: .default, handler: { (action) in
            exit(0)
        }))
        let cancel = NSLocalizedString("Cancel".localized(), comment: "")
        alert.addAction(UIAlertAction(title: cancel, style: .cancel))
        present(alert ,animated: true)
        
    }
    
   
    @IBAction func searchClicked(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "detailsViewController") as? DetailsViewController else {return}

        if reqTextField == hostpot ||  reqTextField == assetGroup {
            request.getHotspots(hotspotGroup: assetGroup.text ?? "", hotspotNo: hostpot.text ?? ""){
                vc.hotspots = self.request.hotspot
                vc.discipline = self.request.discipline
                     vc.discipline?.DisciplinesObj.insert(DisciplinesObject(DisciplineID: "", DisciplineName: "All"), at: 0)
                print("Got Hotspots")
                  self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if reqTextField == document{
      
        request.getDocuments(hotspotNo: hostpot.text ?? ""){
          self.performSegue(withIdentifier: "documentsearchSegue", sender: self)
        }
      
        }
        
        
        
    }
    func getQRcode(code: String) {
        hostpot.text = code
        print("Code" , code)
        request.getDocuments(hotspotNo: hostpot.text ?? ""){
            self.performSegue(withIdentifier: "documentsearchSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "qrSegue" {
            if let vc = segue.destination as? ScannerViewController {
               	vc.delegate = self
            }
            
            
        }
        else if segue.identifier == "documentsearchSegue"{
            if let vc = segue.destination as?  ItemDetailsViewController{
                vc.document = request.document
                vc.docsTypes = request.docsTypes
                vc.documentsTxt = document.text
                vc.docsTypes.DocumentsObj.insert(DocsObj(DocumentTypeID: "", DocumentTypeName: "All"), at: 0)
           
            }
        }
    }
    @objc func tapEvent(){
        assetGroup.endEditing(true)
        hostpot.endEditing(true)
        document.endEditing(true)
    }
    
}
extension DocumentsViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        reqTextField = textField
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
 
}