//
//  ManageAPI.swift
//  Wodule
//
//  Created by QTS Coder on 10/2/17.
//  Copyright © 2017 QTS. All rights reserved.
//

import Foundation
import Alamofire
import SVProgressHUD


struct CodeType
{
    let id: Int
    let code : String
    let tpye : String
    let organization: String
    let Class: String
    let adviser: String
    
    enum error:Error {
        case missing(String)
    }
    
    init(json:[String: AnyObject]) throws
    {
        guard let code = json["code"] as? String else { throw error.missing("mising")}
        guard let tpye = json["type"] as? String else { throw error.missing("mising")}
        guard let organization = json["organization"] as? String else { throw error.missing("mising")}
        guard let Class = json["class"] as? String else { throw error.missing("mising")}
        guard let adviser = json["adviser"] as? String else { throw error.missing("mising")}
        guard let id = json["id"] as? Int else { throw error.missing("mising")}
        
        self.id = id
        self.code = code
        self.tpye = tpye
        self.organization = organization
        self.Class = Class
        self.adviser = adviser
    }
    
    
    //    static func getAllCodeInfo(completion: @escaping ([CodeType]?) -> ())
    //    {
    //        let url = URL(string: "http://wodule.io/api/code")
    //
    //        Alamofire.request(url!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
    //
    //            var result = [CodeType]()
    //
    //            if response.response?.statusCode == 200
    //            {
    //                let json = response.result.value as? [String: AnyObject]
    //                if let data = json?["data"] as? [[String:AnyObject]]
    //                {
    //                    for item in data
    //                    {
    //                        if let code = try? CodeType(json: item)
    //                        {
    //                            result.append(code)
    //                        }
    //                        else
    //                        {
    //                            result = []
    //                        }
    //                    }
    //
    //                }
    //                else
    //                {
    //                    result = []
    //                }
    //            }
    //            else
    //            {
    //                print(response.response!.statusCode)
    //                result = []
    //            }
    //
    //            completion(result)
    //        }
    //    }
    
    static func getUniqueCodeInfo(code:String, completion: @escaping (CodeType?) -> ())
    {
        let url = URL(string: APIURL.getCodeInfoURL + "/\(code)")
        print(url!)
        
        Alamofire.request(url!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            var result: CodeType?
            
            if response.response?.statusCode == 200
            {
                
                let json = response.result.value as? [[String: AnyObject]]
                
                if json != nil
                {
                    if let data = json?.first
                    {
                        if let code = try? CodeType(json: data)
                        {
                            result = code
                        }
                        else
                        {
                            result = nil
                        }
                        
                    }
                    else
                    {
                        result = nil
                    }
                }
                else
                {
                    result = nil
                }
                
            }
            else
            {
                print(response.response!.statusCode)
                let json = response.result.value as? [String: AnyObject]
                if let error = json?["error"] as? String
                {
                    userDefault.set(error, forKey: NOTIFI_ERROR)
                    userDefault.synchronize()
                }
                result = nil
            }
            
            completion(result)
        }
    }
    
}

struct LoginWithSocial
{
    
    static func LoginUserWithSocial(username: String, password: String, completion: @escaping (Bool?,Bool?) -> ())
    {
        let url = URL(string: APIURL.loginURL)
        let parameter:Parameters = ["user_name": username, "password": password,"social": "true"]
        let httpHeader: HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded"]
        
        Alamofire.request(url!, method: HTTPMethod.post, parameters: parameter, encoding: URLEncoding.httpBody, headers: httpHeader).responseJSON(completionHandler: { (response) in
            
            print("\nSTATUS CODE, RESULT", response.response?.statusCode as Any, response.result)
            
            if response.response?.statusCode == 200
            {
                if let json = response.result.value as? [String: AnyObject]
                {
                    print(json)
                    if let token = json["token"] as? String, let first = json["first"] as? Bool
                    {
                        print("TOKEN:\n-------->", token)
                        userDefault.set(token, forKey: TOKEN_STRING)
                        userDefault.synchronize()
                        
                        completion(first, true)
                    }
                    
                }
            }
            else
            {
                completion(nil, false)
            }
            
        })
        
    }
    
    
    static func getUserInfoSocial(withToken token: String, completion: @escaping (NSDictionary?) -> ())
    {
        let url  = URL(string: APIURL.getProfileURL)
        let httpHeader: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        Alamofire.request(url!, method: HTTPMethod.get, parameters: nil, encoding: URLEncoding.httpBody, headers: httpHeader).responseJSON(completionHandler: { (response) in
            
            var result: NSDictionary?
            
            if response.response?.statusCode == 200
            {
                let json = response.result.value as? [String: AnyObject]
                if let user = json?["user"] as? NSDictionary
                {
                    result = user
                }
                else
                {
                    result = nil
                }
                completion(result)
                
            }
                
            else
            {
                print(response.response!.statusCode)
                completion(nil)
            }
            
        })
        
    }
    
