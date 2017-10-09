//
//  Examiner_HomeVC.swift
//  Wodule
//
//  Created by QTS Coder on 10/2/17.
//  Copyright © 2017 QTS. All rights reserved.
//

import UIKit
import SDWebImage


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
    var userInfo: UserInfoAPI!
    
    let token = userDefault.object(forKey: TOKEN_STRING) as? String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("\nCURRENT USER TOKEN: ------>\n", token!)
        print("\nCURRENT USER INFO: ------>\n",userInfo)

        asignDataInView()
        
        userDefault.set(userInfo.id, forKey: USER_STRING)
        userDefault.synchronize()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.logOut))
        tapGesture.numberOfTapsRequired = 2
        img_Avatar.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadNewData), name: NSNotification.Name(rawValue: NOTIFI_UPDATED), object: nil)

    }
        
    
    func asignDataInView()
    {
        lbl_ExaminerID.text = "\(userInfo.id)"
        img_Avatar.sd_setImage(with: URL(string: userInfo.picture), placeholderImage: nil, options: SDWebImageOptions.continueInBackground, completed: nil)
        let age = calAgeUser(dateString: userInfo.date_of_birth)
        lbl_Age.text = age
        lbl_Sex.text = userInfo.gender
        lbl_University.text = userInfo.organization
        lbl_Carier.text = userInfo.student_class
        
        if userInfo.ln_first == "Yes"
        {
            lbl_Name1.text = userInfo.last_name
            lbl_Name2.text = userInfo.first_name + " " + userInfo.middle_name
        }
        else
        {
            lbl_Name1.text = userInfo.first_name + " " + userInfo.middle_name
            lbl_Name2.text = userInfo.last_name
        }
        
    }
    
    func loadNewData()
    {
        loadingShow()
        DispatchQueue.global(qos: .default).async {
            UserInfoAPI.getUserProfile(withToken: self.token!, completion: { (users) in
                
                self.userInfo = users!
                DispatchQueue.main.async(execute: {
                    
                    self.asignDataInView()
                    self.loadingHide()
                    
                    print("\nCURRENT USER INFO AFTER UPDATED:\n------>",self.userInfo)

                })
                
            })
        }
    }
    
    func logOut()
    {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func editProfile(_ sender: Any) {
        
        let editprofileVC = UIStoryboard(name: PROFILE_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "editprofileVC") as! EditProfileVC
        
        editprofileVC.userInfo = self.userInfo
        self.navigationController?.pushViewController(editprofileVC, animated: true)

    }
    
    @IBAction func assessmentHistoryTap(_ sender: Any) {
        
        let assessmenthistory = UIStoryboard(name: EXAMINEE_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "assessmenthistoryVC") as! AssessmentHistoryVC
        
        assessmenthistory.userID = userInfo.id
        
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









