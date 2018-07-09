//
//  MyTextField.swift
//  Homepwner
//
//  Created by Alpaca on 2018. 7. 10..
//  Copyright © 2018년 Alpaca. All rights reserved.
//

import UIKit

class MyTextField: UITextField {
    
    override func becomeFirstResponder() -> Bool {
        borderStyle = .line
        
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        borderStyle = .roundedRect
        
        return super.resignFirstResponder()
    }
    
}
