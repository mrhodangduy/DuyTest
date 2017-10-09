//
//  Assessor_Part2VC.swift
//  Wodule
//
//  Created by QTS Coder on 10/4/17.
//  Copyright © 2017 QTS. All rights reserved.
//

import UIKit

class Assessor_Part2VC: UIViewController {

    @IBOutlet weak var tv_Comment: RoundTextView!
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    
    @IBOutlet var dataTableView: UITableView!
    var backgroundView:UIView!

    @IBOutlet weak var scoreBtn: UIButton!
    
    var isExpanding:Bool!
    var originalHeight:CGFloat!
    var isPlaying:Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        originalHeight = UIScreen.main.bounds.size.height * COMMENTVIEW_HEIGHT
        containerViewHeight.constant = 10
        isExpanding = false
        isPlaying = false
        
        dataTableView.dataSource = self
        dataTableView.delegate = self

        
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

    @IBAction func expandBtnTap(_ sender: Any) {
        
        let button = sender as! UIButton
        
        expand_collapesView(button: button, viewHeight: containerViewHeight, isExpanding: isExpanding, originalHeight: originalHeight)
        
        isExpanding = !isExpanding
    }
    
    @IBAction func nextBtnTap(_ sender: Any) {
        
        let part3VC = UIStoryboard(name: ASSESSOR_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "part3VC") as! Assessor_Part3VC
        self.navigationController?.pushViewController(part3VC, animated: true)
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

extension Assessor_Part2VC:UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Assessor_Part2Cell
        
        cell.lbl_Point.text = "\(indexPath.row + 1)"
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        scoreBtn.setTitle("\(indexPath.row + 1)", for: .normal)
        userDefault.set(indexPath.row + 1, forKey: SCORE_PART2)

        handleCloseView()

    }
}
