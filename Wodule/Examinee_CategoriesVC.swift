//
//  Examinee_CategoriesVC.swift
//  Wodule
//
//  Created by QTS Coder on 10/6/17.
//  Copyright © 2017 QTS. All rights reserved.
//

import UIKit

class Examinee_CategoriesVC: UIViewController {

    @IBOutlet weak var dataTableView: UITableView!
    
    var CategoryList = [Categories]()
    
    let token = userDefault.object(forKey: TOKEN_STRING) as? String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataTableView.delegate = self
        dataTableView.dataSource = self
        getCategories()

    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    func getCategories()
    {
        CategoryList.removeAll()
        loadingShow()
        DispatchQueue.global(qos: .default).async { 
            
            Categories.getAllCategory(withToken: self.token!, completion: { (status, results) in
                
                if status!
                {
                    self.CategoryList = results!
                    DispatchQueue.main.async(execute: { 
                        self.dataTableView.reloadData()
                        self.loadingHide()
                    })
                }
                else
                {
                    print("ERROR:--->", status!)
                    DispatchQueue.main.async(execute: {
                        self.dataTableView.reloadData()
                        self.loadingHide()
                    })
                }
            })
            
            
        }
    }
    @IBAction func backtoHomeTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}

extension Examinee_CategoriesVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CategoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Examinee_CategoriesCell
        
        cell.lbl_CateName.text = CategoryList[indexPath.row].subject
        cell.lbl_Detail.text = CategoryList[indexPath.row].details
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let instruction_guideVC = UIStoryboard(name: EXAMINEE_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "instruction_guideVC") as! Instruction_GuideVC
        instruction_guideVC.categoryID = CategoryList[indexPath.row].identifier
        
        self.navigationController?.pushViewController(instruction_guideVC, animated: true)
    }
    
    
}













