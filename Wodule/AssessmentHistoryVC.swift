//
//  AssessmentHistoryVC.swift
//  Wodule
//
//  Created by QTS Coder on 10/3/17.
//  Copyright © 2017 QTS. All rights reserved.
//

import UIKit


class AssessmentHistoryVC: UIViewController {
    
    @IBOutlet weak var lbl_NoFound: UILabel!
    var History = [AssesmentHistory]()
    let token = userDefault.object(forKey: TOKEN_STRING) as? String
    var userID:Int!
    
    
    @IBOutlet weak var dataTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbl_NoFound.isHidden = true
        
        dataTableView.dataSource = self
        dataTableView.delegate = self
        
        
        loadingShow()
        AssesmentHistory.getUserHistory(withToken: token!, userID: userID) { (status,mess, results) in
            
            if status!
            {
                print("\n\nHISTORY LIST:--->\n",results!)
                self.History = results!
                DispatchQueue.main.async(execute: {
                    self.loadingHide()
                    self.dataTableView.reloadData()
                    if self.History.count == 0
                    {
                        self.lbl_NoFound.isHidden = false
                    }
                })
                
            }
            else
                
            {
                print("\nERROR:---->",mess!)
                
            }
            
        }
    }
    
    
    @IBAction func backBtnTap(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension AssessmentHistoryVC: UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return History.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Examinee_HistoryCell
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let date = dateFormatter.date(from: History[indexPath.row].creationDate)
        dateFormatter.dateFormat = "yy.MM.dd"
        
        cell.lbl_date.text = dateFormatter.string(from: date!)
        cell.lbl_ExamID.text = History[indexPath.row].exam
        cell.lbl_Point.text = History[indexPath.row].score
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
}
