//
//  EditProfileVC.swift
//  Wodule
//
//  Created by QTS Coder on 10/5/17.
//  Copyright © 2017 QTS. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire

class EditProfileVC: UIViewController {
    
    @IBOutlet weak var lbb_Type: UILabel!
    @IBOutlet weak var img_Avatar: UIImageViewX!
    @IBOutlet weak var tf_UserName: UITextField!
    @IBOutlet weak var tf_Password: UITextField!
    @IBOutlet weak var tf_Firstname: UITextField!
    @IBOutlet weak var tf_Middlename: UITextField!
    @IBOutlet weak var tf_Lastname: UITextField!
    @IBOutlet weak var tf_Nativename: UITextField!
    @IBOutlet weak var tf_Suffix: UITextField!
    @IBOutlet weak var lastname_first: UIButton!
    @IBOutlet weak var tf_DateOfBirth: UITextField!
    @IBOutlet weak var tf_CountryOfBirth: UITextField!
    @IBOutlet weak var tf_Residence: UITextField!
    @IBOutlet weak var tf_City: UITextField!
    @IBOutlet weak var tf_Country: UITextField!
    @IBOutlet weak var tf_Telephone: UITextField!
    @IBOutlet weak var tf_Email: UITextField!
    @IBOutlet weak var tf_Nationality: UITextField!
    @IBOutlet weak var tf_Ethnicity: UITextField!
    @IBOutlet weak var tf_Status: UITextField!
    @IBOutlet weak var tf_Religion: UITextField!
    @IBOutlet weak var tf_Gender: UITextField!
    
    @IBOutlet var dataTableView: UITableView!
    var backgroundView:UIView!
    var tableHeight:CGFloat!
    let cellHeight:CGFloat = 44
    
    var numberofRow:Int!
    var currentSelected:String!
    var isTicked:Bool!
    var dataCurrentSelected:Array<String>!
    let datePicker = UIDatePicker()
    
    var userInfo:NSDictionary!
    var para: Parameters!
    var header: HTTPHeaders!
    var imgData:Data?
    let token = userDefault.object(forKey: TOKEN_STRING) as! String
    
    var socialAvatar:URL!
    var socialIdentifier:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("\nEDIT USER INFO:-->\n" , userInfo)
        
        dataTableView.delegate = self
        dataTableView.dataSource = self
        
