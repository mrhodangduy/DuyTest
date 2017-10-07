//
//  RoundTextView.swift
//  ATAX
//
//  Created by QTS Coder on 8/30/17.
//  Copyright © 2017 QTS. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class RoundTextView: UITextView {
    
    @IBInspectable var conerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = conerRadius
        }
    }
    @IBInspectable var borderWidth:CGFloat = 1 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
        
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
}
