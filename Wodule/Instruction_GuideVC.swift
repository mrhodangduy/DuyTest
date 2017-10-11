//
//  Instruction_GuideVC.swift
//  Wodule
//
//  Created by QTS Coder on 10/3/17.
//  Copyright © 2017 QTS. All rights reserved.
//

import UIKit

class Instruction_GuideVC: UIViewController {
    
    var CategoryExamList = [CategoriesExam]()
    
    var categoryID:Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingShow()
        DispatchQueue.global(qos: .default).async { 
            CategoriesExam.getExam(categoryID: self.categoryID) { (results) in
                
                self.CategoryExamList = results!
                
                self.loadingHide()
                print("\nCATEGORIES EXAM LIST:\n----->",self.CategoryExamList)
            }
        }
        
    }
    
    @IBAction func countinueTap(_ sender: UITapGestureRecognizer) {
        
        let part1VC = UIStoryboard(name: EXAMINEE_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "part1VC") as! Part1VC
        
        part1VC.Exam = CategoryExamList
        
        self.navigationController?.pushViewController(part1VC, animated: true)
        
    }

}
