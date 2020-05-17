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
