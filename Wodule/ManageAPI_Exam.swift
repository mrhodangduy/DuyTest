//
//  ManageAPI_Exam.swift
//  Wodule
//
//  Created by QTS Coder on 10/10/17.
//  Copyright © 2017 QTS. All rights reserved.
//

import Foundation
import Alamofire


struct ExamRecord
{
    static func uploadExam(withToken token:String, idExam: Int, audiofile: Data?, completion: @escaping (Bool?, NSDictionary?) -> ())
    {
        let url = URL(string: "http://wodule.io/api/exams/\(idExam)/records")
        
        let httpHeader:HTTPHeaders = ["Authorization":"Bearer \(token)"]

       Alamofire.upload(multipartFormData: { (data) in
        
        let dateformat = DateFormatter()
        dateformat.dateFormat = "MM_dd_YY_hh_mm_ss"
        
//        let uploadPath = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(dateformat.string(from: Date())).appendingPathExtension("m4a")
        
        
        if let audioURL = audiofile
        {
//            try? audioURL.write(to: uploadPath!, options: Data.WritingOptions.atomic)
//            data.append(uploadPath!, withName: "audio")
            print("\n\nAUDIODATA-->",audioURL)
            data.append(audioURL, withName: "audio", fileName: "upload.m4a", mimeType: "audio/m4a")
            print(data.boundary)
        }
        else
        {
            completion(false, nil)
        }
        
        
       }, usingThreshold: 1, to: url!, method: .post, headers: httpHeader) { (results) in
        
        switch results
        {
        case .failure(let error):
            print(error.localizedDescription)
            let errorString = "Failure while requesting your infomation. Please try again."
            userDefault.set(errorString, forKey: NOTIFI_ERROR)
            userDefault.synchronize()
            completion(false, nil)
            
        case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
            
            upload.uploadProgress(closure: { (progress) in
                print("PROGRESS UPLOAD:--->", (progress.fractionCompleted * 100))
                
            })
            
            upload.responseJSON(completionHandler: { (response) in
                
                guard let json = response.result.value as? NSDictionary else {return}
                print(json)
                
                if response.result.isSuccess
                {
                    if response.response?.statusCode == 200
                    {
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
                                
            })
        }
        
        
        }
            
    }
    
    static func getAllRecord(page: Int, completion: @escaping ([NSDictionary]?, _ totalPage: Int?) -> ())
    {
        let url = URL(string: APIURL.getAllrecordURL + "\(page)")
        
        Alamofire.request(url!).responseJSON { (response) in
            
            if response.result.isSuccess
            {
                let json = response.result.value as? NSDictionary
                if let data = json?["data"] as? Array<NSDictionary>
                {
                    guard let meta = json?["meta"] as? NSDictionary, let pagination = meta["pagination"] as? NSDictionary, let total_pages = pagination["total_pages"] as? Int else {return}
                    
                    completion(data, total_pages)
                    
                }
                else
                {
                    completion(nil, nil)
                }
            }
            else
            {
                completion(nil, nil)
            }
            
        }
    }
    
    static func postGrade(withToken token: String, identifier:Int, grade: Int,comment:String, completion: @escaping (Bool?, Int?, NSDictionary?) -> ())
    {
        let url = URL(string: APIURL.baseURL + "/records/" + "\(identifier)" + "/grades")
        let httpHeader:HTTPHeaders = ["Authorization":"Bearer \(token)"]
        let para: Parameters = ["grade": "\(grade)",
                                "comment": comment]
        
        Alamofire.request(url!, method: .post, parameters: para, encoding: URLEncoding.default, headers: httpHeader).responseJSON { (response) in
            
            guard let json = response.result.value as? NSDictionary else {return}
            let code = response.response!.statusCode
            
            if response.result.isSuccess
            {
                if response.response?.statusCode == 200
                {
                    completion(true, code, json)
                }
                else
                
                {
                    completion(false, code, json)
                }
            }
            else
            {
                completion(false, code, json)
            }
            
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
        
}
