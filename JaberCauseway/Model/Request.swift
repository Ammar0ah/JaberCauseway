//
//  Request.swift
//  JaberCauseway
//
//  Created by Ammar Al-Helali on 8/12/19.
//  Copyright © 2019 Ammar Al-Helali. All rights reserved.
//

import Foundation
import Alamofire
/* Disciplines */
struct Discipline : Decodable {
    var Description = ""
    var DisciplinesObj : [DisciplinesObject]
    var ResultResponse = ""
}

struct DisciplinesObject : Decodable{
    var DisciplineID = ""
    var DisciplineName = ""
}

/* Hotspots */
struct Hotspot : Decodable {
    var Description = ""
    var HotspotsObj : [HotspotObject]
    var ResultResponse = ""
}

struct HotspotObject : Decodable {
    var HotspotDocumentTypeID : String
    var HotspotDocumentTypeName : String
    var HotspotNo : String
}

/* Documents */
struct Documents : Decodable {
    var Description : String
    var DocumentsObj : [DocumentObject]
    var ResultResponse : String
}
struct DocumentObject : Decodable{
    var DocumentDisciplineID : String
    var DocumentFileType : String
    var DocumentID : String
    var DocumentNo : String
    var DocumentPath : String
    var DocumentTitle : String
}

struct DocumentTypes : Decodable {
    var Description : String
    var DocumentsObj : [DocsObj]
    var ResultResponse : String
}
struct DocsObj : Decodable {
    var DocumentTypeID : String
    var DocumentTypeName : String
}



class Request {
    let WsUsername = "pen2019"
    let WsPassword = "pen2019"
    var discipline : Discipline?
    var hotspot : Hotspot?
    var document : Documents?
    var docsTypes : DocumentTypes?
    let device = Device()
    private var params = Dictionary<String , Any>()
    
    var hotspotCount : Int {
      return   hotspot!.HotspotsObj.count
    
    }
    var disciplineCount : Int {
        return discipline!.DisciplinesObj.count
    }
    var docsCount : Int {
        return document!.DocumentsObj.count
    }
   
    
    init() {
        params["WsUsername"]  = WsUsername
        params["WsPassword"] = WsPassword
        params["device"] =  device.serializeDevice()
    }
    
    func getDisciplines(completion: @escaping () -> ()) {
        Alamofire.request(GET_DISCIPLINES, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { (response) in
                
                do {
                    self.discipline =  try JSONDecoder().decode(Discipline.self, from: response.data!)
                    completion()
                }
                catch {}
        }
    }
    
    func getHotspots(hotspotGroup : String , hotspotNo:String,completion: @escaping ()->() ){
        params["HotspotGroupNo"] = hotspotGroup
        params["HotspotNO"] = hotspotNo
        
        Alamofire.request(GET_HOTSPOTS, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil)
            .responseJSON{ (response) in
                if response.result.isSuccess{
                do {
                    
                    self.hotspot = try JSONDecoder().decode(Hotspot.self, from: response.data!)
                    self.getDisciplines {
                        completion()
                    }
                }
                catch {print("Hotspot Decoding error")}
                }
                
        }
    }
    func getDocuments(hotspotNo : String,completion: @escaping () -> ()){
        params["HotspotNo"] = hotspotNo
        
        Alamofire.request(GET_DOCUMENTS, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { (response) in
                if response.result.isSuccess{
                    do{
                        self.document = try JSONDecoder().decode(Documents.self, from: response.data!)
                
                        self.getDocsTypes {
                            completion()
                        }
                    }
                    catch{
                        print("Documents Decoding Error")
                    }
                }
                
        }
        
    }
    func getDocsTypes(completion: @escaping () -> ()){
        Alamofire.request(GET_DOCS_TYPES, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil)
            .responseJSON{ response in
                switch response.result {
                case .success(_):
                    do {
                        self.docsTypes = try JSONDecoder().decode(DocumentTypes.self, from: response.data!)
                        print(self.docsTypes!)
                        completion()
                    }catch{
                        print("Docs types decoding Error")
                    }
                    
                break
                case .failure(let error):
                    print(error)
                }
        }
    }
    
}
