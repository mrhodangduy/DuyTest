//
//  TextFieldMaxLength.swift
//  ATAX
//
//  Created by QTS Coder on 9/1/17.
//  Copyright © 2017 QTS. All rights reserved.
//

import Foundation

import UIKit

private var maxLengths = [UITextField: Int]()

extension UITextField {
    
    @IBInspectable var maxLength: Int {
        
        get {
            
            guard let length = maxLengths[self]
                else {
                    return Int.max
            }
            return length
        }
        set {
            maxLengths[self] = newValue
            addTarget(
                self,
                action: #selector(limitLength),
                for: UIControlEvents.editingChanged
            )
        }
    }
    func limitLength(textField: UITextField) {
        guard let prospectiveText = textField.text,
            prospectiveText.characters.count > maxLength
            else {
                return
        }
        
        let selection = selectedTextRange
        let maxCharIndex = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        text = prospectiveText.substring(to: maxCharIndex)
        selectedTextRange = selection
    }
}
