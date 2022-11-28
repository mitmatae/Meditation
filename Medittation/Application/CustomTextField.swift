//
//  CustomTextField.swift
//  Medittation
//
//  Created by Алина Матюха on 26.11.2022.
//

import UIKit

@IBDesignable //механизм для настройки любого свойства ключ-значение
class CustomTextField: UITextField {

    //IBIncpectable создает новую строчку настройки в атрибут инспекторе
    //свойство : цвет плейсхолдера
    //UIColor(named: "TextFilderPlaceholderColor") ?? - это указание определенного цвета.
    @IBInspectable var colorPlaceholder:UIColor = .clear {
        didSet {
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: colorPlaceholder])
        }
    }
    
    //свойство : линия под текстфилдом
    @IBInspectable var bottomLineColor: UIColor = .clear {
        //рисуем линию с помощью класса CALayer.
        //y -
        //wight - ширина равна ширине текстфилда
        //self.layer.addSublayer - добавляет слой(линию) на текстфилд
        didSet {
            let bottomLine = CALayer()
            bottomLine.frame = CGRect(x: 0.0, y: self.frame.height + 10, width: self.frame.size.width, height: 1.0)
            bottomLine.backgroundColor = bottomLineColor.cgColor
            self.layer.addSublayer(bottomLine)
        }
    }
    
}
