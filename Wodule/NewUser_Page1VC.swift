//
//  NewUser_Page1VC.swift
//  Wodule
//
//  Created by QTS Coder on 10/2/17.
//  Copyright © 2017 QTS. All rights reserved.
//

import UIKit

class NewUser_Page1VC: UIViewController {
    
    var ticked:Bool!
    
    @IBOutlet weak var tf_Firstname: UITextField!
    @IBOutlet weak var tf_Middlename: UITextField!
    @IBOutlet weak var tf_Lastname: UITextField!
    @IBOutlet weak var tf_Nativename: UITextField!
    @IBOutlet weak var tf_Suffix: UITextField!
    @IBOutlet weak var tf_DateofBirthday: UITextField!
    @IBOutlet weak var tf_CountryofBirth: UITextField!
    
    @IBOutlet weak var dataTableview: UITableView!
    
    var backgroundView:UIView!
    var tableHeight:CGFloat!
    var currentIndex:Int!
    var dataCurrentSelected:Array<String>!
    
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ticked = false
        
        dataTableview.delegate = self
        dataTableview.dataSource = self
        showDatePicker()
        
        tf_Suffix.tintColor = .clear
        tf_CountryofBirth.tintColor = .clear
    }
    
    @IBAction func tickBtnTap(_ sender: UIButton) {
        
        if !ticked
        {
            sender.setImage(#imageLiteral(resourceName: "ic_ticked"), for: .normal)
        }
        else
        {
            sender.setImage(#imageLiteral(resourceName: "ic_tick"), for: .normal)
        }
        
        ticked = !ticked
    }
    
    @IBAction func suffixTap(_ sender: Any) {
        
        currentIndex = 1
        tableHeight = CGFloat(Suffix.count) * 44
        setupViewData(subView: dataTableview, height: tableHeight)
        createAnimatePopup(from: dataTableview, with: backgroundView)
        dataTableview.reloadData()
        
    }
    
    @IBAction func countryTap(_ sender: Any) {
        
        currentIndex = 2
        
        if (CGFloat(CountryList.count) * 44) > (self.view.frame.height - 100)
        {
            tableHeight = self.view.frame.height - 100
        }
        else
        {
            tableHeight = CGFloat(CountryList.count) * 44
        }
        setupViewData(subView: dataTableview, height: tableHeight)
        createAnimatePopup(from: dataTableview, with: backgroundView)
        dataTableview.reloadData()
    }
    
    
    func setupViewData(subView: UIView, height: CGFloat)
    {
        backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        backgroundView.backgroundColor = UIColor.gray
        backgroundView.alpha = 0
        
        view.addSubview(backgroundView)
        view.addSubview(subView)
        subView.layer.cornerRadius = 10
        
        let widthView = view.frame.size.width * (18/20)
        let heightView:CGFloat = height
        subView.frame = CGRect(x: view.frame.size.width * (1/20), y: (view.frame.size.height - heightView) / 2 , width: widthView, height: heightView)
        subView.alpha = 0
    }
    
    func handleCloseView()
    {
        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
            self.backgroundView.alpha = 0
            self.dataTableview.alpha = 0
        }, completion: { (true) in
            self.perform(#selector(self.removeView), with: self, afterDelay: 0)
            
        })
    }
    
    func removeView()
    {
        self.backgroundView.removeFromSuperview()
        self.dataTableview.removeFromSuperview()
    }
    
    func showDatePicker()
    {
        datePicker.datePickerMode = .date
        
        //Toolbar
        
        let toolbar = setToolBarDate()
        
        tf_DateofBirthday.inputAccessoryView = toolbar
        tf_DateofBirthday.inputView = datePicker
        tf_DateofBirthday.tintColor = .clear
        
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
        tf_DateofBirthday.text = "\(formatter.string(from: datePicker.date))"
        
        //dismiss date picker dialog
        
        self.view.endEditing(true)
    }
    
    func saveData()
    {
        userDefault.set(tf_Firstname.text!, forKey: FIRSTNAME_STRING)
        userDefault.set(tf_Middlename.text!, forKey: MIDDLENAME_STRING)
        userDefault.set(tf_Lastname.text, forKey: LASTNAME_STRING)
        userDefault.set(tf_DateofBirthday.text, forKey: BIRTHDAY_STRING)
        userDefault.set(tf_CountryofBirth.text, forKey: COUNTRYOFBIRTH_STRING)
        userDefault.set(tf_Nativename.text, forKey: NATIVE_STRING)
        userDefault.set(tf_Suffix.text, forKey: SUFFIX_STRING)
        userDefault.set(ticked, forKey: LASTNAMEFIRST_STRING)
        userDefault.synchronize()
        
        print(ticked, userDefault.bool(forKey: LASTNAMEFIRST_STRING))
        
    }
    
    @IBAction func nextPageTap(_ sender: Any) {
        
        let checkey = checkValidateTextField(tf1: tf_Firstname, tf2: tf_Middlename, tf3: tf_Lastname, tf4: tf_DateofBirthday, tf5: tf_CountryofBirth, tf6: nil)
        
        switch checkey {
        case 1:
            self.alertMissingText(mess: "First name is required", textField: tf_Firstname)
        case 2:
            self.alertMissingText(mess: "Middle name is required", textField: tf_Middlename)
        case 3:
            self.alertMissingText(mess: "Last name is required", textField: tf_Lastname)
        case 4:
            self.alertMissingText(mess: "Date of Birth is required", textField: nil)
        case 5:
            self.alertMissingText(mess: "Country of Birth is required", textField: nil)
        
        default:
            
            saveData()
            let newuser = UIStoryboard(name: MAIN_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "newuser_page2VC") as! NewUser_Page2VC
            self.navigationController?.pushViewController(newuser, animated: true)
        }
        
    }
    
}
extension NewUser_Page1VC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if currentIndex == 1
        {
            return Suffix.count

        }
        else
        {
            return CountryList.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NewUser1_TableViewCell
        
        if currentIndex == 1
        {
            cell.lbl_Name.text = Suffix[indexPath.row]

        }
        else
        {
            cell.lbl_Name.text = CountryList[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if currentIndex == 1
        {
            self.tf_Suffix.text = Suffix[indexPath.row]
 
        }
        else
        {
            self.tf_CountryofBirth.text = CountryList[indexPath.row]
        }
        
        handleCloseView()
        
    }
}

