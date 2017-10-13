//
//  Assessor_HistoryCell.swift
//  Wodule
//
//  Created by QTS Coder on 10/11/17.
//  Copyright © 2017 QTS. All rights reserved.
//

import UIKit

class Assessor_HistoryCell: UITableViewCell {

    @IBOutlet weak var lbl_Date: UILabel!
    @IBOutlet weak var lbl_ExamID: UILabel!
    @IBOutlet weak var lbl_Score: UILabel!
    @IBOutlet weak var lbl_examinerrID: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
