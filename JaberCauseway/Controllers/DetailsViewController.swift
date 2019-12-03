//
//  DetailsViewController.swift
//  JaberCauseway
//
//  Created by Ammar Al-Helali on 8/11/19.
//  Copyright © 2019 Ammar Al-Helali. All rights reserved.
//

import UIKit
import SVProgressHUD


class DetailsViewController: UIViewController {
    var discipline : Discipline!
    var hotspots : Hotspot!
    var identifier : String!
    var tempHotspot: [HotspotObject]?
    var request : Request
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var relatedHotspots: UILabel!
    @IBOutlet var relatedResults: UILabel!
    
    @IBOutlet var disciplineLbl: UILabel!
    @IBOutlet var searchResultLbl: UILabel!

    @IBOutlet var disciplineTableView: UITableView!
    @IBOutlet var disciplineBtn: UIButton!
    @IBOutlet var dropView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        request = Request()
        super.init(coder: aDecoder)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tempHotspot = hotspots.HotspotsObj
        if hotspots.HotspotsObj.isEmpty {
           
            SVProgressHUD.showError(withStatus: "No Results Found!")
            SVProgressHUD.dismiss(withDelay: 1.5)
        }
        // Do any additional setup after loading the view.
        localizeArabic()
      //  setupDropDown()
        disciplineTableView.layer.cornerRadius = 20
         disciplineTableView.separatorStyle = .none
        disciplineTableView.backgroundColor = #colorLiteral(red: 0.2549019608, green: 0.7764705882, blue: 0.7098039216, alpha: 1)
        disciplineBtn.setGradientBackgroundCircle(colorTop: UIColor(hexString: "#41C6B5"), colorBottom: UIColor(hexString: "#2E728E") )
//        disciplineTableView.bounces = false
        disciplineBtn.roundCorners([.allCorners], radius: 20)
        
        self.tableView.bounces = false
           navigationController?.navigationBar.barTintColor = .white
        
        disciplineBtn.setTitle(disciplineBtn.titleLabel?.text!.localized(), for: .normal)
        if #available(iOS 13.0, *){
            overrideUserInterfaceStyle = .light
        }
        let backBtn = UIBarButtonItem()
               backBtn.title = "Back".localized()
               navigationController?.navigationBar.topItem?.backBarButtonItem = backBtn
        
    }
    func localizeArabic(){
//        relatedResults.text = relatedResults.text?.localized()
        searchResultLbl.text = searchResultLbl.text?.localized()
//        relatedHotspots.text = relatedHotspots.text?.localized()
      //  disciplineLbl.text = disciplineLbl.text?.localized()
     
    }
      
    
    @IBAction func disciplineBtnClicked(_ sender: Any) {
        if disciplineTableView.isHidden{
            disciplineTableView.isHidden = false
        }
        else{ disciplineTableView.isHidden = true
        }
    }
    
}
    
extension DetailsViewController : UITableViewDelegate , UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == disciplineTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "discCell", for: indexPath)
            cell.backgroundColor = .clear
            cell.textLabel?.text = discipline.DisciplinesObj[indexPath.row].DisciplineName
            cell.textLabel?.textColor = #colorLiteral(red: 0.2238664925, green: 0.2093349099, blue: 0.4644450545, alpha: 1)
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.font = UIFont(name: "GillSansMTPro-Bold", size: 20)
            return cell
        }else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if identifier != "All"{
            cell.textLabel?.text = tempHotspot?[indexPath.row].HotspotNo
            cell.detailTextLabel?.text = tempHotspot?[indexPath.row].HotspotExpression
        }
        else {
            cell.textLabel?.text = hotspots.HotspotsObj[indexPath.row].HotspotNo
            cell.detailTextLabel?.text = hotspots.HotspotsObj[indexPath.row].HotspotExpression
        }
        
        return cell
        }
    
    }

//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if tableView == disciplineTableView{
//        let headerLbl = UILabel()
//        headerLbl.text = "Discipline".localized()
//        headerLbl.backgroundColor = #colorLiteral(red: 0.2533133328, green: 0.7760427594, blue: 0.7099617124, alpha: 1)
//        headerLbl.textAlignment = .center
//        headerLbl.textColor = .white
//             headerLbl.font = UIFont(name: "GillSansMTPro-Bold", size: 25)
//        return headerLbl
//        }
//        else {
//            let headerLbl = UILabel()
//                  headerLbl.text = "Related Results".localized()
//            headerLbl.font = UIFont(name: "GillSansMTPro-Bold", size: 30)
//                  headerLbl.backgroundColor = #colorLiteral(red: 0.2533133328, green: 0.7760427594, blue: 0.7099617124, alpha: 1)
//                  headerLbl.textAlignment = .center
//                  headerLbl.textColor = .white
//            
//            return headerLbl
//        }
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == disciplineTableView{
            return discipline.DisciplinesObj.count
        }
        else {
            return identifier == "All" ? hotspots.HotspotsObj.count : tempHotspot!.count
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == disciplineTableView{
            identifier = discipline.DisciplinesObj[indexPath.row].DisciplineName
                  
                  tempHotspot = hotspots.HotspotsObj.filter{obj in
                      return obj.HotspotDocumentTypeName == identifier
                  }
            tableView.isHidden = true
            disciplineBtn.setTitle(discipline.DisciplinesObj[indexPath.row].DisciplineName, for: .normal)
            self.tableView.reloadData()
        }
        else{
       
        SVProgressHUD.show(withStatus: "Please wait".localized())
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "itemDetailsViewController") as? ItemDetailsViewController else {return}
        
        if identifier != "All"{
            let tempNo = tempHotspot?[indexPath.row].HotspotNo
            request.getDocuments(hotspotNo: tempNo ?? ""){
                SVProgressHUD.dismiss()
                vc.docsTypes = self.request.docsTypes
                vc.document = self.request.document
                vc.docsTypes.DocumentsObj.insert(DocsObj(DocumentTypeID: "", DocumentTypeName: "All"), at: 0)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else {
            let hotspotNo =  hotspots.HotspotsObj[indexPath.row].HotspotNo
            request.getDocuments(hotspotNo : hotspotNo ){
                SVProgressHUD.dismiss()
                vc.docsTypes = self.request.docsTypes
                vc.document = self.request.document
                vc.docsTypes.DocumentsObj.insert(DocsObj(DocumentTypeID: "", DocumentTypeName: "All"), at: 0)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
            
        }
         tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