    static func updateUserInfoSocial(userID: Int, para: Parameters, completion: @escaping (Bool?, Int?, NSDictionary?) -> ())
    {
        let url = URL(string: APIURL.updateSocialInfoURL + "/\(userID)")
        
        Alamofire.request(url!, method: .post, parameters: para, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            let json = response.result.value as? NSDictionary
            
            switch response.response!.statusCode
            {
            case 200:
                
                completion(true, response.response?.statusCode, json)
                
            case 400:
                
                completion(false, response.response?.statusCode, json)
            default:
                
                completion(false, response.response?.statusCode, json)

            }
            
        }
    }
    
    
    static func ResetPassword(email: String, completion: @escaping (Bool?, NSDictionary?)->())
    {
        let url = URL(string: "http://wodule.io/api/password/email")
        
        let para:Parameters = ["email": email]
        let header: HTTPHeaders = ["Accept": "application/json"]
        
        Alamofire.request(url!, method: .post, parameters: para, encoding: URLEncoding.default, headers: header).responseJSON { (response) in
            
            let json = response.result.value as? NSDictionary
            let code = response.response?.statusCode
            
            if response.result.isSuccess
            {
                if code == 200
                {
                    guard let data = json?["data"] as? NSDictionary, let token = data["token"] as? String else {return}
                    
                    userDefault.set(token, forKey: TOKENRESET_STRING)
                    userDefault.synchronize()
                    
                    completion(true, json)
                }
                else
                {
                    completion(false, json)
                }
            }
            else
            {
                completion(false, json)
            }
        }
    }
    
}

struct UserInfoAPI
{
    
    let id:Int
    let role_id: Int
    let first_name:String
    let middle_name: String
    let last_name: String
    let date_of_birth: String
    let country_of_birth:String
    let city:String
    let country:String
    let telephone: String
    let nationality:String
    let status: String
    let gender: String
    let user_name:String
    let email: String
    let type: String
    let picture: String
    let organization: String
    let student_class:String
    let adviser: String
    let ln_first:String?
    let native_name:String?
    let suffix:String?
    let address:String?
    let ethnicity:String?
    let religion:String?
    
    enum error:Error {
        case missing(String)
    }
    
    init(json:[String: AnyObject], ln_first:String?,native_name:String?,suffix:String?,address:String?,ethnicity:String?,religion:String?) throws
    {
        guard let id = json["id"] as? Int else { throw error.missing("mising")}
        guard let role_id = json["role_id"] as? Int else { throw error.missing("mising")}
        guard let first_name = json["first_name"] as? String else {throw error.missing("mising")}
        guard let middle_name = json["middle_name"] as? String else {throw error.missing("mising")}
        guard let last_name = json["last_name"] as? String else {throw error.missing("mising")}
        guard let date_of_birth = json["date_of_birth"] as? String else {throw error.missing("mising")}
        guard let country_of_birth = json["country_of_birth"] as? String else {throw error.missing("mising")}
        guard let city = json["city"] as? String else {throw error.missing("mising")}
        guard let country = json["country"] as? String else {throw error.missing("mising")}
        guard let telephone = json["telephone"] as? String else {throw error.missing("mising")}
        guard let nationality = json["nationality"] as? String else {throw error.missing("mising")}
        guard let status = json["status"] as? String else {throw error.missing("mising")}
        guard let gender = json["gender"] as? String else {throw error.missing("mising")}
        guard let user_name = json["user_name"] as? String else {throw error.missing("mising")}
        guard let email = json["email"] as? String else {throw error.missing("mising")}
        guard let type = json["type"] as? String else {throw error.missing("mising")}
        guard let picture = json["picture"] as? String else {throw error.missing("mising")}
        guard let organization = json["organization"] as? String else {throw error.missing("mising")}
        guard let student_class = json["student_class"] as? String else {throw error.missing("mising")}
        guard let adviser = json["adviser"] as? String else {throw error.missing("mising")}
        
        self.id = id
        self.role_id = role_id
        self.first_name = first_name
        self.middle_name = middle_name
        self.last_name = last_name
        self.date_of_birth = date_of_birth
        self.country_of_birth = country_of_birth
        self.city = city
        self.country = country
        self.telephone = telephone
        self.nationality = nationality
        self.status = status
        self.gender = gender
        self.user_name = user_name
        self.email = email
        self.type = type
        self.picture = picture
        self.organization = organization
        self.student_class = student_class
        self.adviser = adviser
        self.ln_first = ln_first
        self.native_name = native_name
        self.suffix = suffix
        self.address = address
        self.ethnicity = ethnicity
        self.religion = religion
        
    }
    
