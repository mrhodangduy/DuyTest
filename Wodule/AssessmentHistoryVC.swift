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
    var currentpage:Int!
    var totalPage:Int!
    
    
    @IBOutlet weak var dataTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.viewDidLoad()
        
        lbl_NoFound.isHidden = true
        lbl_NoFound.text = "No Assessment Found"
        
        dataTableView.dataSource = self
        dataTableView.delegate = self
        
        currentpage = 1
        
        loadingShow()
        AssesmentHistory.getUserHistory(withToken: token!, userID: userID, page: currentpage) { (status,mess, results, totalpage) in
            
            if status!
            {
                if results?.count != 0
                {
                    print("\n\nHISTORY LIST:--->\n",results!)
                    self.totalPage = totalpage
                    for result in results!
                    {
                        self.History.append(result)
                        DispatchQueue.main.async(execute: {
                            self.loadingHide()
                            self.dataTableView.reloadData()
                            
                        })
                        
                    }
                }
                else
                {
                    DispatchQueue.main.async(execute: {
                        self.loadingHide()
                        self.dataTableView.reloadData()
                        self.lbl_NoFound.isHidden = false
                    })
                }
                
                
            }
            else
                
            {
                print("\nERROR:---->",mess!)
                DispatchQueue.main.async(execute: {
                    self.loadingHide()
                    self.dataTableView.reloadData()
                    
                })
                
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
        
        
        
        cell.lbl_date.text = convertDay(DateString: History[indexPath.row].creationDate)
        cell.lbl_ExamID.text = History[indexPath.row].exam
        
        if History[indexPath.row].score == 0
        {
            cell.lbl_Point.text = "-"
        }
        else
        {
            cell.lbl_Point.text = "\(History[indexPath.row].score)"

        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        print("HISTORY\n----->",History[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let lastItem = History.count - 2
        if indexPath.row == lastItem && currentpage < totalPage + 1
        {
            currentpage = currentpage + 1
            loadmore(page: currentpage)
            print(currentpage)
        }
        
        print("No loadmore",currentpage,totalPage)
    }
    
    func loadmore(page:Int)
    {
        AssesmentHistory.getUserHistory(withToken: token!, userID: userID, page: page) { (status, data, results, totolPage) in
            
            if results != nil
            {
                for item in results!
                {
                    self.History.append(item)
                    DispatchQueue.main.async(execute: {
                        self.dataTableView.reloadData()
                    })
                }
            }
            
        }
    }
    
}