        showDatePicker()
        setDataOnView()
        checkEmailAvailable()
    }
    
    func checkEmailAvailable()
    {
        tf_Email.isUserInteractionEnabled = false
        print("EMAIL TF:->", tf_Email.isUserInteractionEnabled)
        
        if ((userInfo["email"] as? String) == nil)
        {
            tf_Email.isUserInteractionEnabled = true
            tf_Email.textColor = .black
            print("EMAIL TF true:->", tf_Email.isUserInteractionEnabled)
        }
        else
        {
            tf_Email.isUserInteractionEnabled = false
            tf_Email.textColor = .darkGray
            print("EMAIL TF False:->", tf_Email.isUserInteractionEnabled)
        }

    }
    
    func setDataOnView()
    {
        if userInfo["type"] as? String != nil
        {
            lbb_Type.text = "Type: " + (userInfo["type"] as! String).uppercased()
        }
            
        else
        {
            lbb_Type.text = "Type: Undefine"
        }
        
        
        
        if userInfo["picture"] as! String == "http://wodule.io/user/default.jpg"
        {
            img_Avatar.sd_setImageWithPreviousCachedImage(with: socialAvatar, placeholderImage: nil, options: [], progress: nil, completed: nil)
        }
        else
        {
            img_Avatar.sd_setImageWithPreviousCachedImage(with: URL(string: userInfo["picture"] as! String), placeholderImage: nil, options: [], progress: nil, completed: nil)
        }
        
        switch socialIdentifier {
            
        case GOOGLELOGIN, FACEBOOKLOGIN, INSTAGRAMLOGIN:
            
            if userInfo["picture"] as! String == "http://wodule.io/user/default.jpg"
            {
                img_Avatar.sd_setImageWithPreviousCachedImage(with: socialAvatar, placeholderImage: nil, options: [], progress: nil, completed: nil)
            }
            else
            {
                img_Avatar.sd_setImageWithPreviousCachedImage(with: URL(string: userInfo["picture"] as! String), placeholderImage: nil, options: [], progress: nil, completed: nil)
            }
            
        default:
            
            img_Avatar.sd_setImageWithPreviousCachedImage(with: URL(string: userInfo["picture"] as! String), placeholderImage: nil, options: [], progress: nil, completed: nil)
        }
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleGetImage))
        img_Avatar.addGestureRecognizer(tapGesture)
        
        tf_UserName.text = userInfo["user_name"] as? String ?? ""
        tf_Password.text = "123456"
        tf_Firstname.text = userInfo["first_name"] as? String ?? ""
        tf_Middlename.text = userInfo["middle_name"] as? String ?? ""
        tf_Lastname.text = userInfo["last_name"] as? String ?? ""
        tf_Suffix.text = userInfo["suffix"] as? String ?? ""
        tf_DateOfBirth.text = userInfo["date_of_birth"] as? String ?? ""
        tf_CountryOfBirth.text = userInfo["country_of_birth"] as? String ?? ""
        tf_Residence.text = userInfo["address"] as? String ?? ""
        tf_City.text = userInfo["city"] as? String ?? ""
        tf_Country.text = userInfo["country"] as? String ?? ""
        tf_Telephone.text = userInfo["telephone"] as? String ?? ""
        tf_Email.text = userInfo["email"] as? String ?? ""
        tf_Nationality.text = userInfo["nationality"] as? String ?? ""
        tf_Ethnicity.text = userInfo["ethnicity"] as? String ?? ""
        tf_Status.text = userInfo["status"] as? String ?? ""
        tf_Religion.text = userInfo["religion"] as? String ?? ""
        tf_Gender.text = userInfo["gender"] as? String ?? ""
        
        if userInfo["ln_first"] as? String == "Yes"
        {
            lastname_first.setImage(#imageLiteral(resourceName: "ic_ticked"), for: .normal)
            isTicked = true
        }
        else if userInfo["ln_first"] as? String == nil
        {
            lastname_first.setImage(#imageLiteral(resourceName: "ic_tick"), for: .normal)
            isTicked = false
            
        }
        else
        {
            lastname_first.setImage(#imageLiteral(resourceName: "ic_tick"), for: .normal)
            isTicked = false
        }
    }
    
    func configViewData(number: Int)
    {
        if (CGFloat(number) * 44) > (self.view.frame.height * (4/5))
        {
            tableHeight = self.view.frame.height * (4/5)
        }
        else
        {
            tableHeight = CGFloat(number) * cellHeight
        }
        setupViewData(subView: dataTableView, height: tableHeight)
        createAnimatePopup(from: dataTableView, with: backgroundView)
        dataTableView.reloadData()
    }
    
    func setupViewData(subView: UIView, height: CGFloat)
    {
        backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        backgroundView.backgroundColor = UIColor.gray
        backgroundView.alpha = 0
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleCloseView))
        backgroundView.addGestureRecognizer(tapGesture)
        
        view.addSubview(backgroundView)
        view.addSubview(subView)
        subView.layer.cornerRadius = 10
        
        let widthView = view.frame.size.width * (8/10)
        let heightView:CGFloat = height
        subView.frame = CGRect(x: view.frame.size.width * (1/10), y: (view.frame.size.height - heightView) / 2 , width: widthView, height: heightView)
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
    
    
    func countNumberOfRow(number:Int)
    {
        numberofRow = number
        
    }
    
    func asignData(data: Array<String>)
    {
        dataCurrentSelected = data
    }
    
    @IBAction func suffixTap(_ sender: Any) {
        
        currentSelected = SUFFIX_STRING
        countNumberOfRow(number: Suffix.count)
        asignData(data: Suffix)
        configViewData(number: Suffix.count)
    }
    
    
    @IBAction func lastnameFirstTap(_ sender: Any) {
        
        let button = sender as! UIButton
        if !isTicked
        {
            button.setImage(#imageLiteral(resourceName: "ic_ticked"), for: .normal)
        }
        else
        {
            button.setImage(#imageLiteral(resourceName: "ic_tick"), for: .normal)
        }
        
        isTicked = !isTicked
    }
    
    
    @IBAction func countryOfBirthTap(_ sender: Any) {
        currentSelected = COUNTRYOFBIRTH_STRING
        countNumberOfRow(number: CountryList.count)
        asignData(data: CountryList)
        configViewData(number: CountryList.count)
        
    }
    
    
    @IBAction func countryTap(_ sender: Any) {
        currentSelected = COUNTRY_STRING
        countNumberOfRow(number: CountryList.count)
        asignData(data: CountryList)
        configViewData(number: CountryList.count)
        
        
    }
    
    
    @IBAction func nationalityTap(_ sender: Any) {
        currentSelected = NATIONALITY_STRING
        countNumberOfRow(number: Nationality.count)
        asignData(data: Nationality)
        configViewData(number: Nationality.count)
        
        
    }
    
    @IBAction func ethnicityTap(_ sender: Any) {
        
        currentSelected = ETHNIC_STRING
        countNumberOfRow(number: Ethnicity.count)
        asignData(data: Ethnicity)
        configViewData(number: Ethnicity.count)
        
    }
    
    @IBAction func statusTap(_ sender: Any) {
        currentSelected = STATUS_STRING
        countNumberOfRow(number: Status.count)
        asignData(data: Status)
        configViewData(number: Status.count)
        
        
        
    }
    
    @IBAction func genderTap(_ sender: Any) {
        currentSelected = GENDER_STRING
        countNumberOfRow(number: Gender.count)
        asignData(data: Gender)
        configViewData(number: Gender.count)
        
    }
    
    func showDatePicker()
    {
        datePicker.datePickerMode = .date
        
        //Toolbar
        
        let toolbar = setToolBarDate()
        
        tf_DateOfBirth.inputAccessoryView = toolbar
        tf_DateOfBirth.inputView = datePicker
        tf_DateOfBirth.tintColor = .clear
        
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
        tf_DateOfBirth.text = "\(formatter.string(from: datePicker.date))"
        self.view.endEditing(true)
    }
    
    func createPara_Header()
    {
        
        header = ["Authorization":"Bearer \(token)"]
        
        para = ["_method":"PATCH"]
        
        
        if isTicked! && userInfo["ln_first"] as? String != "Yes"
        {
            para.updateValue("Yes", forKey: "ln_first")
        }
        else if isTicked! == false && userInfo["ln_first"] as? String == "Yes"
        {
            para.updateValue("No", forKey: "ln_first")
            
        }
        else
        {
            
        }
        if (tf_Firstname.text?.characters.count)! > 0 && tf_Firstname.text! != userInfo["first_name"] as? String
        {
            para.updateValue(tf_Firstname.text!, forKey: "first_name")
        }
        if (tf_Middlename.text?.characters.count)! > 0 && tf_Middlename.text! != userInfo["middle_name"] as? String
        {
            para.updateValue(tf_Middlename.text!, forKey: "middle_name")
        }
        if (tf_Lastname.text?.characters.count)! > 0 && tf_Lastname.text! != userInfo["last_name"] as? String
        {
            para.updateValue(tf_Lastname.text!, forKey: "last_name")
        }
        if (tf_Suffix.text?.characters.count)! > 0 && tf_Suffix.text! != userInfo["suffix"] as? String
        {
            para.updateValue(tf_Suffix.text!, forKey: "suffix")
        }
        if (tf_Nativename.text?.characters.count)! > 0 && tf_Nativename.text! != userInfo["native_name"] as? String
        {
            para.updateValue(tf_Nativename.text!, forKey: "native_name")
        }
        if (tf_DateOfBirth.text?.characters.count)! > 0 && tf_DateOfBirth.text! != userInfo["date_of_birth"] as? String
        {
            para.updateValue(tf_DateOfBirth.text!, forKey: "date_of_birth")
        }
        if (tf_CountryOfBirth.text?.characters.count)! > 0 && tf_CountryOfBirth.text! != userInfo["country_of_birth"] as? String
        {
            para.updateValue(tf_CountryOfBirth.text!, forKey: "country_of_birth")
        }
        if (tf_Residence.text?.characters.count)! > 0 && tf_Residence.text! != userInfo["address"] as? String
        {
            para.updateValue(tf_Residence.text!, forKey: "address")
        }
        if (tf_City.text?.characters.count)! > 0 && tf_City.text! != userInfo["city"] as? String
        {
            para.updateValue(tf_City.text!, forKey: "city")
        }
        if (tf_Country.text?.characters.count)! > 0 && tf_Country.text! != userInfo["country"] as? String
        {
            para.updateValue(tf_Country.text!, forKey: "country")
        }
        if (tf_Telephone.text?.characters.count)! > 0 && tf_Telephone.text! != userInfo["telephone"] as? String
        {
            para.updateValue(tf_Telephone.text!, forKey: "telephone")
        }
        if (tf_Nationality.text?.characters.count)! > 0 && tf_Nationality.text! != userInfo["nationality"] as? String
        {
            para.updateValue(tf_Nationality.text!, forKey: "nationality")
        }
        if (tf_Ethnicity.text?.characters.count)! > 0 && tf_Ethnicity.text! != userInfo["ethnicity"] as? String
        {
            para.updateValue(tf_Ethnicity.text!, forKey: "ethnicity")
        }
        if (tf_Status.text?.characters.count)! > 0 && tf_Status.text! != userInfo["status"] as? String
        {
            para.updateValue(tf_Status.text!, forKey: "status")
        }
        if (tf_Religion.text?.characters.count)! > 0 && tf_Religion.text! != userInfo["religion"] as? String
        {
            para.updateValue(tf_Religion.text!, forKey: "religion")
        }
        if (tf_Gender.text?.characters.count)! > 0 && tf_Gender.text! != userInfo["gender"] as? String
        {
            para.updateValue(tf_Gender.text!, forKey: "gender")
        }
        if (tf_Email.text?.characters.count)! > 0 && tf_Email.text! != userInfo["email"] as? String
        {
            para.updateValue(tf_Email.text!, forKey: "email")
        }
        
        print("\nPARA UPDATED:\n------>", para)
        
    }
    
    @IBAction func submitTap(_ sender: Any) {
        
        self.view.endEditing(true)
        
        createPara_Header()
        loadingShow()
        DispatchQueue.global(qos: .default).async {
            UserInfoAPI.updateUserProfile(para: self.para, header: self.header, picture: self.imgData, completion: { (status:Bool, code: Int?, result:NSDictionary?) in
                
                print(code!)
                
                if status
                {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFI_UPDATED), object: self)
                    DispatchQueue.main.async(execute: {
                        print("\n----> UPDATE SUCCESSFUL")
                        self.loadingHide()
                        self.navigationController?.popViewController(animated: true)
                    })
                }
                else
                {
                    
                    if code! == 422
                    {
                        
                        let errorMess = result?["error"] as? String
                        if errorMess != nil
                        {
                            DispatchQueue.main.async(execute: {
                                print("UPDATE FAILED")
                                self.loadingHide()
                                self.alertMissingText(mess: "You need to specify a different value to update", textField: nil)
                            })

                        }
                        else
                        {
                            DispatchQueue.main.async(execute: {
                                print("UPDATE FAILED")
                                self.loadingHide()
                                self.alertMissingText(mess: "The email has already been taken.", textField: self.tf_Email)
                            })
                        }
                        
                    }
                    else
                    {
                        DispatchQueue.main.async(execute: {
                            print("UPDATE FAILED")
                            self.loadingHide()
                            self.alertMissingText(mess: "Failure while updating your profile. Try again.", textField: nil)
                            self.perform(#selector(self.backBtnTap(_:)), with: self, afterDelay: 3)
                        })
                    }
                    
                    
                }
            })
        }
        
    }
    
    
    @IBAction func backBtnTap(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Handle ActionAlert
    
    func handleGetImage()
    {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let btnPhoto  = UIAlertAction(title: "Take a Picture", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera)
            {
                self.getPhotoFrom(type: .camera)
            }
            else
            {
                print("Camera isnot available")
            }
            
        }
        let btnLib  = UIAlertAction(title: "Select from Library", style: .default) { (action) in
            
            self.getPhotoFrom(type: .photoLibrary)
        }
        
        let btnCan = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(btnPhoto)
        alert.addAction(btnLib)
        alert.addAction(btnCan)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func getPhotoFrom(type: UIImagePickerControllerSourceType)
        
    {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = type
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
    
}

extension EditProfileVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return numberofRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EditProfileCell
        
        cell.lbl_Name.text = dataCurrentSelected[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch currentSelected {
        case SUFFIX_STRING:
            tf_Suffix.text = Suffix[indexPath.row]
            
        case COUNTRYOFBIRTH_STRING:
            tf_CountryOfBirth.text = CountryList[indexPath.row]
            
        case COUNTRY_STRING:
            tf_Country.text = CountryList[indexPath.row]
            
        case NATIONALITY_STRING:
            tf_Nationality.text = Nationality[indexPath.row]
            
        case ETHNIC_STRING:
            tf_Ethnicity.text = Ethnicity[indexPath.row]
            
        case STATUS_STRING:
            tf_Status.text = Status[indexPath.row]
            
        case GENDER_STRING:
            tf_Gender.text = Gender[indexPath.row]
            
        default:
            return
        }
        
        handleCloseView()
    }
}

extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chooseImg = info[UIImagePickerControllerOriginalImage] as! UIImage
        let imgValue = max(chooseImg.size.width, chooseImg.size.height)
        
        if imgValue > 3000
        {
            self.imgData = UIImageJPEGRepresentation(chooseImg, 0.1)
            
        }
        else if imgValue > 2000
        {
            self.imgData = UIImageJPEGRepresentation(chooseImg, 0.3)
        }
        else
        {
            self.imgData = UIImageJPEGRepresentation(chooseImg, 0.5)
        }
        
        print("\nPICTURE DATA:-->",self.imgData!)
        self.img_Avatar.image = UIImage(data: imgData!)
        picker.dismiss(animated: true, completion: nil)
    }
}












