//
//  LoginViewController.swift
//  BoxViewExample
//
//  Created by Vlad on 5/23/20.
//  Copyright © 2020 Vlad. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {
    
    let nameField = UITextField.alWithText("", hint: "User name")
    
    let passwordField = UITextField.alWithText("", hint: "Password")
    
    let loginButton = UIButton.alWithText("Log in", color: .darkGreen)
    
    let forgotButton = UIButton()
    
    let titleLabel = UILabel.alWithText("Please log in")
    
    static let imgSize = CGSize(width: 24.0, height: 24.0)
    
    let nameImageView = UIImageView.alWithImageName("un.png", size: imgSize)
    
    let passwordImageView = UIImageView.alWithImageName("key.png", size: imgSize)
    
    let useForgotButton = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        boxView.setBorder(color: .black)
        boxView.layer.cornerRadius = 10.0
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        
        loginButton.layer.cornerRadius = 5.0
        loginButton.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 16.0, bottom: 5.0, right: 16.0)
        loginButton.addTarget(self, action:#selector(onClickButton), for: .touchUpInside)
        forgotButton.setTitleColor(.blue, for: .normal)
        
        let btnTitle = NSAttributedString(string: "Forgot password?", attributes:
            [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
             NSAttributedString.Key.foregroundColor: UIColor.blue])
        forgotButton.setAttributedTitle(btnTitle, for: .normal)
        
        boxView.insets = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        boxView.spacing = 20.0
        
        
        //layout 1
//        boxView.items = [
//            nameField.boxZero,
//            passwordField.boxZero,
//            loginButton.boxZero
//        ]
        
//        //layout 2
//        boxView.items = [
//            nameField.boxZero,
//            passwordField.boxZero,
//            loginButton.boxTop(30.0)
//        ]
        
//        //layout 3
//        boxView.items = [
//            nameField.boxZero,
//            passwordField.boxZero,
//            loginButton.boxTop(30.0).boxLeftRight(50.0, 50.0)
//        ]
        
//        //layout 4
//        boxView.items = [
//            nameField.boxZero,
//            passwordField.boxZero,
//            useForgotButton ? forgotButton.boxLeftRight(>=0.0, 0.0) : nil,
//            loginButton.boxTop(30.0).boxLeftRight(50.0, 50.0)
//        ].compactMap{$0}
        
//        //layout 5
//        boxView.items = [
//            titleLabel.xAligned(),
//            nameField.boxZero,
//            passwordField.boxZero,
//            useForgotButton ? forgotButton.boxLeftRight(>=0.0, 0.0) : nil,
//            loginButton.boxTop(30.0).boxLeftRight(50.0, 50.0)
//        ].compactMap{$0}
        
        
        let nameBoxView = BoxView(axis: .x, spacing: 10.0)
        nameBoxView.items = [nameImageView.yAligned(), nameField.boxZero]
        let passwordBoxView = BoxView(axis: .x, spacing: 10.0)
        passwordBoxView.items = [passwordImageView.yAligned(), passwordField.boxZero]

        boxView.items = [
            titleLabel.xAligned(),
            nameBoxView.boxZero,
            passwordBoxView.boxZero,
            useForgotButton ? forgotButton.boxLeftRight(>=0.0, 0.0) : nil,
            loginButton.boxTop(30.0).boxLeftRight(50.0, 50.0)
        ].compactMap{$0}
        
//        boxView.insets = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
//        boxView.spacing = 20.0
//        boxView.items.append(titleLabel.xAligned())
//        boxView.items.append(nameField.boxZero)
//        boxView.items.append(passwordField.boxZero)
//        if (useForgotButton) {
//            boxView.items.append(forgotButton.boxLeftRight(>=0.0, 0.0))
//        }
//        boxView.items.append(loginButton.boxTop(30.0).boxLeftRight(50.0, 50.0))
        
        
        //forgotButton.boxLeftRight(>=0.0, 0.0),

//        let haveForgotButton = true
//
//        let nameBoxView = BoxView(axis: .x, spacing: 10.0)
//        nameBoxView.items = [nameImageView.yAligned(), nameField.boxZero]
//        let passwordBoxView = BoxView(axis: .x, spacing: 10.0)
//        passwordBoxView.items = [passwordImageView.yAligned(), passwordField.boxZero]
//        
//        boxView.items.append(titleLabel.xAligned())
//        boxView.items.append(nameBoxView.boxZero)
//        boxView.items.append(passwordBoxView.boxZero)
////        boxView.items.append(nameField.boxZero)
////        boxView.items.append(passwordField.boxZero)
//    
//        if (haveForgotButton) {
//            boxView.items.append(forgotButton.boxLeftRight(>=0.0, 0.0))
//        }
//        boxView.items.append(button.boxTop(30.0).boxLeftRight(50.0, 50.0))
//        forgotButton.removeFromSuperview()

    }
    
    @objc func onClickButton(sender: UIButton) {
//        self.navigationController?.pushViewController(MixLayoutViewController(), animated: true)
    }
    
}
