//
//  FormTextField.swift
//  rphlfc
//
//  Created by Raphael Cerqueira on 15/07/17.
//  Copyright © 2017 Mingo Labs. All rights reserved.
//

import UIKit

@IBDesignable
class FormTextField: UITextField {
    
    @IBInspectable var inset: CGFloat = 0
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: inset, dy: inset)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
}
