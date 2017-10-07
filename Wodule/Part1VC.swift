//
//  Part2VC.swift
//  Wodule
//
//  Created by QTS Coder on 10/3/17.
//  Copyright © 2017 QTS. All rights reserved.
//

import UIKit
import JWGCircleCounter


class Part1VC: UIViewController {
    
    @IBOutlet weak var circleTime: JWGCircleCounter!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lbl_CountdownTime: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var viewbackground: UIView!
    @IBOutlet weak var image_Question: UIImageViewX!
    @IBOutlet weak var tv_Data: UITextView!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var decreaseBtn: UIButtonX!
    @IBOutlet weak var increaseBtn: UIButtonX!
    
    var Exam = [CategoriesExam]()
    
    var time:Timer!
    var expectTime:TimeInterval = timeCoutdown
    var minutes:Int!
    var seconds:Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tv_Data.font = UIFont.systemFont(ofSize: fontSizeDefaultTV)
        
        let index = Exam.index(where: { $0.number == 1 })
        print(Exam[index!])
        
        circleTime.circleTimerWidth = 2
        circleTime.circleBackgroundColor = .clear
        circleTime.circleColor = .white
        circleTime.delegate = self
        
        image_Question.isHidden = true
        tv_Data.isHidden = true
        
        if Exam[index!].photo != nil
        {
            lbl_Title.text = TITLEPHOTO
            image_Question.isHidden = false
            decreaseBtn.isHidden = true
            increaseBtn.isHidden = true
            image_Question.contentMode = .scaleAspectFit
            image_Question.sd_setIndicatorStyle(.white)
            image_Question.sd_showActivityIndicatorView()
            image_Question.sd_setShowActivityIndicatorView(true)
            image_Question.sd_setImage(with: URL(string: Exam[index!].photo!), placeholderImage: nil, options: [.continueInBackground]) { (iamge, error, type, url) in
                
                self.circleTime.start(withSeconds: timeInitial)
                
            }

        }
        else
        {
            lbl_Title.text = TITLESTRING
            tv_Data.isHidden = false
            tv_Data.text = Exam[index!].questioner!
            circleTime.start(withSeconds: timeInitial)
            
        }
        
        minutes = Int(expectTime) / 60
        seconds = Int(expectTime) % 60
        lbl_CountdownTime.text = String(format: "%02d:%02d", minutes, seconds)
        
        lbl_CountdownTime.isHidden = true
        nextBtn.isHidden = true
        
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

    
    func createrCountdownTimer()
    {
        time = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
    }
    func updateTime()
    {
        
        if(expectTime > 0){
            minutes = Int(expectTime) / 60
            seconds = Int(expectTime) % 60
            lbl_CountdownTime.text = String(format: "%02d:%02d", minutes, seconds)
            expectTime -= 1
        }
        else
        {
            lbl_CountdownTime.text = "DONE"
            time.invalidate()
        }
    }
    
    
    @IBAction func nextBtnTap(_ sender: Any) {
        let part2VC = UIStoryboard(name: EXAMINEE_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "part2VC") as! Part2VC
        
        part2VC.Exam = self.Exam
        
        self.navigationController?.pushViewController(part2VC, animated: true)
    }
    
}

extension Part1VC: JWGCircleCounterDelegate
{
    func circleCounterTimeDidExpire(_ circleCounter: JWGCircleCounter!) {
        lbl_CountdownTime.isHidden = false
        createrCountdownTimer()
        UIView.animate(withDuration: expectTime, delay: 1, options: [], animations: {
            self.viewbackground.frame.size.width = self.containerView.frame.size.width
            self.view.layoutIfNeeded()
        }) { (done) in
            self.nextBtn.isHidden = false
        }
        
    }
}









