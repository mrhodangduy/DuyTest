//
//  NewUser_Page2VC.swift
//  Wodule
//
//  Created by QTS Coder on 10/2/17.
//  Copyright © 2017 QTS. All rights reserved.
//

import UIKit

class NewUser_Page2VC: UIViewController {
    
    @IBOutlet weak var tf_ResidenceAdd: UITextField!
    @IBOutlet weak var tf_OptionalAdd1: UITextField!
    @IBOutlet weak var tf_OptionalAdd2: UITextField!
    @IBOutlet weak var tf_City: UITextField!
    @IBOutlet weak var tf_Country: UITextField!
    @IBOutlet weak var tf_Telephone: UITextField!
    @IBOutlet weak var tf_Email: UITextField!
    @IBOutlet weak var tf_Nationality: UITextField!
    @IBOutlet weak var tf_Ethnicity: UITextField!
    
    @IBOutlet var dataTableView: UITableView!
    var tableHeight:CGFloat!
    var backgroundView:UIView!
    
    var currentSelected:Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataTableView.dataSource = self
        dataTableView.delegate = self
        
        tf_Country.tintColor = .clear
        tf_Ethnicity.tintColor = .clear
        tf_Nationality.tintColor = .clear       
        
    }
    
    @IBAction func CountryTap(_ sender: Any) {
        
        currentSelected = 0
        
        if (CGFloat(CountryList.count) * 44) > (self.view.frame.height - 100)
        {
            tableHeight = self.view.frame.height - 100
        }
        else
        {
            tableHeight = CGFloat(CountryList.count) * 44
        }
        
        setupViewData(subView: dataTableView, height: tableHeight)
        createAnimatePopup(from: dataTableView, with: backgroundView)
        dataTableView.reloadData()
    }
    
    @IBAction func natinalityBtnTap(_ sender: Any) {
        
        currentSelected = 1
        if (CGFloat(Nationality.count) * 44) > (self.view.frame.height - 100)
        {
            tableHeight = self.view.frame.height - 100
        }
        else
        {
            tableHeight = CGFloat(Nationality.count) * 44
        }
        
        setupViewData(subView: dataTableView, height: tableHeight)
        createAnimatePopup(from: dataTableView, with: backgroundView)
        dataTableView.reloadData()
        
    }
    
    @IBAction func ethnicityBtnTap(_ sender: Any) {
        
        currentSelected = 2
        
        if (CGFloat(Ethnicity.count) * 44) > (self.view.frame.height - 100)
        {
            tableHeight = self.view.frame.height - 100
        }
        else
        {
            tableHeight = CGFloat(Ethnicity.count) * 44
        }
        setupViewData(subView: dataTableView, height: tableHeight)
        createAnimatePopup(from: dataTableView, with: backgroundView)
        dataTableView.reloadData()
        
    }
    
    func saveData()
    {
        userDefault.set(tf_City.text!, forKey: CITY_STRING)
        userDefault.set(tf_Country.text!, forKey: COUNTRY_STRING)
        userDefault.set(tf_Telephone.text!, forKey: PHONE_STRING)
        userDefault.set(tf_Email.text!, forKey: EMAIL_STRING)
        userDefault.set(tf_Nationality.text, forKey: NATIONALITY_STRING)
        userDefault.set(tf_ResidenceAdd.text, forKey: ADDRESS1_STRING)
        userDefault.set(tf_OptionalAdd1.text, forKey: ADDRESS2_STRING)
        userDefault.set(tf_OptionalAdd2.text, forKey: ADDRESS3_STRING)
        userDefault.set(tf_Ethnicity.text, forKey: ETHNIC_STRING)
        userDefault.synchronize()
    }
    
    @IBAction func nextPageTap(_ sender: Any) {
        
        let checkey = checkValidateTextField(tf1: tf_City, tf2: tf_Country, tf3: tf_Telephone, tf4: tf_Email, tf5: tf_Nationality, tf6: nil)
        
        switch checkey {
        case 1:
            self.alertMissingText(mess: "City is required", textField: tf_City)
        case 2:
            self.alertMissingText(mess: "Country is required", textField: nil)
        case 3:
            self.alertMissingText(mess: "Telephone is required", textField: tf_Telephone)
        case 4:
            self.alertMissingText(mess: "Email is required", textField: tf_Email)
        case 5:
            self.alertMissingText(mess: "Nationality is required", textField: nil)	
        default:
            
            saveData()
            
            let newuser = UIStoryboard(name: MAIN_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "newuser_page3VC") as! NewUser_Page3VC
            self.navigationController?.pushViewController(newuser, animated: true)
        }
        
        
    }
    
    @IBAction func backPageTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
            self.dataTableView.alpha = 0
        }, completion: { (true) in
            self.perform(#selector(self.removeView), with: self, afterDelay: 0)
            
        })
    }
    
    func removeView()
    {
        self.backgroundView.removeFromSuperview()
        self.dataTableView.removeFromSuperview()
    }
    
    
}

extension NewUser_Page2VC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch currentSelected {
        case 0:
            return CountryList.count
        case 1:
            return Nationality.count
        default:
            return Ethnicity.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NewUser2_TableViewCell
        
        switch currentSelected {
        case 0:
            cell.lbl_Name.text = CountryList[indexPath.row]
        case 1:
            cell.lbl_Name.text = Nationality[indexPath.row]
        default:
            cell.lbl_Name.text = Ethnicity[indexPath.row]
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if currentSelected == 0
        {
            self.tf_Country.text = CountryList[indexPath.row]
            
        }
            
        else if currentSelected == 1
        {
            self.tf_Nationality.text = Nationality[indexPath.row]
            
        }
        else
        {
            self.tf_Ethnicity.text = Ethnicity[indexPath.row]
        }
        
        handleCloseView()
        
    }
    
    
}


