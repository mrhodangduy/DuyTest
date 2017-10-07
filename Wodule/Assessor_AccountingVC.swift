//
//  Assessor_AccountingVC.swift
//  Wodule
//
//  Created by QTS Coder on 10/4/17.
//  Copyright © 2017 QTS. All rights reserved.
//

import UIKit

class Assessor_AccountingVC: UIViewController {

    @IBOutlet weak var dataTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataTableView.dataSource = self
        dataTableView.delegate = self

        // Do any additional setup after loading the view.
    }

    @IBAction func backtoHomeTap(_ sender: Any) {
        
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
        for assessor_homeVC in viewControllers {
            if assessor_homeVC is Assessor_HomeVC {
                self.navigationController!.popToViewController(assessor_homeVC, animated: true)
            }
        }
        
    }
    
}

extension Assessor_AccountingVC: UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
}