    static func getUserInfo(withToken token: String,completion: @escaping (NSDictionary?) -> ())
    {
        let url  = URL(string: APIURL.getProfileURL)
        let httpHeader: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        Alamofire.request(url!, method: HTTPMethod.get, parameters: nil, encoding: URLEncoding.httpBody, headers: httpHeader).responseJSON(completionHandler: { (response) in
            
            var result: NSDictionary?
            
            if response.response?.statusCode == 200
            {
                let json = response.result.value as? NSDictionary
                if let user = json?["user"] as? NSDictionary
                {
                    result = user
                    
                }
                else
                {
                    result = nil
                }
                completion(result)
                
            }
            
        })
        
    }
    
    static func LoginUser(username: String, password: String, completion: @escaping (Bool?) -> ())
    {
        let url = URL(string: APIURL.loginURL)
        let parameter:Parameters = ["user_name": username, "password": password]
        let httpHeader: HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded"]
        
        Alamofire.request(url!, method: HTTPMethod.post, parameters: parameter, encoding: URLEncoding.httpBody, headers: httpHeader).responseJSON(completionHandler: { (response) in
            
            var status:Bool?
            
            print("\n STATUS CODE, RESULT", response.response!.statusCode, response.result.description)
            
            if response.response?.statusCode == 200
            {
                if let json = response.result.value as? [String: String]
                {
                    if let token = json["token"]
                    {
                        status = true
                        print("TOKEN:\n -------->", token)
                        userDefault.set(token, forKey: TOKEN_STRING)
                        userDefault.synchronize()
                        
                    }
                    
                }
            }
            else
            {
                status = false
            }
            completion(status)
        })
        
    }
    
    static func RegisterUser(para: Parameters, picture: Data?, completion: @escaping (Bool) -> ())
    {
        let url = URL(string: APIURL.registerURL)
        
        Alamofire.upload(multipartFormData: { (data) in
            
            let dateformat = DateFormatter()
            dateformat.dateFormat = "MM_dd_YY_hh:mm:ss"
            
            if let imageData = picture
            {
                data.append(imageData, withName: "picture", fileName: dateformat.string(from: Date()) + ".jpg", mimeType: "image/jpg")
            }
                
            else{
                print("\nPICTURE DATA:------>", picture as Any)
            }
            
            for (key, value) in para {
                data.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
                
            }
            
        }, usingThreshold: 1, to: url!, method: HTTPMethod.post, headers: nil) { (result) in
            
            switch result
            {
            case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                upload.uploadProgress(closure: { (progress) in
                    
                    print("PROGRESS:->",progress.fractionCompleted)
                    
                })
                
                upload.responseJSON(completionHandler: { (response) in
                    
                    let json = response.result.value as? [String:AnyObject]
                    print("\nJSON DATA:\n---->", json!)
                    
                    
                    if let token = json?["token"] as? String
                    {
                        
                        userDefault.set(token, forKey: TOKEN_STRING)
                        userDefault.synchronize()
                        completion(true)
                        
                    }
                    else if let error = json?["error"] as? String
                    {
                        print("\nERROR MESSAGE:------>" ,error)
                        userDefault.set(error, forKey: NOTIFI_ERROR)
                        userDefault.synchronize()
                        completion(false)
                    }
                    else
                    {
                        if response.description.contains("Invalid code")
                        {
                            userDefault.set("Invalid code", forKey: NOTIFI_ERROR)
                            userDefault.synchronize()
                            completion(false)
                        }
                        
                    }
                    
                })
                
            case .failure(let error):
                print(error.localizedDescription)
                let errorString = "Failure while requesting your infomation. Please try again."
                userDefault.set(errorString, forKey: NOTIFI_ERROR)
                userDefault.synchronize()
                completion(false)
                
            }
            
        }
    }
    
    
    static func updateUserProfile(para: Parameters,header: HTTPHeaders,picture: Data?, completion: @escaping (Bool,Int?,NSDictionary?) -> ())
    {
        let url = URL(string: APIURL.updateProfileURL)
        
        Alamofire.upload(multipartFormData: { (data) in
            
                        
            let dateformat = DateFormatter()
            dateformat.dateFormat = "MM_DD_YY_hh_mm_ss"
            
            let fileURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(dateformat.string(from: Date())).appendingPathExtension("jpg")
            
            if FileManager.default.fileExists(atPath: "\(fileURL!)")
            {
                do {
                    try picture?.write(to: fileURL!, options: .atomic)
                    
                } catch {
                    
                }
                
                data.append(fileURL!, withName: "picture")
                
            }
            else
            {
            }
            
            for (key, value) in para {
                
                data.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
                
            }
            
        }, usingThreshold: 1, to: url!, method: HTTPMethod.post, headers: header) { (result) in
            
            switch result
            {
            case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                
                upload.uploadProgress(closure: { (progress) in
                    
                    print("PROGRESS:->",progress.fractionCompleted)
                    
                })
                
                upload.responseJSON(completionHandler: { (response) in
                    
                    guard let json = response.result.value as? NSDictionary else { return }
                    
                    print(response.result)
                    print(json)
                    if response.response?.statusCode == 200
                    {
                        completion(true, response.response?.statusCode, json)
                    }
                    else
                    {
                        completion(false, response.response?.statusCode, json)
                    }

                })
                
                
            case . failure(let error):
                print(error.localizedDescription)
                completion(false, nil, nil)
            }
            
            
        }
    }
}

