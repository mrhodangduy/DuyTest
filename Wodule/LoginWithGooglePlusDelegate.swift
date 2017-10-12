//
//  LoginWithGooglePlusDelegate.swift
//  Wodule
//
//  Created by QTS Coder on 10/9/17.
//  Copyright © 2017 QTS. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


extension LoginVC : GIDSignInDelegate, GIDSignInUIDelegate
{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        loadingShow()
        if (error == nil) {
            
            print(user.profile.imageURL(withDimension: 500))
            
            let username  = "u03" + user.userID
            let password = "google"
            
            LoginWithSocial.LoginUserWithSocial(username: username, password: password, completion: { (first, status) in
                
                
                if status!
                {
                    
                    let token = userDefault.object(forKey: TOKEN_STRING) as? String
                    
                    LoginWithSocial.getUserInfoSocial(withToken: token!, completion: { (result) in
                        
                        print(result!)
                        
                        guard let userID = result?["id"] as? Int else { return }
                        if result!["type"] as? String == UserType.assessor.rawValue
                        {
                            let assessor_homeVC = UIStoryboard(name: ASSESSOR_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "assessor_homeVC") as! Assessor_HomeVC
                            
                            assessor_homeVC.userInfomation = result
                            assessor_homeVC.socialAvatar = user.profile.imageURL(withDimension: 500)
                            userDefault.set(GOOGLELOGIN, forKey: SOCIALKEY)
                            userDefault.synchronize()
                            
                            self.navigationController?.pushViewController(assessor_homeVC, animated: true)
                                                    }
                        else if result!["type"] as? String == UserType.examinee.rawValue
                        {
                            let examiner_homeVC = UIStoryboard(name: EXAMINEE_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "examiner_homeVC") as! Examiner_HomeVC
                            
                            examiner_homeVC.userInfomation = result
                            examiner_homeVC.socialAvatar = user.profile.imageURL(withDimension: 500)
                            userDefault.set(GOOGLELOGIN, forKey: SOCIALKEY)
                            userDefault.synchronize()
                            
                            self.navigationController?.pushViewController(examiner_homeVC, animated: true)
                            
                        }
                        else
                        {
                            print("Missing Code")
                            self.createAlertGPlus(user: user, password: password, userID: userID)
                            
                        }
                        
                        DispatchQueue.main.async {
                            self.loadingHide()
                        }
                        
                    })
                    
                }
            })
            
        } else {
            
            print("\(error.localizedDescription)")
            DispatchQueue.main.async {
                self.loadingHide()
            }
            
        }
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("Disconnect")
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        
        present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func createAlertGPlus(user: GIDGoogleUser, password: String, userID: Int)
    {
        let alertInputCode = UIAlertController(title: "Wodule", message: "Please enter a valid code.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.alertMissingText(mess: "Login failed.", textField: nil)
        }
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            self.loadingShow()
            
            DispatchQueue.global(qos: .default).async(execute: {
                let fNameField = alertInputCode.textFields![0] as UITextField
                
                if fNameField.text?.characters.count == 0
                {
                    self.loadingHide()
                    self.alertMissingText(mess: "Code is invalid. Login failed", textField: nil)
                }
                else
                {
                    guard let text = fNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines), text != "" else {return}
                    
                    let token = userDefault.object(forKey: TOKEN_STRING) as! String
                    
                    CodeType.getUniqueCodeInfo(code: text, completion: { (Code) in
                        
                        if Code != nil
                        {
                            var para = ["code":Code!.code,
                                        "password": password]
                            
                            if user.profile.givenName != nil
                            {
                                para.updateValue(user.profile.givenName, forKey: "first_name")
                            }
                            if user.profile.familyName != nil
                            {
                                para.updateValue(user.profile.familyName, forKey: "last_name")
                            }
                            
                            print("PARA:--->", para)
                            
                            LoginWithSocial.updateUserInfoSocial(userID: userID, para: para, completion: { (status:Bool?, code:Int?, data:NSDictionary?) in
                                
                                if status == true
                                {
                                    LoginWithSocial.getUserInfoSocial(withToken: token, completion: { (result) in
                                        
                                        if result!["type"] as? String == UserType.assessor.rawValue
                                        {
                                            print(UserType.assessor.rawValue)
                                            let assessor_homeVC = UIStoryboard(name: ASSESSOR_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "assessor_homeVC") as! Assessor_HomeVC
                                            
                                            assessor_homeVC.userInfomation = result!
                                            assessor_homeVC.socialAvatar = user.profile.imageURL(withDimension: 500)
                                            userDefault.set(GOOGLELOGIN, forKey: SOCIALKEY)
                                            userDefault.synchronize()
                                            
                                            self.navigationController?.pushViewController(assessor_homeVC, animated: true)
                                            
                                        }
                                        else
                                        {
                                            print(UserType.examinee.rawValue)
                                            let examiner_homeVC = UIStoryboard(name: EXAMINEE_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "examiner_homeVC") as! Examiner_HomeVC
                                            
                                            examiner_homeVC.userInfomation = result!
                                            examiner_homeVC.socialAvatar = user.profile.imageURL(withDimension: 500)
                                            userDefault.set(GOOGLELOGIN, forKey: SOCIALKEY)
                                            userDefault.synchronize()
                                            
                                            self.navigationController?.pushViewController(examiner_homeVC, animated: true)
                                        }
                                        DispatchQueue.main.async {
                                            self.loadingHide()
                                        }
                                    })
                                }
                                else
                                {
                                    DispatchQueue.main.async {
                                        guard let result = data else {return}
                                        self.loadingHide()
                                        self.alertMissingText(mess: result["error"] as! String, textField: nil)
                                        
                                    }
                                    
                                }
                            })
                        }
                            
                        else
                        {
                            DispatchQueue.main.async {
                                self.loadingHide()
                                self.alertMissingText(mess: "Code is invalid. Login failed.", textField: nil)
                                
                            }
                        }
                        
                    })
                }
            })
   
        })
        alertInputCode.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "Input Code"
            textField.textAlignment = .center
        })
        alertInputCode.addAction(cancel)
        alertInputCode.addAction(okAction)
        self.present(alertInputCode, animated: true, completion: nil)
    }
    
}




