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
                
                print(first, status!)
                
                if status!
                {
                    let token = userDefault.object(forKey: TOKEN_STRING) as? String
                    
                    LoginWithSocial.getUserInfoSocial(withToken: token!, completion: { (result) in
                        
                        print(result!)
                        
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
                            self.createAlert(user: user)
                            
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
    
    func createAlert(user: GIDGoogleUser)
    {
        let alertInputCode = UIAlertController(title: "Wodule", message: "Please enter a valid code.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            self.loadingShow()
            
            let fNameField = alertInputCode.textFields![0] as UITextField
            guard let text = fNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines), text != "" else {return}
            
            let token = userDefault.object(forKey: TOKEN_STRING) as! String
            
            print(text)
            CodeType.getUniqueCodeInfo(code: text, completion: { (Code) in
                
                print(Code!)
                
                if Code != nil
                {
                    var para = ["_method":"PATCH",
                                "type":Code!.tpye,
                                "organization": Code!.organization,
                                "student_class":Code!.Class,
                                "adviser":Code!.adviser]
                    
                    if user.profile.givenName != nil
                    {
                        para.updateValue(user.profile.givenName, forKey: "first_name")
                    }
                    if user.profile.familyName != nil
                    {
                        para.updateValue(user.profile.familyName, forKey: "last_name")
                    }
                    if user.profile.email != nil
                    {
                        para.updateValue(user.profile.email, forKey: "email")
                    }
                    
                    let header = ["Authorization":"Bearer \(token)"]
                    
                    print("PARA:--->", para)
                    
                    UserInfoAPI.updateUserProfile(para: para, header: header, picture: nil, completion: { (status) in
                        
                        if status
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
                            print("UPDATE FAILED")
                        }
                        
                    })
                }
                else
                {
                    self.alertMissingText(mess: "Code is invalid.", textField: nil)
                }
                
            })
            
            
            
            
        })
        alertInputCode.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "Code"
            textField.textAlignment = .center
        })
        alertInputCode.addAction(cancel)
        alertInputCode.addAction(okAction)
        self.present(alertInputCode, animated: true, completion: nil)
    }
    
}