struct Categories
{
    let identifier:Int
    let status: String
    let subject: String
    let details: String
    let creationDate: String
    let lastChange: String
    
    enum error:Error {
        case missing(String)
    }
    
    init(json: [String: AnyObject]) throws {
        
        guard let identifier = json["identifier"] as? Int else { throw error.missing("missing value") }
        guard let details = json["details"] as? String else { throw error.missing("missing value") }
        guard let status = json["status"] as? String else { throw error.missing("missing value") }
        guard let subject = json["subject"] as? String else { throw error.missing("missing value") }
        guard let creationDate = json["creationDate"] as? String else { throw error.missing("missing value") }
        guard let lastChange = json["lastChange"] as? String else { throw error.missing("missing value") }
        
        self.identifier = identifier
        self.details = details
        self.status = status
        self.subject = subject
        self.creationDate = creationDate
        self.lastChange = lastChange
        
    }
    
    
    static func getAllCategory(withToken token:String, completion: @escaping (Bool?,[Categories]?) -> ())
    {
        let url = URL(string: APIURL.categoriesURL)
        let httpHeader:HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        Alamofire.request(url!, method: HTTPMethod.get, parameters: nil, encoding: URLEncoding.httpBody, headers: httpHeader).responseJSON { (response) in
            
            var result = [Categories]()
            
            print("RESPONSE:---->\n",response.description)
            print("RESPONSE:---->\n",(response.response?.statusCode)!)
            
            if response.response?.statusCode == 200
            {
                let json = response.result.value as? [String: AnyObject]
                if let jsonData  = json?["data"] as? [[String: AnyObject]]
                {
                    for item in jsonData
                    {
                        if let category = try? Categories(json: item)
                        {
                            result.append(category)
                        }
                        else
                        {
                            result = []
                            completion(false,result)
                            
                        }
                    }
                    completion(true,result)
                }
            }
            else
            {
                result = []
                completion(false,result)
                
            }
            
            
        }
    }
    
}

struct CategoriesExam
{
    let number:Int
    let identifier:Int
    let questioner: String?
    let photo:String?
    let detail: String
    let score: Int
    let subject: Int
    let admin: Int
    let creationDate: String
    let lastChange: String
    
    enum error:Error {
        case missing(String)
    }
    
    init(json: [String: AnyObject],questioner:String?, photo: String? ) throws {
        
        guard let number = json["number"] as? Int else { throw error.missing("missing value") }
        guard let identifier = json["identifier"] as? Int else { throw error.missing("missing value") }
        guard let detail = json["detail"] as? String else { throw error.missing("missing value") }
        guard let score = json["score"] as? Int else { throw error.missing("missing value") }
        guard let subject = json["subject"] as? Int else { throw error.missing("missing value") }
        guard let admin = json["admin"] as? Int else { throw error.missing("missing value") }
        guard let creationDate = json["creationDate"] as? String else { throw error.missing("missing value") }
        guard let lastChange = json["lastChange"] as? String else { throw error.missing("missing value") }
        
        self.number = number
        self.identifier = identifier
        self.questioner = questioner
        self.photo = photo
        self.detail = detail
        self.score = score
        self.subject = subject
        self.admin = admin
        self.creationDate = creationDate
        self.lastChange = lastChange
        
    }
    
