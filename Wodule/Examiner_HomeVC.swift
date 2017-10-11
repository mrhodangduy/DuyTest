//
//  Examiner_HomeVC.swift
//  Wodule
//
//  Created by QTS Coder on 10/2/17.
//  Copyright © 2017 QTS. All rights reserved.
//

import UIKit
import SDWebImage
import FBSDKLoginKit
import FacebookLogin
import SVProgressHUD

class Examiner_HomeVC: UIViewController {
    
    @IBOutlet weak var lbl_Name1: UILabel!
    @IBOutlet weak var lbl_Name2: UILabel!
    @IBOutlet weak var lbl_ExaminerID: UILabel!
    @IBOutlet weak var lbl_University: UILabel!
    @IBOutlet weak var lbl_Carier: UILabel!
    @IBOutlet weak var lbl_Sex: UILabel!
    @IBOutlet weak var lbl_Age: UILabel!
    @IBOutlet weak var img_Avatar: UIImageViewX!
    
    var imageData: Data?
    var userInfomation:NSDictionary!
    var socialAvatar: URL!
    var socialIdentifier:String!
    
    let token = userDefault.object(forKey: TOKEN_STRING) as? String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
                
        if userDefault.object(forKey: SOCIALKEY) as? String != nil
        {
            socialIdentifier = userDefault.object(forKey: SOCIALKEY) as! String
        }
        else
        {
            socialIdentifier = NORMALLOGIN
        }
        
        print("\nCURRENT USER TOKEN: ------>\n", token!)
        print("\nCURRENT USER INFO: ------>\n", userInfomation)
        
        asignDataInView()
        
        userDefault.set(userInfomation["id"] as! Int, forKey: USERID_STRING)
        userDefault.synchronize()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.logOut))
        tapGesture.numberOfTapsRequired = 2
        img_Avatar.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadNewData), name: NSNotification.Name(rawValue: NOTIFI_UPDATED), object: nil)
        
    }
    
    
    
    
    
    
    
    func asignDataInView()
    {
        lbl_ExaminerID.text = "\((userInfomation["id"] as? Int)!)"
        lbl_Sex.text = userInfomation["gender"] as? String
        lbl_University.text = userInfomation["organization"] as? String
        lbl_Carier.text = userInfomation["student_class"] as? String
        
        print("IDENTIFIER:", socialIdentifier)

        switch socialIdentifier {
        case GOOGLELOGIN,FACEBOOKLOGIN,INSTAGRAMLOGIN:
            
            if userInfomation["picture"] as! String == "http://wodule.io/user/default.jpg"
            {
                img_Avatar.sd_setImage(with: socialAvatar, placeholderImage: nil, options: SDWebImageOptions.continueInBackground, completed: nil)
            }
            else
            {
                img_Avatar.sd_setImage(with: URL(string: userInfomation["picture"] as! String), placeholderImage: nil, options: SDWebImageOptions.continueInBackground, completed: nil)
            }
            
        case INSTAGRAMLOGIN:
            print("INSTAGRAM LOGIN")
            
        case NORMALLOGIN:
            img_Avatar.sd_setImage(with: URL(string: userInfomation["picture"] as! String), placeholderImage: nil, options: SDWebImageOptions.continueInBackground, completed: nil)
        default:
            return
        }
        
        
        if userInfomation["ln_first"] as? String == "Yes"
        {
            lbl_Name1.text = userInfomation["last_name"] as? String
            lbl_Name2.text = (userInfomation["first_name"] as? String)
        }
        else
        {
            lbl_Name1.text = userInfomation["first_name"] as? String
            lbl_Name2.text = userInfomation["last_name"] as? String
        }
        
        if userInfomation["date_of_birth"] as? String != nil
        {
            let age = calAgeUser(dateString: (userInfomation["date_of_birth"] as? String)!)
            lbl_Age.text = age
        }
        else
        {
            lbl_Age.text = nil
        }
        
        
    }
    
    func loadNewData()
    {
        loadingShow()
        DispatchQueue.global(qos: .default).async {
            UserInfoAPI.getUserInfo(withToken: self.token!, completion: { (users) in
                
                self.userInfomation = users!
                DispatchQueue.main.async(execute: {
                    
                    self.asignDataInView()
                    self.loadingHide()
                    
                    print("\nCURRENT USER INFO AFTER UPDATED:\n------>",self.userInfomation)
                    
                })
                
            })
        }
    }
    
    func logOut()
    {
        switch socialIdentifier {
        case GOOGLELOGIN:
            GIDSignIn.sharedInstance().signOut()
            print("LogOut G+")
            
        case FACEBOOKLOGIN:
            let manger = FBSDKLoginManager()
            manger.logOut()
            print("LogOut FB")
            
        default:
            print("LogOut")
        }

        self.navigationController?.popToRootViewController(animated: true)
        userDefault.removeObject(forKey: SOCIALKEY)
        userDefault.removeObject(forKey: TOKEN_STRING)
        AppDelegate.share.removeAllValueObject()

        userDefault.synchronize()
    }
    
    @IBAction func editProfile(_ sender: Any) {
        
        let editprofileVC = UIStoryboard(name: PROFILE_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "editprofileVC") as! EditProfileVC
        
        editprofileVC.userInfo = self.userInfomation
        editprofileVC.socialAvatar = self.socialAvatar
        editprofileVC.socialIdentifier = self.socialIdentifier
        
        self.navigationController?.pushViewController(editprofileVC, animated: true)
        
    }
    
    @IBAction func assessmentHistoryTap(_ sender: Any) {
        
        let assessmenthistory = UIStoryboard(name: EXAMINEE_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "assessmenthistoryVC") as! AssessmentHistoryVC
        
        assessmenthistory.userID = userInfomation["id"] as? Int
        
        self.navigationController?.pushViewController(assessmenthistory, animated: true)
        
    }
    
    @IBAction func calendarTap(_ sender: Any) {
        
        let calendarVC = UIStoryboard(name: EXAMINEE_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "calendarVC") as! CalendarVC
        self.navigationController?.pushViewController(calendarVC, animated: true)
        
    }
    
    @IBAction func startAssessmentTap(_ sender: Any) {
        
        let categoriesVC = UIStoryboard(name: EXAMINEE_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "categoriesVC") as! Examinee_CategoriesVC
        self.navigationController?.pushViewController(categoriesVC, animated: true)
    }
}









