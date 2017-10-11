//
//  Part1VC.swift
//  Wodule
//
//  Created by QTS Coder on 10/3/17.
//  Copyright © 2017 QTS. All rights reserved.
//

import UIKit
import JWGCircleCounter

class Part2VC: UIViewController {
    
    @IBOutlet weak var circleTime: JWGCircleCounter!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var recordingMess: UILabelX!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var tv_Data: UITextView!
    @IBOutlet weak var img_Photo: UIImageViewX!
    @IBOutlet weak var decreaseBtn: UIButtonX!
    @IBOutlet weak var increaseBtn: UIButtonX!
    @IBOutlet weak var lbl_Title: UILabel!
    
    var expectTime:TimeInterval = timeCoutdown
    var Exam = [CategoriesExam]()
    
    let token = userDefault.object(forKey: TOKEN_STRING) as? String

    
    let userID = userDefault.object(forKey: USERID_STRING) as? Int
    var examID:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AudioRecorderManager.shared.recorder?.prepareToRecord()

        
        tv_Data.font = UIFont.systemFont(ofSize: fontSizeDefaultTV)
        
        circleTime.circleBackgroundColor = .clear
        circleTime.circleColor = .white
        circleTime.circleTimerWidth = 2
        circleTime.delegate = self
        recordingMess.isHidden = true
        nextBtn.isHidden = true
        
        guard let index = Exam.index(where: { $0.number == 2 }) else { return }
        print("\n\n",Exam[index])
        examID = Exam[index].identifier
        
        img_Photo.isHidden = true
        tv_Data.isHidden = true
        
        if Exam[index].photo != nil
        {
            lbl_Title.text = TITLEPHOTO
            img_Photo.isHidden = false
            decreaseBtn.isHidden = true
            increaseBtn.isHidden = true
            img_Photo.contentMode = .scaleAspectFit
            img_Photo.sd_setIndicatorStyle(.white)
            img_Photo.sd_showActivityIndicatorView()
            img_Photo.sd_setShowActivityIndicatorView(true)
            img_Photo.sd_setImage(with: URL(string: Exam[index].photo!), placeholderImage: nil, options: [.continueInBackground]) { (iamge, error, type, url) in
                
                self.circleTime.start(withSeconds: timeInitial)
                
            }
            
        }
        else
        {
            lbl_Title.text = TITLESTRING
            tv_Data.isHidden = false
            tv_Data.text = Exam[index].questioner!
            circleTime.start(withSeconds: timeInitial)
            
        }

        
        
        
    }
    
    @IBAction func decreaseSizeTap(_ sender: Any) {
        
        if Int((tv_Data.font?.pointSize)!) > 10
        {
            tv_Data.font = UIFont.systemFont(ofSize: (tv_Data.font?.pointSize)! - 1)
            
        }
        
    }
    
    @IBAction func increaseSizeTap(_ sender: Any) {
        
        tv_Data.font = UIFont.systemFont(ofSize: (tv_Data.font?.pointSize)! + 1)

    }
    
    @IBAction func nextBtnTap(_ sender: Any) {
        let part3_tempVC = UIStoryboard(name: EXAMINEE_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "part3_tempVC") as! Part3_TempVC
        
        part3_tempVC.Exam = self.Exam
                
        self.navigationController?.pushViewController(part3_tempVC, animated: true)
    }
    
}

extension Part2VC: JWGCircleCounterDelegate
{
    func circleCounterTimeDidExpire(_ circleCounter: JWGCircleCounter!) {
        
        var audioURL:NSURL?
        self.StarRecording(userID: userID!, examID: examID) { (audioURLs:NSURL?) in
            audioURL = audioURLs
        }

        self.recordingMess.isHidden = false
        UIView.animate(withDuration: expectTime, animations: {
            self.viewBackground.frame.size.width = self.containerView.frame.size.width
            self.view.layoutIfNeeded()
        }, completion: { (done) in
            self.recordingMess.text = "Time Out"
            self.nextBtn.isHidden = false
            self.stopRecord(audioURL: audioURL)
            self.uploadRecord(token: self.token!, userID: self.userID!, examID: self.examID)
            
        })
        
    }
}











