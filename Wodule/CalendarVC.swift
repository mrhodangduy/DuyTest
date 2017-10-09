//
//  CalendarVC.swift
//  Wodule
//
//  Created by QTS Coder on 10/3/17.
//  Copyright © 2017 QTS. All rights reserved.
//

import UIKit
import FSCalendar

class CalendarVC: UIViewController {

    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func calendarBackTap(_ sender: Any) {
    }
    @IBAction func calendaNextTap(_ sender: Any) {
    }
    
    

}

extension CalendarVC: FSCalendarDelegate
{
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
}
