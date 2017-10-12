//
//  Extension.swift
//  Wodule
//
//  Created by QTS Coder on 10/2/17.
//  Copyright © 2017 QTS. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

extension UIViewController
{
    
    
    func listFilesFromDocumentsFolder() -> [String]?
    {
        let fileMngr = FileManager.default;
        
        // Full path to documents directory
        let docs = fileMngr.urls(for: .documentDirectory, in: .userDomainMask)[0].path
        
        
        // List all contents of directory and return as [String] OR nil if failed
        return try? fileMngr.contentsOfDirectory(atPath:docs)
        
    }
    
    func uploadRecord(token: String,userID: Int, examID: Int)
    {
        let url  = AudioRecorderManager.shared.getUserDocumentsPath()
        print("File LOcation:", url.path)
        
        if FileManager.default.fileExists(atPath: url.path)
        {
            print("File found and ready to upload")
            print(self.listFilesFromDocumentsFolder()!)
            print(url.appendingPathComponent("Recordedby-\(userID)-forexam-\(examID)").appendingPathExtension("m4a"))
            
            let audioURL = url.appendingPathComponent("Recordedby-\(userID)-forexam-\(examID)").appendingPathExtension("m4a")
            
            let data: Data?
            do
            {
                data = try? Data(contentsOf: audioURL)
            }
            
            ExamRecord.uploadExam(withToken: token, idExam: examID, audiofile: data) { (status:Bool?, result:NSDictionary?) in
                
                if status == true
                {
                    print("UPLOAD DONE\n",result!)
                }
                else
                {
                    print(result as Any)
                }
            }            
        }
        else
        {
            print("No file")
        }
        
    }


    
    func StarRecording(userID: Int, examID: Int, result: (_ audioURL: NSURL?) -> Void)
    {
        
        AudioRecorderManager.shared.recored(fileName: "Recordedby-\(userID)-forexam-\(examID)") { (status:Bool, audioURL:NSURL?) in
            
            if status == true
            {
                print("Did start recording")
                
            }
            else
            {
                print("Error starting recorder")
            }
            
            result(audioURL)

        }
        
        
   
    }
    
    func stopRecord(audioURL:NSURL?)
    {
        AudioRecorderManager.shared.finishRecording()
        
        do
        {
            let data = try? Data(contentsOf: audioURL! as URL)
            
            print("DATA AUDIO SIZE:----->",data as Any)
        }        
        
    }
    
    func loadingShow()
    {
        SVProgressHUD.show()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    func loadingHide()
    {
        SVProgressHUD.dismiss()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func play_pauseAudio(button:UIButton, isPlay:Bool)
    {
        if isPlay
        {
            button.setImage(#imageLiteral(resourceName: "btn_play"), for: .normal)
        }
        else
        {
            button.setImage(#imageLiteral(resourceName: "btn_pause"), for: .normal)
        }
    }
    
    func expand_collapesView(button:UIButton,viewHeight: NSLayoutConstraint,isExpanding: Bool, originalHeight: CGFloat)
    {
        if isExpanding
        {
            button.setBackgroundImage(#imageLiteral(resourceName: "btn_keyup"), for: .normal)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.allowUserInteraction], animations: {
                viewHeight.constant = 10
                self.view.layoutIfNeeded()
            }, completion: nil  )
        }
        else
        {
            button.setBackgroundImage(#imageLiteral(resourceName: "btn_keydown"), for: .normal)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.allowUserInteraction], animations: {
                viewHeight.constant = originalHeight
                self.view.layoutIfNeeded()
            }, completion: nil  )
        }
        
    }
    
    func createAnimatePopup(from mainView: UIView, with backGroundView: UIView)
    {
        
        mainView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        backGroundView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        UIView.animate(withDuration: 0.2, animations: {
            mainView.transform = .identity
            backGroundView.transform = .identity
        }, completion: nil)
        
        backGroundView.backgroundColor = UIColor.black
        backGroundView.alpha = 0.8
        mainView.alpha = 1
        
    }
    
    func checkValidateTextField(tf1: UITextField? ,tf2: UITextField?,tf3: UITextField?,tf4: UITextField?,tf5: UITextField?,tf6: UITextField?) -> Int
    {
        
        if tf1?.text?.characters.count == 0
        {
            return 1
        }
        else if tf2?.text?.characters.count == 0
        {
            return 2
        }
        else if tf3?.text?.characters.count == 0
        {
            return 3
        }
        else if tf4?.text?.characters.count == 0
        {
            return 4
        }
        else if tf5?.text?.characters.count == 0
        {
            return 5
        }
        else if tf6?.text?.characters.count == 0
        {
            return 6
        }
        else
        {
            return 0
            
        }
    }
    
    func alertMissingText(mess: String, textField: UITextField?)
        
    {
        let alert = UIAlertController(title: "Wodule", message: mess, preferredStyle: .alert)
        let btnOK = UIAlertAction(title: "OK", style: .default) { (action) in
            textField?.becomeFirstResponder()
        }
        
        alert.addAction(btnOK)
        self.present(alert, animated: true, completion: nil)
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    
    func calAgeUser(dateString: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateofBirth = dateFormatter.date(from: dateString)
        
        let today = Date()
        let calendar = Calendar.current
        let ageCompoment = calendar.dateComponents([.year], from: dateofBirth!, to: today)
        
        if ageCompoment.year == 0
        {
            return "\(ageCompoment.year! + 1)"
            
        }
        else
        {
            return "\(ageCompoment.year!)"
            
        }
    }
    
    func convertDay(DateString: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let date = dateFormatter.date(from: DateString)!
        dateFormatter.dateFormat = "yy.MM.dd"
        return dateFormatter.string(from: date)
    }



}
