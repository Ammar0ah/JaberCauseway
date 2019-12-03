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
    @IBOutlet var typesTableView: UITableView!
    //   @IBOutlet var typesPickerView: UIPickerView!
  @IBOutlet var searchResultLbl: UILabel!
  //  @IBOutlet var relatedHotspot: UILabel!
    @IBOutlet var typesBtn: UIButton!
    @IBOutlet var documentsTxtField: customTextField!
    @IBOutlet var searchField: customTextField!
    @IBOutlet var itemstableView: UITableView!
   // @IBOutlet var typeLbl: UILabel!

//    @IBOutlet var relatdDocs: UILabel!
    
    required init?(coder aDecoder: NSCoder) {

        identifier = "All"
      
            super.init(coder: aDecoder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let backBtn = UIBarButtonItem()
        backBtn.title = "Back".localized()
        navigationController?.navigationBar.topItem?.backBarButtonItem = backBtn
        searchField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        // Do any additional setup after loading the view.
        localizeArabic()
        
        if document.DocumentsObj.isEmpty{
            SVProgressHUD.showError(withStatus: "No Documents Found!")
            SVProgressHUD.dismiss(withDelay: 2)
        }
        documentsTxtField.text = documentsTxt
        if let doctxt = documentsTxt     {
            searchFilter(sender: doctxt)
        }
        searchField.placeHolderColor = .white
        
        typesBtn.setTitle(typesBtn.titleLabel?.text!.localized(), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        typesTableView.layer.cornerRadius = 20
        typesTableView.separatorStyle = .none
        typesTableView.backgroundColor = #colorLiteral(red: 0.2533133328, green: 0.7760427594, blue: 0.7099617124, alpha: 1)
        typesBtn.setGradientBackgroundCircle(colorTop: UIColor(hexString: "#41C6B5"), colorBottom: UIColor(hexString: "#2E728E"))
//        typesTableView.bounces = false
        typesBtn.roundCorners([.allCorners], radius: 20)
        typesBtn.setTitle(typesBtn.titleLabel?.text!.localized(), for: .normal)
        self.typesTableView.bounces = false
        self.itemstableView.bounces = false
          SVProgressHUD.dismiss()
    }
    override func viewWillDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
        
       
    }
    func localizeArabic(){
      //  relatdDocs.text = "\(String(describing: relatdDocs.text!.localized()))(\(document.DocumentsObj.count))"
       searchResultLbl.text = searchResultLbl.text?.localized()
   //     relatedHotspot.text = relatedHotspot.text?.localized()
    //    typeLbl.text = typeLbl.text?.localized()
        documentsTxtField.placeholder = documentsTxtField.placeholder?.localized()
        documentsTxtField.placeHolderColor = .black
    }
    @objc func tapEvent(){
        documentsTxtField.endEditing(true)
    }
    @IBAction func typesBtnPressed(_ sender: Any) {
        if typesTableView.isHidden{
            typesTableView.isHidden = false}
        else  {
            typesTableView.isHidden = true
        }
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
        let index = typesTableView.indexPathForSelectedRow?.row
        let type = docsTypes.DocumentsObj[index ?? 0].DocumentTypeID
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
        if tempdocs!.isEmpty {
            SVProgressHUD.showError(withStatus: "No Documents Found!".localized())
            SVProgressHUD.dismiss(withDelay: 2)
        }
    //    relatdDocs.text = "Related Documents".localized()
    //    relatdDocs.text = "\(String(describing: relatdDocs.text!.localized()))(\(tempdocs!.count))"
        print(identifier!,"type",type)
        itemstableView.reloadData()
    }
}

extension ItemDetailsViewController : UITableViewDelegate, UITableViewDataSource ,WKNavigationDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == typesTableView{
            return docsTypes.DocumentsObj.count
        }
        else{
        return identifier == "All" ? document.DocumentsObj.count : tempdocs!.count
        }
    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if tableView == typesTableView{
//            let headerLbl = UILabel()
//            headerLbl.text = "Type".localized()
//            headerLbl.backgroundColor = #colorLiteral(red: 0.2533133328, green: 0.7760427594, blue: 0.7099617124, alpha: 1)
//            headerLbl.textAlignment = .center
//            headerLbl.textColor = .white
//            headerLbl.font = UIFont(name: "GillSansMTPro-Bold", size: 25)
//            return headerLbl
//        }
//        else {
//            let headerLbl = UILabel()
//            headerLbl.text = "Related Results".localized()
//            headerLbl.font = UIFont(name: "GillSansMTPro-Bold", size: 30)
//            headerLbl.backgroundColor = #colorLiteral(red: 0.2533133328, green: 0.7760427594, blue: 0.7099617124, alpha: 1)
//            headerLbl.textAlignment = .center
//            headerLbl.textColor = .white
//
//            return headerLbl
//        }
//    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == typesTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "typeCell", for: indexPath)
            cell.textLabel?.text = docsTypes.DocumentsObj[indexPath.row].DocumentTypeName
            cell.textLabel?.textColor = #colorLiteral(red: 0.2238664925, green: 0.2093349099, blue: 0.4644450545, alpha: 1)
            cell.textLabel?.textAlignment = .center
            cell.backgroundColor = .clear
            cell.textLabel?.font = UIFont(name: "GillSansMTPro-Bold", size: 20)
            return cell
        }
        else {
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
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == typesTableView{
            if indexPath.row == 0 && identifier != "Search"{
                       identifier = "All"
                  //     relatdDocs.text = "Related Documents".localized()
               //        relatdDocs.text = "\(String(describing: relatdDocs.text!.localized()))(\(document.DocumentsObj.count))"
                       
                       itemstableView.reloadData()
                   }else if identifier == "Search"
                   {
                       searchFilter(sender: documentsTxtField.text!)
                   }
                       
                       
                   else {
                       
                identifier = docsTypes.DocumentsObj[indexPath.row].DocumentTypeID
                       tempdocs = document.DocumentsObj.filter{obj -> Bool in
                           obj.DocumentDisciplineID == identifier
                       }
                     //  relatdDocs.text = "Related Documents ".localized()
                     //  relatdDocs.text = "\(String(describing: relatdDocs.text!.localized()))(\(tempdocs!.count))";
                       
                       itemstableView.reloadData()
                   }
                   itemstableView.reloadData()
            typesBtn.setTitle(docsTypes.DocumentsObj[indexPath.row].DocumentTypeName, for: .normal)
            
            typesTableView.isHidden = true
        }
        else {
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
            let backBtn = UIBarButtonItem()
                   backBtn.title = "Back".localized()
                   navigationController?.navigationBar.topItem?.backBarButtonItem = backBtn
            
                  navigationController?.pushViewController(fileView, animated: true)
        }
      tableView.deselectRow(at: indexPath, animated: true)
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

