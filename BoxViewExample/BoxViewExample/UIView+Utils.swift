//
//  UIView+Utils.swift
//  BoxViewExample
//
//  Created by Vlad on 5/11/20.
//  Copyright © 2020 Vladimir Dudkin. All rights reserved.
//

import UIKit


extension UIView {
    
    func setBorder(color: UIColor, width: CGFloat = 1.0) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    
}

extension UILabel {
    
    class func alWithText(_ text: String?, color: UIColor = .clear, numberOfLines: Int = 0) -> UILabel {
        let label = UILabel.newAL()
        label.text = text
        label.backgroundColor = color
        label.numberOfLines = numberOfLines
        return label
    }
    
}

extension UIButton {
    
    class func alWithText(_ text: String?, color: UIColor = .clear) -> UIButton {
        let button = UIButton.newAL()
        button.setTitle(text, for: .normal)
        button.backgroundColor = color
        return button
    }
    
}

extension UITextField {
    
    class func alWithText(_ text: String?, hint: String?) -> UITextField {
        let tf = UITextField.newAL()
        tf.text = text
        tf.placeholder = hint
        tf.borderStyle = .roundedRect
        return tf
    }
    
}


extension UIColor {
    static let darkGreen = UIColor(red: 0.0, green: 0.7, blue: 0.0, alpha: 1.0)
}
