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
        
        print(userDefault.object(forKey: TOKEN_STRING) as? String as Any)
        print(userDefault.object(forKey: SOCIALKEY) as? String as Any)

    }
    
    //MARK: - Handle FB Login
    
    @IBAction func facebookBtnTap(_ sender: Any) {
        
        let loginManager = LoginManager()
        loginManager.logIn([ .publicProfile, .email, .userFriends ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
                self.alertMissingText(mess: "Login failed", textField: nil)
            case .cancelled:
                print("User cancelled login.")
                self.alertMissingText(mess: "Login cancelled", textField: nil)
            case .success( _, _, let accessToken):
                
                print(accessToken)
                self.loadingShow()
                self.getFBUserData()
                
            }
        }
        
    }
   
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
                                
                                guard let userID = result?["id"] as? Int else { return }
                                
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
                                    self.createAlertFB(user: self.dict, avatarLink: avatar, password: password, userID: userID)
                                    
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
    
    
    func createAlertFB(user: [String: AnyObject], avatarLink: String,password: String, userID:Int)
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
                            
                            if user["name"] as? String != nil
                            {
                                para.updateValue(user["name"] as! String, forKey: FIRSTNAME_STRING)
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
    
    //MARK: - Handle INSTAGRAM Login
    
    @IBAction func instargramBtnTap(_ sender: Any) {
        
        let instagramLogin = UIStoryboard(name: MAIN_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "instagramVC") as! InstagramLoginVC
        
        instagramLogin.tokencallback = { token in
            
            self.loadingShow()
            InstagramAPI.getIDIntergram(token, complete: { (result, error) in
                if let result = result
                {
                    let data = result["data"] as? [String: AnyObject]
                    let id = data?["id"] as? String
                    let name = data?["full_name"] as? String
                    var profile_picture = data?["profile_picture"] as? String
                    
                    if profile_picture != nil && (profile_picture?.contains("s150x150"))!
                    {
                        profile_picture = profile_picture?.replacingOccurrences(of: "/s150x150/", with: "/")
                    }
                  
                    print(profile_picture!)
                    
                    let username = "u02" + id!
                    let password = "instagram"
                    
                    self.loadingShow()
                    
                    LoginWithSocial.LoginUserWithSocial(username: username, password: password, completion: { (first, status) in
                        
                        if status!
                        {
                            let token = userDefault.object(forKey: TOKEN_STRING) as? String
                            LoginWithSocial.getUserInfoSocial(withToken: token!, completion: { (result) in
                                
                                print(result as Any)
                                if result != nil
                                {
                                    
                                    guard let userID = result?["id"] as? Int else { return }
                                    
                                    if result!["type"] as? String == UserType.assessor.rawValue
                                    {
                                        
                                        let assessor_homeVC = UIStoryboard(name: ASSESSOR_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "assessor_homeVC") as! Assessor_HomeVC
                                        
                                        assessor_homeVC.userInfomation = result
                                        if profile_picture != nil
                                        {
                                            assessor_homeVC.socialAvatar = URL(string: profile_picture!)
                                        }
                                        userDefault.set(INSTAGRAMLOGIN, forKey: SOCIALKEY)
                                        userDefault.synchronize()
                                        
                                        self.navigationController?.pushViewController(assessor_homeVC, animated: true)
                                        
                                        DispatchQueue.main.async {
                                            self.loadingHide()
                                        }
                                    }
                                    else if result!["type"] as? String == UserType.examinee.rawValue
                                    {
                                        let examiner_homeVC = UIStoryboard(name: EXAMINEE_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "examiner_homeVC") as! Examiner_HomeVC
                                        
                                        examiner_homeVC.userInfomation = result
                                        if profile_picture != nil
                                        {
                                            examiner_homeVC.socialAvatar = URL(string: profile_picture!)
                                        }
                                        userDefault.set(INSTAGRAMLOGIN, forKey: SOCIALKEY)
                                        userDefault.synchronize()
                                        self.navigationController?.pushViewController(examiner_homeVC, animated: true)
                                        
                                        DispatchQueue.main.async {
                                            self.loadingHide()
                                        }
                                        
                                    }
                                    else
                                    {
                                        print("Missing Code")
                                        DispatchQueue.main.async {
                                            self.loadingHide()
                                        }
                                        self.createAlert(fullname: name!, avatarLink: profile_picture!, password: password, userID: userID)
                                        
                                    }

                                }
                                else
                                {
                                    DispatchQueue.main.async(execute: { 
                                        self.loadingHide()
                                        self.alertMissingText(mess: "Wrong to get your info.Try again.", textField: nil)
                                    })
                                }
                                
                            })
                        }
                        
                    })
                }
            })
            
        }
        
        self.present(instagramLogin, animated: true, completion: nil)
    }
    
    func createAlert(fullname: String?, avatarLink: String?,password: String, userID: Int)
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
                            
                            if fullname != nil
                            {
                                para.updateValue(fullname!, forKey: FIRSTNAME_STRING)
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
                                            if avatarLink != nil
                                            {
                                                assessor_homeVC.socialAvatar = URL(string: avatarLink!)
                                            }
                                            assessor_homeVC.socialAvatar = URL(string: avatarLink!)
                                            userDefault.set(FACEBOOKLOGIN, forKey: SOCIALKEY)
                                            userDefault.synchronize()
                                            self.navigationController?.pushViewController(assessor_homeVC, animated: true)
                                            
                                        }
                                        else
                                        {
                                            print(UserType.examinee.rawValue)
                                            let examiner_homeVC = UIStoryboard(name: EXAMINEE_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "examiner_homeVC") as! Examiner_HomeVC
                                            
                                            examiner_homeVC.userInfomation = result!
                                            if avatarLink != nil
                                            {
                                                examiner_homeVC.socialAvatar = URL(string: avatarLink!)
                                            }
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
    
    //MARK: - Handle G+ Login
    
    @IBAction func googlePlusBtnTap(_ sender: Any) {
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    //MARK: - Handle Login Normal

    
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
    
    //MARK: - Handle Register
    
    @IBAction func register_newuserBtnTap(_ sender: Any) {
        
        let newuser = UIStoryboard(name: MAIN_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "newuser_page1VC") as! NewUser_Page1VC
        self.navigationController?.pushViewController(newuser, animated: true)
        
    }
    
    //MARK: - Handle ForgotPassword
    
    @IBAction func forgotPasswordTap(_ sender: Any) {
        
        let forgotpassVC = UIStoryboard(name: MAIN_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "forgotpassVC") as! ForgotPasswordVC
        self.present(forgotpassVC, animated: true, completion: nil)
    }
    
    //MARK: - Handle License
    
    @IBAction func licenseBtnTap(_ sender: Any) {
        
        let licenseVC = UIStoryboard(name: MAIN_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "licenseVC") as! LicenseVC
        self.navigationController?.pushViewController(licenseVC, animated: true)
        
    }
}













