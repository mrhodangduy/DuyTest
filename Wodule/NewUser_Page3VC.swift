//
//  NewUser_Page3VC.swift
//  Wodule
//
//  Created by QTS Coder on 10/2/17.
//  Copyright © 2017 QTS. All rights reserved.
//

import UIKit

class NewUser_Page3VC: UIViewController {
    
    @IBOutlet weak var tf_Status: UITextField!
    @IBOutlet weak var tf_Religion: UITextField!
    @IBOutlet weak var tf_Gender: UITextField!
    @IBOutlet weak var tf_Username: UITextField!
    @IBOutlet weak var tf_Password: UITextField!
    @IBOutlet weak var tf_Code: UITextField!
    @IBOutlet weak var img_Avatar: UIImageViewX!
    
    @IBOutlet var dataTableView: UITableView!
    
    var backgroundView:UIView!
    var currentIndex: Int!
    
    var imgData:Data!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataTableView.dataSource = self
        dataTableView.delegate = self
        
        tf_Gender.tintColor = .clear
        tf_Status.tintColor = .clear
    }
    
    @IBAction func statusBtnTap(_ sender: Any) {
        
        currentIndex = 1
        setupViewData(subView: dataTableView, height: CGFloat(Status.count) * 44)
        createAnimatePopup(from: dataTableView, with: backgroundView)
        dataTableView.reloadData()
        
    }
    
    @IBAction func genderBtnTap(_ sender: Any) {
        
        currentIndex = 2
        setupViewData(subView: dataTableView, height: CGFloat(Gender.count) * 44)
        createAnimatePopup(from: dataTableView, with: backgroundView)
        dataTableView.reloadData()
        
    }
    
    @IBAction func imgAvatarTap(_ sender: UITapGestureRecognizer) {
        
        handleGetImage(title: nil, mess: nil, type: .actionSheet)
    }
    
    @IBAction func backPageTap(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func resetBtnTap(_ sender: Any) {
        
        self.navigationController?.popToRootViewController(animated: true)
        
        
    }
    
    func saveData()
    {
        userDefault.set(tf_Status.text!, forKey: STATUS_STRING)
        userDefault.set(tf_Gender.text!, forKey: GENDER_STRING)
        userDefault.set(tf_Username.text!, forKey: USERNAME_STRING)
        userDefault.set(tf_Password.text!, forKey: PASSWORD_STRING)
        userDefault.set(tf_Code.text!, forKey: CODE_STRING)
        userDefault.set(tf_Religion.text!, forKey: RELIGION_STRING)
        userDefault.synchronize()

    }
    
    @IBAction func submitBtnTap(_ sender: Any) {
        
        let checkey = checkValidateTextField(tf1: tf_Status, tf2: tf_Gender, tf3: tf_Username, tf4: tf_Password, tf5: tf_Code, tf6: nil)
        
        switch checkey {
        case 1:
            self.alertMissingText(mess: "Status is required", textField: nil)
        case 2:
            self.alertMissingText(mess: "Gender is required", textField: nil)
        case 3:
            self.alertMissingText(mess: "Username is required", textField: tf_Username)
        case 4:
            self.alertMissingText(mess: "Password is required", textField: tf_Password)
        case 5:
            self.alertMissingText(mess: "Code is required", textField: tf_Code)
        default:
            
            saveData()
            
            let newuser = UIStoryboard(name: MAIN_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "selfieVC") as! NewUser_Page4VC
            newuser.imageData = imgData
            self.navigationController?.pushViewController(newuser, animated: true)
            
        }
        
    }
    
    // MARK: - Handle ActionAlert
    
    func handleGetImage(title: String?, mess: String?, type: UIAlertControllerStyle)
    {
        let alert = UIAlertController(title: title, message: mess, preferredStyle: type)
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

extension NewUser_Page3VC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NewUser3_TableViewCell
        
        if currentIndex == 1
        {
            cell.lbl_Name.text = Status[indexPath.row]
        }
        else
        {
            cell.lbl_Name.text = Gender[indexPath.row]
        }
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if currentIndex == 1
        {
            self.tf_Status.text = Status[indexPath.row]
        }
        else
        {
            self.tf_Gender.text = Gender[indexPath.row]
        }
        
        handleCloseView()
    }
    
    
}

extension NewUser_Page3VC: UIImagePickerControllerDelegate, UINavigationControllerDelegate
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
        
        print(self.imgData!)
        self.img_Avatar.image = UIImage(data: imgData!)
        picker.dismiss(animated: true, completion: nil)
    }
}





