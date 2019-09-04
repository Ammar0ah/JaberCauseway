//
//  ItemDetailsViewController.swift
//  JaberCauseway
//
//  Created by Ammar Al-Helali on 8/12/19.
//  Copyright © 2019 Ammar Al-Helali. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD
class ItemDetailsViewController: UIViewController {
    var docsTypes : DocumentTypes!
    var document : Documents!
    var identifier : String!
    var documentsTxt : String?
    var tempdocs: [DocumentObject]?
    @IBOutlet var typesPickerView: UIPickerView!
    @IBOutlet var searchResultLbl: UILabel!
    @IBOutlet var relatedHotspot: UILabel!
    @IBOutlet var documentsTxtField: customTextField!
    @IBOutlet var searchField: customTextField!
    @IBOutlet var itemstableView: UITableView!
    @IBOutlet var typeLbl: UILabel!

 
    required init?(coder aDecoder: NSCoder) {

        identifier = "All"
      
            super.init(coder: aDecoder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        searchField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        // Do any additional setup after loading the view.
        localizeArabic()
     
        documentsTxtField.text = documentsTxt
        if let doctxt = documentsTxt     {
            searchFilter(sender: doctxt)
        }
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.tintColor = UIColor(hexString: "#2F9994")
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        SVProgressHUD.dismiss()
    }
    func localizeArabic(){
        searchResultLbl.text = searchResultLbl.text?.localized()
        relatedHotspot.text = relatedHotspot.text?.localized()
        typeLbl.text = typeLbl.text?.localized()
        documentsTxtField.placeholder = documentsTxtField.placeholder?.localized()
        documentsTxtField.placeHolderColor = .black
    }
    @objc func tapEvent(){
        documentsTxtField.endEditing(true)
    }
}

extension ItemDetailsViewController : UITextFieldDelegate {
    @objc func textChanged(_ sender:  customTextField) {
        searchFilter(sender: sender.text!)
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        
        itemstableView.reloadData()
    }
   
    func searchFilter(sender:String ){
        identifier = "Search"
        let index = typesPickerView.selectedRow(inComponent: 0)
        let type = docsTypes.DocumentsObj[index].DocumentTypeID
        tempdocs =  document.DocumentsObj.filter{obj -> Bool in
            let lower =  obj.DocumentTitle.lowercased()
            if type.isEmpty {
                if sender.isEmpty{
                    identifier = "All"
                    return true
                }
                return lower.contains(sender)
            }
            else  if sender.isEmpty{
          
                return obj.DocumentDisciplineID == type}
            else
            {
                return lower.contains(sender) && obj.DocumentDisciplineID == type
            }
            
        }
        print(identifier!,"type",type)
        itemstableView.reloadData()
    }
}


extension ItemDetailsViewController : UIPickerViewDelegate , UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return docsTypes.DocumentsObj[row].DocumentTypeName
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
   
        if row == 0 && identifier != "Search"{
            identifier = "All"
        }else if identifier == "Search"
        {
            searchFilter(sender: documentsTxtField.text!)
        }
            
            
        else {
            
            identifier = docsTypes.DocumentsObj[row].DocumentTypeID
            tempdocs = document.DocumentsObj.filter{obj -> Bool in
                obj.DocumentDisciplineID == identifier
            }
        }
        itemstableView.reloadData()
        
        
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return docsTypes.DocumentsObj.count
    }
    
    
}
extension ItemDetailsViewController : UITableViewDelegate, UITableViewDataSource ,WKNavigationDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return identifier == "All" ? document.DocumentsObj.count : tempdocs!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var doc =  document.DocumentsObj[indexPath.row]
        if identifier != "All" {
            if let temp = tempdocs?[indexPath.row]{
                doc = temp
            }
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = doc.DocumentTitle
        switch doc.DocumentFileType {
        case "PDF":
            cell.imageView?.image = UIImage(named: "pdf")
            break;
        case "JPG":
            cell.imageView?.image = UIImage(named: "jpg")
            break;
        default:
            cell.imageView?.image = UIImage(named: "file")
        }
        cell.detailTextLabel?.text = doc.DocumentFileType
        cell.detailTextLabel?.textColor = .black
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let window = UIApplication.shared.keyWindow!
       let wkWebView =  WKWebView(frame:CGRect(x: 0, y: window.safeAreaInsets.top + 50, width: screenBounds.width, height:  screenBounds.height))
        wkWebView.navigationDelegate = self
        itemstableView.deselectRow(at: indexPath, animated: true)
        let fileView = UIViewController()
        let path : String?
        if  identifier == "All"{
            path = document.DocumentsObj[indexPath.row].DocumentPath
          
        }else{
            path = tempdocs?[indexPath.row].DocumentPath
        }
        
        let url = URL(string:path!)!
        let urlRequest = URLRequest(url: url)
        wkWebView.load(urlRequest)
        fileView.view.backgroundColor = UIColor(hexString: "#808080")
        fileView.view.addSubview(wkWebView)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.pushViewController(fileView, animated: true)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        SVProgressHUD.show(withStatus: "Please wait while your document is being downloaded".localized())
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        SVProgressHUD.dismiss()
    }
    
}

