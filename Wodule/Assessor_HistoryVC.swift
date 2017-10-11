//
//  Assessor_HistoryVC.swift
//  Wodule
//
//  Created by QTS Coder on 10/4/17.
//  Copyright © 2017 QTS. All rights reserved.
//

import UIKit

class Assessor_HistoryVC: UIViewController {
    
    @IBOutlet weak var lbl_NoFound: UILabel!
    @IBOutlet weak var dataTableView: UITableView!
    
    var History = [AssesmentHistory]()
    let token = userDefault.object(forKey: TOKEN_STRING) as? String
    var userID:Int!
    var currentpage :Int!
    var totalPage:Int!
    
    var AllRecord = [NSDictionary]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        currentpage = 1
        
        lbl_NoFound.isHidden = true
        
        dataTableView.dataSource = self
        dataTableView.delegate = self
        
        loadingShow()
        DispatchQueue.global(qos: .default).async {
            
            ExamRecord.getAllRecord(page: self.currentpage, completion: { (result: [NSDictionary]?, totalPage: Int?) in
                
                if result != nil
                {
                    self.AllRecord = result!
                    self.totalPage = totalPage
                    DispatchQueue.main.async(execute: {
                        self.dataTableView.reloadData()
                        self.loadingHide()
                    })
                    
                }
                else
                {
                    self.lbl_NoFound.text = "No Record Found"
                    self.lbl_NoFound.isHidden = false
                    DispatchQueue.main.async(execute: {
                        self.dataTableView.reloadData()
                        self.loadingHide()
                    })
                }
                
                
            })
        }
        
    }
    
    
    @IBAction func backBtnTap(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension Assessor_HistoryVC: UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AllRecord.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Assessor_HistoryCell
        
        let item = AllRecord[indexPath.row]
        
        cell.lbl_ExamID.text = item["exam"] as? String
        cell.lbl_Score.text = item["score"] as? String
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let date = dateFormatter.date(from: item["creationDate"] as! String)
        dateFormatter.dateFormat = "yy.MM.dd"
        
        cell.lbl_Date.text = dateFormatter.string(from: date!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let lastItem = AllRecord.count - 2
        if indexPath.row == lastItem && currentpage < totalPage + 1
        {
            currentpage = currentpage + 1
            loadMore(currentpage: currentpage)
            print(currentpage)
        }
        
        print("No loadmore",currentpage,totalPage)
    }
    
    func loadMore(currentpage: Int)
    {
        ExamRecord.getAllRecord(page: currentpage, completion: { (result: [NSDictionary]?, totalPage: Int?) in
            
            if result != nil
            {
                for item in result!
                {
                    self.AllRecord.append(item)
                    DispatchQueue.main.async(execute: {
                        self.dataTableView.reloadData()
                    })
                }
            }
        })
        
    }

    
}
