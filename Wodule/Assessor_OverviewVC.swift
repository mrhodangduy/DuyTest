//
//  Assessor_OverviewVC.swift
//  Wodule
//
//  Created by QTS Coder on 10/4/17.
//  Copyright © 2017 QTS. All rights reserved.
//

import UIKit

class Assessor_OverviewVC: UIViewController {
    
    var isPlaying:Bool!
    @IBOutlet var dataTableView: UITableView!
    var backgroundView:UIView!
    var currentIndex:Int!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isPlaying = false
        dataTableView.dataSource = self
        dataTableView.delegate = self
        
        let score_Part1 = userDefault.object(forKey: SCORE_PART1) as? Int
        let score_Part2 = userDefault.object(forKey: SCORE_PART2) as? Int
        let score_Part3 = userDefault.object(forKey: SCORE_PART3) as? Int
        let score_Part4 = userDefault.object(forKey: SCORE_PART4) as? Int
        
        if score_Part1 != nil
        {
            part1_ScoreBtn.setTitle("\(score_Part1!)", for: .normal)
        }
        if score_Part2 != nil
        {
            part2_ScoreBtn.setTitle("\(score_Part2!)", for: .normal)
        }
        if score_Part3 != nil
        {
            part3_ScoreBtn.setTitle("\(score_Part3!)", for: .normal)
        }
        if score_Part4 != nil
        {
            part4_ScoreBtn.setTitle("\(score_Part4!)", for: .normal)
        }
        
    }
    
    //Part1
    @IBOutlet weak var background1: UIView!
    @IBOutlet weak var runningView1: UIView!
    @IBOutlet weak var part1_ScoreBtn: UIButton!
    
    @IBAction func part1_playAudioTap(_ sender: Any) {
        
        let button = sender as! UIButton
        play_pauseAudio(button: button, isPlay: isPlaying)
        if !isPlaying
        {
            UIView.animate(withDuration: 10, animations: {
                self.runningView1.frame.size.width = self.background1.frame.size.width
                self.view.layoutIfNeeded()
            }, completion: { (done) in
                self.runningView1.frame.size.width = 0
                button.setImage(#imageLiteral(resourceName: "btn_play"), for: .normal)
            })
        }
    }
    
    @IBAction func part1_viewTextTap(_ sender: Any) {
    }
    @IBAction func part1_ScoreTap(_ sender: Any) {
        
        currentIndex = 1
        configView()
    }
    
    
    //Part2
    @IBOutlet weak var background2: UIView!
    @IBOutlet weak var runningView2: UIView!
    @IBOutlet weak var part2_ScoreBtn: UIButton!
    
    @IBAction func part2_PlayAudioTap(_ sender: Any) {
        let button = sender as! UIButton
        play_pauseAudio(button: button, isPlay: isPlaying)
        if !isPlaying
        {
            UIView.animate(withDuration: 10, animations: {
                self.runningView2.frame.size.width = self.background2.frame.size.width
                self.view.layoutIfNeeded()
            }, completion: { (done) in
                self.runningView2.frame.size.width = 0
                button.setImage(#imageLiteral(resourceName: "btn_play"), for: .normal)
            })
        }
    }
    @IBAction func part2_ViewPhotoTap(_ sender: Any) {
    }
    @IBAction func part2_ScoreTap(_ sender: Any) {
        
        currentIndex = 2
        configView()
    }
    
    //Part3
    @IBOutlet weak var background3: UIView!
    @IBOutlet weak var runningView3: UIView!
    @IBOutlet weak var part3_ScoreBtn: UIButton!
    
    @IBAction func part3_PlayAudioTap(_ sender: Any) {
        let button = sender as! UIButton
        play_pauseAudio(button: button, isPlay: isPlaying)
        if !isPlaying
        {
            UIView.animate(withDuration: 10, animations: {
                self.runningView3.frame.size.width = self.background3.frame.size.width
                self.view.layoutIfNeeded()
            }, completion: { (done) in
                self.runningView3.frame.size.width = 0
                button.setImage(#imageLiteral(resourceName: "btn_play"), for: .normal)
            })
        }
    }
    @IBAction func part3_ScoreTap(_ sender: Any) {
        
        currentIndex = 3
        configView()
        
    }
    
    //Part4
    @IBOutlet weak var background4: UIView!
    @IBOutlet weak var runningView4: UIView!
    @IBOutlet weak var part4_ScoreBtn: UIButton!
    
    @IBAction func part4_PlayAudioTap(_ sender: Any) {
        let button = sender as! UIButton
        play_pauseAudio(button: button, isPlay: isPlaying)
        if !isPlaying
        {
            UIView.animate(withDuration: 10, animations: {
                self.runningView4.frame.size.width = self.background4.frame.size.width
                self.view.layoutIfNeeded()
            }, completion: { (done) in
                self.runningView4.frame.size.width = 0
                button.setImage(#imageLiteral(resourceName: "btn_play"), for: .normal)
            })
        }
    }
    @IBAction func part4_ScoreTap(_ sender: Any) {
        
        currentIndex = 4
        configView()
    }
    
    @IBAction func submitTap(_ sender: Any) {
        
        let score_Part1 = userDefault.object(forKey: SCORE_PART1) as? Int
        let score_Part2 = userDefault.object(forKey: SCORE_PART2) as? Int
        let score_Part3 = userDefault.object(forKey: SCORE_PART3) as? Int
        let score_Part4 = userDefault.object(forKey: SCORE_PART4) as? Int
        
        if score_Part1 == nil
        {
            self.alertMissingText(mess: "Part 1 must be assigned a score.", textField: nil)
        }
        else if score_Part2 == nil
        {
            self.alertMissingText(mess: "Part 2 must be assigned a score.", textField: nil)
        }
        else if score_Part3 == nil
        {
            self.alertMissingText(mess: "Part 3 must be assigned a score.", textField: nil)
        }
        else if score_Part4 == nil
        {
            self.alertMissingText(mess: "Part 4 must be assigned a score.", textField: nil)
        }
        else
        {
            
            let accountingVC = UIStoryboard(name: ASSESSOR_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "accountingVC") as! Assessor_AccountingVC
            self.navigationController?.pushViewController(accountingVC, animated: true)
            removeScoreObject()
        }
        
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
    
    func configView()
    {
        let height:CGFloat = self.view.frame.height * (2/3)
        setupViewData(subView: dataTableView, height: height)
        createAnimatePopup(from: dataTableView, with: backgroundView)
        dataTableView.reloadData()
    }
    
    func removeScoreObject()
    {
        userDefault.removeObject(forKey: SCORE_PART1)
        userDefault.removeObject(forKey: SCORE_PART2)
        userDefault.removeObject(forKey: SCORE_PART3)
        userDefault.removeObject(forKey: SCORE_PART4)
        userDefault.synchronize()
    }
    
    
}

extension Assessor_OverviewVC:UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Assessor_OverViewCell
        
        cell.lbl_Point.text = "\(indexPath.row + 1)"
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch currentIndex {
        case 1:
            part1_ScoreBtn.setTitle("\(indexPath.row + 1)", for: .normal)
            userDefault.set(indexPath.row + 1, forKey: SCORE_PART1)
        case 2:
            part2_ScoreBtn.setTitle("\(indexPath.row + 1)", for: .normal)
            userDefault.set(indexPath.row + 1, forKey: SCORE_PART2)
        case 3:
            part3_ScoreBtn.setTitle("\(indexPath.row + 1)", for: .normal)
            userDefault.set(indexPath.row + 1, forKey: SCORE_PART3)
        case 4:
            part4_ScoreBtn.setTitle("\(indexPath.row + 1)", for: .normal)
            userDefault.set(indexPath.row + 1, forKey: SCORE_PART4)
        default:
            return
        }
        
        userDefault.synchronize()
        handleCloseView()
    }
}


