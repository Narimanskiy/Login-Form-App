//
//  InsertableTextField.swift
//  Login Form App
//
//  Created by Нариман on 21.02.2021.
//

import UIKit

class InsertableTextField: UITextField {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 0.8274509804, green: 0.8274509804, blue: 0.8274509804, alpha: 1)
    }
    

    
    
    
}
