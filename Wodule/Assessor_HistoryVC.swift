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
                    if self.History.count == 0
                    {
                        self.lbl_NoFound.isHidden = false
                    }
                    self.loadingHide()
                    self.dataTableView.reloadData()
                })
                
            }
            else
                
            {
                DispatchQueue.main.async(execute: {
                    if self.History.count == 0
                    {
                        self.lbl_NoFound.isHidden = false
                    }
                    self.loadingHide()
                    self.dataTableView.reloadData()
                })
                print("\nERROR:---->",mess!)
            }
            
        }


    }

    @IBAction func backBtnTap(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    

}

extension Assessor_HistoryVC: UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return History.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
}
