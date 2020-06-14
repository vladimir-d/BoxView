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
    
    class func alWithText(_ text: String?, color: UIColor = .clear, textColor: UIColor = .black, font: UIFont? = nil, numberOfLines: Int? = nil) -> UILabel {
        let label = UILabel.newAL()
        label.text = text
        label.backgroundColor = color
        label.textColor = textColor
        if let font = font {
            label.font = font
        }
        if let numberOfLines = numberOfLines {
            label.numberOfLines = numberOfLines
        }
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

extension UIImageView {
    
    class func alWithImageName(_ imageName: String, size: CGSize? = nil) -> UIImageView {
        let img = UIImage(named: imageName)
        let imgSize = size ?? img?.size ?? .zero
        let imgView = UIImageView(image: img)
        imgView.alSetSize(imgSize)
        return imgView
    }
    
    class func alAspectFitWithImageName(_ imageName: String) -> UIImageView {
        let imgView = UIImageView()
        imgView.setAspectFitImageWithName(imageName)
        return imgView
    }
    
    func setAspectFitImageWithName(_ imageName: String?) {
//        let img = UIImage(named: imageName)
        image =  UIImage(named: imageName ?? "")
        contentMode = .scaleAspectFit
        alSetSetAspectFromSize(image?.size ?? .zero)
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
    
    static func grayScale(_ white: CGFloat) -> UIColor {
        return UIColor(white: white, alpha: 1.0)
    }
}

extension UIEdgeInsets {
    
    static func all(_ value: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: value, left: value, bottom: value, right: value)
    }
}
