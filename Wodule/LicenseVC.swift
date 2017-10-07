//
//  LicenseVC.swift
//  Wodule
//
//  Created by QTS Coder on 10/2/17.
//  Copyright © 2017 QTS. All rights reserved.
//

import UIKit

class LicenseVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    

    @IBAction func agreeBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func deagreeBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
