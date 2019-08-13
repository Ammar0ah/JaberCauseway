//
//  DetailsViewController.swift
//  JaberCauseway
//
//  Created by Ammar Al-Helali on 8/11/19.
//  Copyright © 2019 Ammar Al-Helali. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    var discipline : Discipline!
    var hotspots : Hotspot!
    var identifier : String!
    var tempHotspot: [HotspotObject]?
    var request : Request
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var relatedHotspots: UILabel!
    
    @IBOutlet var disciplineLbl: UILabel!
    @IBOutlet var searchResultLbl: UILabel!
    required init?(coder aDecoder: NSCoder) {
        request = Request()
        super.init(coder: aDecoder)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tempHotspot = hotspots.HotspotsObj
        // Do any additional setup after loading the view.
        localizeArabic()
    }
    func localizeArabic(){
        searchResultLbl.text = searchResultLbl.text?.localized()
        relatedHotspots.text = relatedHotspots.text?.localized()
        disciplineLbl.text = disciplineLbl.text?.localized()
    }
    
}

extension DetailsViewController : UIPickerViewDelegate , UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return discipline.DisciplinesObj.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return discipline.DisciplinesObj[row].DisciplineName
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        identifier = discipline.DisciplinesObj[row].DisciplineName
        
        tempHotspot = hotspots.HotspotsObj.filter{obj in
            return obj.HotspotDocumentTypeName == identifier
        }
        tableView.reloadData()
        
    }
    
    
}

extension DetailsViewController : UITableViewDelegate , UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if identifier != "All"{
            cell.textLabel?.text = tempHotspot?[indexPath.row].HotspotNo
        }
        else {  cell.textLabel?.text = hotspots.HotspotsObj[indexPath.row].HotspotNo
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return identifier == "All" ? hotspots.HotspotsObj.count : tempHotspot!.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "itemDetailsViewController") as? ItemDetailsViewController else {return}
        
        if identifier != "All"{
            let tempNo = tempHotspot?[indexPath.row].HotspotNo
            request.getDocuments(hotspotNo: tempNo ?? ""){
                
                vc.docsTypes = self.request.docsTypes
                vc.document = self.request.document
                vc.docsTypes.DocumentsObj.insert(DocsObj(DocumentTypeID: "", DocumentTypeName: "All"), at: 0)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else {
            let hotspotNo =  hotspots.HotspotsObj[indexPath.row].HotspotNo
            request.getDocuments(hotspotNo : hotspotNo ){
                
                vc.docsTypes = self.request.docsTypes
                vc.document = self.request.document
                vc.docsTypes.DocumentsObj.insert(DocsObj(DocumentTypeID: "", DocumentTypeName: "All"), at: 0)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    
}
