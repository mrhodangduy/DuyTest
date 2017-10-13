//
//  Assessor_Part1VC.swift
//  Wodule
//
//  Created by QTS Coder on 10/4/17.
//  Copyright © 2017 QTS. All rights reserved.
//

import UIKit


class Assessor_Part1VC: UIViewController {
    
    @IBOutlet weak var tv_Content: UITextView!
    @IBOutlet weak var tv_Comment: RoundTextView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var decreaseBtn: UIButtonX!
    @IBOutlet weak var increaseBtn: UIButtonX!
    @IBOutlet weak var img_Question: UIImageViewX!
    
    @IBOutlet var dataTableView: UITableView!
    var backgroundView:UIView!    
    @IBOutlet weak var scoreBtn: UIButton!
    
    var isExpanding:Bool!
    var isPlaying:Bool!
    var originalHeight:CGFloat!
    
    var Exam:NSDictionary!
    
    var score = 0
    let token = userDefault.object(forKey: TOKEN_STRING) as? String

    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalHeight = UIScreen.main.bounds.size.height * COMMENTVIEW_HEIGHT
        containerViewHeight.constant = 10
        isExpanding = false
        isPlaying = false
        
        dataTableView.dataSource = self
        dataTableView.delegate = self
        
        img_Question.contentMode = .scaleAspectFit
        
        
        if ((Exam?["examQuestionaire"] as? String)?.hasPrefix("http://wodule.io/user/"))!
        {
            img_Question.isHidden = false
            
            img_Question.sd_setImage(with: URL(string: Exam["examQuestionaire"] as! String), placeholderImage: nil, options: [], completed: nil)
            increaseBtn.isHidden = true
            decreaseBtn.isHidden = true
            tv_Content.isHidden = true
        }
        else
        {
            img_Question.isHidden = true
            increaseBtn.isHidden = false
            decreaseBtn.isHidden = false
            tv_Content.isHidden = false
            tv_Content.text = Exam["examQuestionaire"] as! String
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tv_Content.isScrollEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tv_Content.isScrollEnabled = true
    
    }
    
    @IBAction func zoomTextTap(_ sender: Any) {
        
        let button = sender as! UIButton
        
        if button.tag == 1
        {
            if Int((tv_Content.font?.pointSize)!) > 10
            {
                tv_Content.font = UIFont.systemFont(ofSize: (tv_Content.font?.pointSize)! - 1)

            }
            
        }
        else if button.tag == 2
        {
            tv_Content.font = UIFont.systemFont(ofSize: (tv_Content.font?.pointSize)! + 1)

        }
        else
        {
            return
        }
        
    }
    
    
    @IBAction func expandBtnTap(_ sender: Any) {
        
        let button = sender as! UIButton
        
        expand_collapesView(button: button, viewHeight: containerViewHeight, isExpanding: isExpanding, originalHeight: originalHeight)        
        
        isExpanding = !isExpanding
        
    }
    
    @IBAction func onClickSubmit(_ sender: Any) {
        
        if score == 0 || tv_Comment.text.trimmingCharacters(in: .whitespacesAndNewlines).characters.count == 0
        {
            self.alertMissingText(mess: "Score and Comment is required.", textField: nil)
        }
        else
        {
            ExamRecord.postGrade(withToken: token!, identifier: Exam["identifier"] as! Int, grade: score, comment: tv_Comment.text, completion: { (status:Bool?, code:Int?, result:NSDictionary?) in
                
                if code == 200 && status!
                {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "post grade"), object: self)
                    self.navigationController?.popViewController(animated: true)
                    
                    print(result!)
                }
                
                else
                {
                    self.alertMissingText(mess: "Failed to grade exam.", textField: nil)
                }
            })
        }
        
    }
    
    
    
    @IBAction func playAudioTap(_ sender: UIButton) {
        
        play_pauseAudio(button: sender, isPlay: isPlaying)
        isPlaying = !isPlaying
        
    }
   
    @IBAction func scoreTap(_ sender: Any) {
        let height:CGFloat = self.view.frame.height * (2/3)
        setupViewData(subView: dataTableView, height: height)
        createAnimatePopup(from: dataTableView, with: backgroundView)
    }
    
    func setupViewData(subView: UIView, height: CGFloat)
    {
        backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        backgroundView.backgroundColor = UIColor.gray
        backgroundView.alpha = 0
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleCloseView))
        tapGesture.numberOfTapsRequired = 2
        backgroundView.addGestureRecognizer(tapGesture)
        
        view.addSubview(backgroundView)
        view.addSubview(subView)
        subView.layer.cornerRadius = 10
        
        let widthView = view.frame.size.width * (4/6)
        let heightView:CGFloat = height
        subView.frame = CGRect(x: view.frame.size.width * (1/6), y: (view.frame.size.height - heightView) / 2 , width: widthView, height: heightView)
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

extension Assessor_Part1VC:UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Assessor_Part1Cell
        
        cell.lbl_Point.text = "\(indexPath.row + 1)"
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        scoreBtn.setTitle("\(indexPath.row + 1)", for: .normal)
        userDefault.set(indexPath.row + 1, forKey: SCORE_PART1)
        
        score = indexPath.row + 1
        
        handleCloseView()
    }
}
















