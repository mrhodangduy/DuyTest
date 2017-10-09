//
//  ViewController.swift
//  Wodule
//
//  Created by QTS Coder on 10/2/17.
//  Copyright © 2017 QTS. All rights reserved.
//

import UIKit
import SVProgressHUD

class LoginVC: UIViewController {

    @IBOutlet weak var tf_Username: UITextField!
    @IBOutlet weak var tf_Password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        super.navigationController?.isNavigationBarHidden = true
    }

    
    @IBAction func facebookBtnTap(_ sender: Any) {
    }
    
    @IBAction func instargramBtnTap(_ sender: Any) {
    }
    
    @IBAction func googlePlusBtnTap(_ sender: Any) {
    }

    @IBAction func submitBtnTap(_ sender: Any) {
        
        let checkey = checkValidateTextField(tf1: tf_Username, tf2: tf_Password, tf3: nil, tf4: nil, tf5: nil, tf6: nil)
        
        switch checkey {
        case 1:
            self.alertMissingText(mess: "Email is required", textField: tf_Username)
        case 2:
            self.alertMissingText(mess: "Password is required", textField: tf_Password)

        default:
            
            if (tf_Password.text?.characters.count)! < 6
            {
                self.alertMissingText(mess: "Password must be greater than 6 digits", textField: tf_Password)
            }
            else
            {
                self.view.endEditing(true)
                loadingShow()
                DispatchQueue.global(qos: .default).async(execute: { 
                    UserInfoAPI.LoginUser(username: self.tf_Username.text!, password: self.tf_Password.text!, completion: { (status) in
                        
                        if status != nil && status!
                        {                            
                            let token = userDefault.object(forKey: TOKEN_STRING) as? String
                            
                            UserInfoAPI.getUserProfile(withToken: token!, completion: { (userinfo) in
                                
                                if userinfo?.type == UserType.assessor.rawValue
                                {
                                    let assessor_homeVC = UIStoryboard(name: ASSESSOR_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "assessor_homeVC") as! Assessor_HomeVC
                                    
                                    assessor_homeVC.userInfo = userinfo
                                    
                                    self.navigationController?.pushViewController(assessor_homeVC, animated: true)
                                }
                                else
                                {
                                    let examiner_homeVC = UIStoryboard(name: EXAMINEE_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "examiner_homeVC") as! Examiner_HomeVC
                                    
                                    examiner_homeVC.userInfo = userinfo
                                    
                                    self.navigationController?.pushViewController(examiner_homeVC, animated: true)
                                }
                                print("-----> LOGIN SUCCESSFUL")
                                DispatchQueue.main.async(execute: { 
                                    self.loadingHide()
                                })
                                
                            })
                            
                        }
                        else
                        {
                            DispatchQueue.main.async(execute: { 
                                self.loadingHide()
                                print("-----> LOGIN FALED")
                                self.alertMissingText(mess: "Username or Password is not correct. Try again.", textField: nil)
                            })
                            
                            
                        }
                        
                    })
                })
                
            }
            
        }
    }
    
    @IBAction func register_newuserBtnTap(_ sender: Any) {
        
        let newuser = UIStoryboard(name: MAIN_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "newuser_page1VC") as! NewUser_Page1VC
        self.navigationController?.pushViewController(newuser, animated: true)
        
    }
    
    @IBAction func forgotPasswordTap(_ sender: Any) {
        
        let forgotpassVC = UIStoryboard(name: MAIN_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "forgotpassVC") as! ForgotPasswordVC
        self.present(forgotpassVC, animated: true, completion: nil)
    }

    @IBAction func licenseBtnTap(_ sender: Any) {
        
        let licenseVC = UIStoryboard(name: MAIN_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "licenseVC") as! LicenseVC
        self.navigationController?.pushViewController(licenseVC, animated: true)
        
    }
}