    static func getExam(categoryID: Int, completion: @escaping ([CategoriesExam]?) -> ())
    {
        let url = URL(string: "http://wodule.io/api/category/\(categoryID)/exams")
        
        Alamofire.request(url!, method: HTTPMethod.get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            var result = [CategoriesExam]()
            
            print((response.response?.description)!)
            
            let json = response.result.value as? [String: AnyObject]
            if response.response?.statusCode == 200
            {
                if let jsonData  = json?["data"] as? [[String: AnyObject]]
                {
                    for item in jsonData
                    {
                        let questioner = item["questioner"] as? String ?? nil
                        let photo = item["photo"] as? String ?? nil
                        if let exam = try? CategoriesExam(json: item, questioner: questioner, photo: photo)
                        {
                            result.append(exam)
                        }
                        else
                        {
                            result = []
                        }
                    }
                }
            }
            else
            {
                if let errorCode = json?["code"] as? Int
                {
                    userDefault.set(errorCode, forKey: NOTIFI_ERROR)
                    userDefault.synchronize()
                }
                result = []
            }
            
            completion(result)
            
        }
    }
    
}

struct AssesmentHistory
{
    let identifier: Int
    let audio: String
    let exam: String
    let score: Int
    let comment:String
    let examCategory: String
    let examDetails: String
    let examQuestionaire: String
    let examinee:Int
    let creationDate: String
    let lastChange: String
    let links:[[String:AnyObject]]
    
    enum error:Error {
        case missing(String)
    }
    
    
    init(json: [String: AnyObject]) throws {
        
        guard let identifier = json["identifier"] as? Int else { throw error.missing("missing value") }
        guard let audio = json["audio"] as? String else { throw error.missing("missing value") }
        guard let exam = json["exam"] as? String else { throw error.missing("missing value") }
        guard let score = json["score"] as? Int else { throw error.missing("missing value") }
        guard let comment = json["comment"] as? String else { throw error.missing("missing value") }
        guard let examCategory = json["examCategory"] as? String else { throw error.missing("missing value") }
        guard let examDetails = json["examDetails"] as? String else { throw error.missing("missing value") }
        guard let examQuestionaire = json["examQuestionaire"] as? String else { throw error.missing("missing value") }
        guard let examinee = json["examinee"] as? Int else { throw error.missing("missing value") }
        guard let creationDate = json["creationDate"] as? String else { throw error.missing("missing value") }
        guard let lastChange = json["lastChange"] as? String else { throw error.missing("missing value") }
        guard let links = json["links"] as? [[String:AnyObject]] else { throw error.missing("missing value") }
        
        self.identifier = identifier
        self.audio = audio
        self.exam = exam
        self.score = score
        self.comment = comment
        self.examCategory = examCategory
        self.examDetails = examDetails
        self.examQuestionaire = examQuestionaire
        self.examinee = examinee
        self.creationDate = creationDate
        self.lastChange = lastChange
        self.links = links
        
    }
    
    static func getUserHistory(withToken token: String, userID: Int,page: Int, completion: @escaping (Bool?,AnyObject?,[AssesmentHistory]?,Int?) -> ())
    {
        let url = URL(string: "http://wodule.io/api/users/\(userID)/records?page=\(page)")
        let httpHeader:HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        Alamofire.request(url!, method: HTTPMethod.get, parameters: nil, encoding: URLEncoding.httpBody, headers: httpHeader).responseJSON { (response) in
            
            var result = [AssesmentHistory]()
            
            if response.response?.statusCode == 200
            {
                let json = response.result.value as? [String:AnyObject]
                print("JSON",json)
                if let data = json?["data"] as? [[String:AnyObject]]
                {
                    print("DATA",data)
                    if data.count != 0
                    {
                        guard let meta = json?["meta"] as? NSDictionary, let pagination = meta["pagination"] as? NSDictionary, let total_pages = pagination["total_pages"] as? Int else {return}
                        
                        for item in data
                        {
                            if let history = try? AssesmentHistory(json: item)
                            {
                                result.append(history)
                            }
                        }
                        completion(true,nil, result, total_pages)
                    }
                    else
                    {
                        result = []
                        completion(true,nil, result, 1)
                    }
                    
                }
                else
                {
                    result = []
                    
                    completion(false,response.result.value as? NSDictionary , result, 1)
                }
            }
            else if response.response?.statusCode == 401
            {
                result = []
                completion(false,response.result.value as? NSDictionary, result, 1)
                
            }
            else
            {
                result = []
                completion(false,response.result.value as? NSDictionary, result, 1)
                
            }
            
        }
        
    }
}





















