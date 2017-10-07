//
//  Examinee_History.swift
//  Wodule
//
//  Created by QTS Coder on 10/5/17.
//  Copyright © 2017 QTS. All rights reserved.
//

import UIKit

class Examinee_HistoryCell: UITableViewCell {

    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var lbl_ExamID: UILabel!
    @IBOutlet weak var lbl_Point: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
