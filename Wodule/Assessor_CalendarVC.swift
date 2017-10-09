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
    
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    fileprivate let gregorian: NSCalendar! = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func backBtnTap(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func backMonthTap(_ sender: Any) {
        if  let prePage = self.gregorian.date(byAdding: .month, value: -1, to: calendarView.currentPage, options: .init(rawValue: 0)) {
            calendarView.setCurrentPage(prePage, animated: true)
            
        }
        
    }
    
    @IBAction func nextMonthTap(_ sender: Any) {
        
        if  let nextPage = self.gregorian.date(byAdding: .month, value: 1, to: calendarView.currentPage, options: .init(rawValue: 0)) {
            calendarView.setCurrentPage(nextPage, animated: true)
            
        }
    }
    

}

extension Assessor_CalendarVC: FSCalendarDelegate
{
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
}
