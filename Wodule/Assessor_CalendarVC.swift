//
//  Assessor_CalendarVC.swift
//  Wodule
//
//  Created by QTS Coder on 10/4/17.
//  Copyright © 2017 QTS. All rights reserved.
//

import UIKit
import FSCalendar

class Assessor_CalendarVC: UIViewController {
    
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func backBtnTap(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    

}

extension Assessor_CalendarVC: FSCalendarDelegate
{
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
}
