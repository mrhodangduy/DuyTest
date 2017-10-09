//
//  ViewController.swift
//  Wodule
//
//  Created by QTS Coder on 10/2/17.
//  Copyright © 2017 QTS. All rights reserved.
//

import UIKit
import SVProgressHUD
import GoogleSignIn
import FacebookLogin
import FBSDKLoginKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var tf_Username: UITextField!
    @IBOutlet weak var tf_Password: UITextField!
    
    var codeType = [CodeType]()
    var dict : [String : AnyObject]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        super.navigationController?.isNavigationBarHidden = true
    }
    
    
    @IBAction func facebookBtnTap(_ sender: Any) {
        
        let loginManager = LoginManager()
        loginManager.logIn([ .publicProfile, .email, .userFriends ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success( _, _, let accessToken):
                
                print(accessToken)
                self.loadingShow()
                self.getFBUserData()
                
                
            }
        }
        
    }
    
    //function is fetching the user data
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(square), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                    print(self.dict)
                    
                    let username  = "u01" + (self.dict["id"] as? String)!
                    let password = "facebook"
                    let id = self.dict["id"] as? String
                    let avatar = "https://graph.facebook.com/\(id!)/picture?width=500&height=500"
                    
                    
                    LoginWithSocial.LoginUserWithSocial(username: username, password: password, completion: { (first, status) in
                        
                        if status!
                        {
                            let token = userDefault.object(forKey: TOKEN_STRING) as? String
                            LoginWithSocial.getUserInfoSocial(withToken: token!, completion: { (result) in
                                
                                print(result!)
                                
                                if result!["type"] as? String == UserType.assessor.rawValue
                                {
                                    let assessor_homeVC = UIStoryboard(name: ASSESSOR_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "assessor_homeVC") as! Assessor_HomeVC
                                    
                                    assessor_homeVC.userInfomation = result
                                    assessor_homeVC.socialAvatar = URL(string: avatar)
                                    userDefault.set(FACEBOOKLOGIN, forKey: SOCIALKEY)
                                    userDefault.synchronize()
                                    
                                    self.navigationController?.pushViewController(assessor_homeVC, animated: true)
                                }
                                else if result!["type"] as? String == UserType.examinee.rawValue
                                {
                                    let examiner_homeVC = UIStoryboard(name: EXAMINEE_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "examiner_homeVC") as! Examiner_HomeVC
                                    
                                    examiner_homeVC.userInfomation = result
                                    examiner_homeVC.socialAvatar = URL(string: avatar)
                                    userDefault.set(FACEBOOKLOGIN, forKey: SOCIALKEY)
                                    userDefault.synchronize()
                                    self.navigationController?.pushViewController(examiner_homeVC, animated: true)
                                    
                                }
                                else
                                {
                                    print("Missing Code")
                                    self.createAlert(user: self.dict, avatarLink: avatar)
                                    
                                }
                                
                                DispatchQueue.main.async {
                                    self.loadingHide()
                                }
                                
                            })
                            
                        }
                        else
                        {
                            DispatchQueue.main.async {
                                self.loadingHide()
                                
                            }
                        }
                        
                    })
                    
                }
            })
        }
    }
    
    
    func createAlert(user: [String: AnyObject], avatarLink: String)
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
                    
                    if user["name"] as? String != nil
                    {
                        para.updateValue(user["name"] as! String, forKey: "first_name")
                    }
                    
                    if user["email"] != nil
                    {
                        para.updateValue(user["email"] as! String, forKey: "email")
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
                                    assessor_homeVC.socialAvatar = URL(string: avatarLink)
                                    userDefault.set(FACEBOOKLOGIN, forKey: SOCIALKEY)
                                    userDefault.synchronize()
                                    self.navigationController?.pushViewController(assessor_homeVC, animated: true)
                                    
                                }
                                else
                                {
                                    print(UserType.examinee.rawValue)
                                    let examiner_homeVC = UIStoryboard(name: EXAMINEE_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "examiner_homeVC") as! Examiner_HomeVC
                                    
                                    examiner_homeVC.userInfomation = result!
                                    examiner_homeVC.socialAvatar = URL(string: avatarLink)
                                    userDefault.set(FACEBOOKLOGIN, forKey: SOCIALKEY)
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
    
    
    @IBAction func instargramBtnTap(_ sender: Any) {
    }
    
    @IBAction func googlePlusBtnTap(_ sender: Any) {
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        
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
                            
                            UserInfoAPI.getUserInfo(withToken: token!, completion: { (userinfo) in
                                
                                if userinfo!["type"] as? String == UserType.assessor.rawValue
                                {
                                    let assessor_homeVC = UIStoryboard(name: ASSESSOR_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "assessor_homeVC") as! Assessor_HomeVC
                                    
                                    assessor_homeVC.userInfomation = userinfo!
                                    
                                    self.navigationController?.pushViewController(assessor_homeVC, animated: true)
                                }
                                else
                                {
                                    let examiner_homeVC = UIStoryboard(name: EXAMINEE_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "examiner_homeVC") as! Examiner_HomeVC
                                    
                                    examiner_homeVC.userInfomation = userinfo!
                                    
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













