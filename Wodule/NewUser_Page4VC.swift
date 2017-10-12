//
//  NewUser_Page4VC.swift
//  Wodule
//
//  Created by QTS Coder on 10/2/17.
//  Copyright © 2017 QTS. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class NewUser_Page4VC: UIViewController {

    @IBOutlet weak var img_Avatar: UIImageViewX!
    
    var imageData:Data?
    
    var firstname:String!
    var lastname:String!
    var middlename:String!
    var birthday:String!
    var countryofBirth:String!
    var city:String!
    var country:String!
    var telephone:String!
    var nationality:String!
    var email:String!
    var status:String!
    var gender:String!
    var username:String!
    var password:String!
    var code:String!
    var native_name:String?
    var suffix: String?
    var address:String?
    var address1:String?
    var address2:String?
    var address3:String?
    var ethnicity:String?
    var religion:String?
    var ln_first:Bool?
    
    var para:Parameters!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        createPara()
        
        if imageData != nil
        {
            img_Avatar.image = UIImage(data: imageData!)

        }
        else
        {
            img_Avatar.image = #imageLiteral(resourceName: "default")
        }

    }
    
    @IBAction func backPageTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getData()
    {
        firstname = userDefault.object(forKey: FIRSTNAME_STRING) as! String
        lastname = userDefault.object(forKey: LASTNAME_STRING) as! String
        middlename = userDefault.object(forKey: MIDDLENAME_STRING) as! String
        birthday = userDefault.object(forKey: BIRTHDAY_STRING) as! String
        countryofBirth = userDefault.object(forKey: COUNTRYOFBIRTH_STRING) as! String
        city = userDefault.object(forKey: CITY_STRING) as! String
        country = userDefault.object(forKey: COUNTRY_STRING) as! String
        telephone = userDefault.object(forKey: PHONE_STRING) as! String
        nationality = userDefault.object(forKey: NATIONALITY_STRING) as! String
        email = userDefault.object(forKey: EMAIL_STRING) as! String
        status = userDefault.object(forKey: STATUS_STRING) as! String
        gender = userDefault.object(forKey: GENDER_STRING) as! String
        username = userDefault.object(forKey: USERNAME_STRING) as! String
        password = userDefault.object(forKey: PASSWORD_STRING) as! String
        code = userDefault.object(forKey: CODE_STRING) as! String
        native_name = userDefault.object(forKey: NATIVE_STRING) as? String ?? nil
        suffix = userDefault.object(forKey: SUFFIX_STRING) as? String ?? nil
        address1 = userDefault.object(forKey: ADDRESS1_STRING) as? String ?? nil
        address2 = userDefault.object(forKey: ADDRESS2_STRING) as? String ?? nil
        address3 = userDefault.object(forKey: ADDRESS3_STRING) as? String ?? nil
        ethnicity = userDefault.object(forKey: ETHNIC_STRING) as? String ?? nil
        religion = userDefault.object(forKey: RELIGION_STRING) as? String ?? nil
        ln_first = userDefault.bool(forKey: LASTNAMEFIRST_STRING)
    }
    
    func createPara()
    {
        para = ["first_name":           firstname,
                "middle_name":          middlename,
                "last_name":            lastname,
                "date_of_birth":        birthday,
                "country_of_birth":     countryofBirth,
                "city":                 city,
                "country":              country,
                "telephone":            telephone,
                "nationality":          nationality,
                "status":               status,
                "gender":               gender,
                "email":                email,
                "user_name":            username,
                "password":             password,
                "code":                 code]
                
        if ln_first!
        {
            para.updateValue("Yes", forKey: "ln_first")
        }
        
        if (native_name?.trimmingCharacters(in: .whitespacesAndNewlines).characters.count)! > 0
        {
            para.updateValue(native_name!, forKey: "native_name")
        }
        if (suffix?.trimmingCharacters(in: .whitespacesAndNewlines).characters.count)! > 0
        {
            para.updateValue(suffix!, forKey: "suffix")
        }
        
        if (address1?.trimmingCharacters(in: .whitespacesAndNewlines).characters.count)! > 0
        {
            
            address = address1!
            
        }
        
        if (address2?.trimmingCharacters(in: .whitespacesAndNewlines).characters.count)! > 0
        {
            if address != nil
            {
                address = address! + ", " + address2!

            }
            else
            {
                address = address2!

            }
        }
        
        if (address3?.trimmingCharacters(in: .whitespacesAndNewlines).characters.count)! > 0
        {
            if address != nil
            {
                address = address! + ", " + address3!

            }
            else
            {
                address = address3!

            }
        }

        if address != nil
        {
            para.updateValue(address!, forKey: "address")
        }
        
        if (ethnicity?.trimmingCharacters(in: .whitespacesAndNewlines).characters.count)! > 0
        {
            para.updateValue(ethnicity!, forKey: "ethnicity")
        }
        if (religion?.trimmingCharacters(in: .whitespacesAndNewlines).characters.count)! > 0
        {
            para.updateValue(religion!, forKey: "religion")
        }
        
        print("\nPARA:----->",para)
    }

    @IBAction func submitBtnTap(_ sender: Any) {
        
        
        self.loadingShow()
        DispatchQueue.global().async { 
            UserInfoAPI.RegisterUser(para: self.para, picture: self.imageData, completion: { (status) in
                
                if status
                {
                    self.removeValueObject()
                    let token = userDefault.object(forKey: TOKEN_STRING) as? String
                    
                    UserInfoAPI.getUserInfo(withToken: token!, completion: { (userInfo) in
                        
                        if userInfo?["type"] as? String == UserType.assessor.rawValue
                        {
                            let assessor_homeVC = UIStoryboard(name: ASSESSOR_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "assessor_homeVC") as! Assessor_HomeVC
                            
                            assessor_homeVC.userInfomation = userInfo
                            
                            self.navigationController?.pushViewController(assessor_homeVC, animated: true)
                        }
                        else
                        {
                            let examiner_homeVC = UIStoryboard(name: EXAMINEE_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "examiner_homeVC") as! Examiner_HomeVC
                            
                            examiner_homeVC.userInfomation = userInfo
                            
                            self.navigationController?.pushViewController(examiner_homeVC, animated: true)
                        }
                        
                        DispatchQueue.main.async(execute: { 
                            self.loadingHide()
                            print("REGISTER AND LOGIN SUCCESSFUL, REDIRECT TO:-->", (userInfo?["type"] as? String)?.uppercased() as Any)
                        })
                        
                    })
                }
                else
                {
                    DispatchQueue.main.async(execute: { 
                        self.loadingHide()
                        self.alertMissingText(mess: userDefault.object(forKey: NOTIFI_ERROR) as! String, textField: nil)
                    })
                }
                
            })
        }
        
    }
    
    func removeValueObject()
    {
        userDefault.removeObject(forKey: FIRSTNAME_STRING)
        userDefault.removeObject(forKey: MIDDLENAME_STRING)
        userDefault.removeObject(forKey: LASTNAME_STRING)
        userDefault.removeObject(forKey: NATIVE_STRING)
        userDefault.removeObject(forKey: SUFFIX_STRING)
        userDefault.removeObject(forKey: LASTNAMEFIRST_STRING)
        userDefault.removeObject(forKey: BIRTHDAY_STRING)
        userDefault.removeObject(forKey: COUNTRYOFBIRTH_STRING)
        userDefault.removeObject(forKey: ADDRESS1_STRING)
        userDefault.removeObject(forKey: ADDRESS2_STRING)
        userDefault.removeObject(forKey: ADDRESS3_STRING)
        userDefault.removeObject(forKey: CITY_STRING)
        userDefault.removeObject(forKey: COUNTRY_STRING)
        userDefault.removeObject(forKey: EMAIL_STRING)
        userDefault.removeObject(forKey: PHONE_STRING)
        userDefault.removeObject(forKey: NATIONALITY_STRING)
        userDefault.removeObject(forKey: ETHNIC_STRING)
        userDefault.removeObject(forKey: STATUS_STRING)
        userDefault.removeObject(forKey: RELIGION_STRING)
        userDefault.removeObject(forKey: GENDER_STRING)
        userDefault.removeObject(forKey: USERNAME_STRING)
        userDefault.removeObject(forKey: PASSWORD_STRING)
        userDefault.removeObject(forKey: CODE_STRING)
        userDefault.removeObject(forKey: NOTIFI_ERROR)
        userDefault.synchronize()


    }
    
}
