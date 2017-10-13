//
//  ForgotPasswordVC.swift
//  Wodule
//
//  Created by QTS Coder on 10/2/17.
//  Copyright © 2017 QTS. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var tf_Username: UITextField!
    @IBOutlet weak var tf_Email: UITextField!
    @IBOutlet weak var tf_Birthday: UITextField!
    
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        showDatePicker()
        
        // Do any additional setup after loading the view.
    }
    
    func showDatePicker()
    {
        datePicker.datePickerMode = .date
        
        //Toolbar
        
        let toolbar = setToolBarDate()
        
        tf_Birthday.inputAccessoryView = toolbar
        tf_Birthday.inputView = datePicker
        tf_Birthday.tintColor = .clear
        
    }
    func setToolBarDate() -> UIToolbar
    {
        let toolbar = UIToolbar()
        toolbar.barTintColor = #colorLiteral(red: 0.09164389223, green: 0.2853683531, blue: 0.1567776203, alpha: 1)
        toolbar.tintColor = UIColor.white
        toolbar.sizeToFit()
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.donedatePicker))
        toolbar.setItems([spaceButton,spaceButton,doneButton], animated: false)
        
        return toolbar
    }
    func donedatePicker()
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        tf_Birthday.text = "\(formatter.string(from: datePicker.date))"
        
        self.view.endEditing(true)
    }

   
    @IBAction func submitBtnTap(_ sender: Any) {
        
        let checkey = checkValidateTextField(tf1: tf_Username, tf2: nil, tf3: nil, tf4: nil, tf5: nil, tf6: nil)
        
        switch checkey {
        case 1:
            self.alertMissingText(mess: "Email is required", textField: tf_Username)
        
        default:
            self.dismiss(animated: true, completion: nil)

        }
        
        
        
    }

}
