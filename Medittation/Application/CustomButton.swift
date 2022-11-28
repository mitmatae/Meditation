//
//  CustomButton.swift
//  Medittation
//
//  Created by Алина Матюха on 26.11.2022.
//

import UIKit
//закругление углов кнопки
@IBDesignable
class CustomButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {self.layer.cornerRadius = cornerRadius}
    }
    
}
