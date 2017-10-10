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
    static func uploadExam(withToken token:String, idExam: Int, audiofile:Data?, completion: @escaping (Bool?, NSDictionary?) -> ())
    {
        let url = URL(string: "http://wodule.io/api/exams/\(idExam)/records")
        
        let httpHeader:HTTPHeaders = ["Authorization":"Bearer \(token)"]

       Alamofire.upload(multipartFormData: { (data) in
        
        let dateformat = DateFormatter()
        dateformat.dateFormat = "MM_dd_YY_hh:mm:ss"
        
        if let datafile = audiofile
        {
            data.append(datafile, withName: "audio", fileName: dateformat.string(from: Date()) + ".wav", mimeType: "audio/wav")
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
                print("PROGRESS UPLOAD:--->", progress.fractionCompleted)
                
            })
            
            upload.responseJSON(completionHandler: { (response) in
                
                print(response.result.value!)
                
            })
        }
        
        
        }
            
    }
}
