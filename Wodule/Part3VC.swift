//
//  Part3VC.swift
//  Wodule
//
//  Created by QTS Coder on 10/3/17.
//  Copyright © 2017 QTS. All rights reserved.
//

import UIKit
import JWGCircleCounter

class Part3VC: UIViewController {

    @IBOutlet weak var circleTime: JWGCircleCounter!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var viewbackground: UIView!
    @IBOutlet weak var lbl_CountdownTime: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    
    var Exam = [CategoriesExam]()
    
    var time:Timer!
    var expectTime:TimeInterval = timeCoutdown
    var minutes:Int!
    var seconds:Int!

    let token = userDefault.object(forKey: TOKEN_STRING) as? String


    override func viewDidLoad() {
        super.viewDidLoad()
        
        circleTime.circleTimerWidth = 2
        circleTime.start(withSeconds: timeInitial)
        circleTime.circleBackgroundColor = .clear
        circleTime.circleColor = .white
        circleTime.delegate = self
        
        minutes = Int(expectTime) / 60
        seconds = Int(expectTime) % 60
        lbl_CountdownTime.text = String(format: "%02d:%02d", minutes, seconds)
        
        lbl_CountdownTime.isHidden = true
        nextBtn.isHidden = true

        // Do any additional setup after loading the view.
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
        
        let part4VC = UIStoryboard(name: EXAMINEE_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "part4VC") as! Part4VC
        self.navigationController?.pushViewController(part4VC, animated: true)
    }

    
}

extension Part3VC: JWGCircleCounterDelegate
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
