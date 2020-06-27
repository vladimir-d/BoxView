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
    
    let titleLabel = UILabel.alWithText("Please log into account with your user name and password", font: .boldSystemFont(ofSize: 22), numberOfLines: 0)
    
    static let imgSize = CGSize(width: 24.0, height: 24.0)
    
    let nameImageView = UIImageView.alWithImageName("un.png", size: imgSize)
    
    let passwordImageView = UIImageView.alWithImageName("key.png", size: imgSize)
        
    let errorLabel = UILabel.alWithText(" Field can not be empty!", textColor: .red)
    
    let nameBoxView = BoxView(axis: .x, spacing: 10.0)
    
    let passwordBoxView = BoxView(axis: .x, spacing: 10.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Login"
        titleLabel.textAlignment = .center
        boxView.setBorder(color: .black)
        boxView.layer.cornerRadius = 10.0
        loginButton.layer.cornerRadius = 5.0
        loginButton.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 16.0, bottom: 5.0, right: 16.0)
        loginButton.addTarget(self, action:#selector(onClickButton), for: .touchUpInside)
        forgotButton.setTitleColor(.blue, for: .normal)
        let btnTitle = NSAttributedString(string: "Forgot password?", attributes:
            [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
             NSAttributedString.Key.foregroundColor: UIColor.blue])
        forgotButton.setAttributedTitle(btnTitle, for: .normal)
        nameField.addTarget(self, action:#selector(onChangeTextField), for: .editingChanged)
        passwordField.addTarget(self, action:#selector(onChangeTextField), for: .editingChanged)
        passwordField.isSecureTextEntry = true

        // all layout code is here:
        nameBoxView.items = [nameImageView.boxed.centerY(), nameField.boxed]
        passwordBoxView.items = [passwordImageView.boxed.centerY(), passwordField.boxed]
        boxView.insets = .all(16.0)
        boxView.spacing = 20.0
        boxView.items = [
            titleLabel.boxed.centerX(padding: 30.0).bottom(20.0),
            nameBoxView.boxed,
            passwordBoxView.boxed,
            forgotButton.boxed.left(>=0.0),
            loginButton.boxed.top(30.0).left(50.0).right(50.0),
        ]
    }
    
    
    func showErrorForField(_ field: UITextField) {
        errorLabel.frame = field.convert(field.bounds, to: boxView)
        let item = errorLabel.boxed.top(-boxView.spacing).left(errorLabel.frame.minX - boxView.insets.left)
        boxView.insertItem(item, after: field.superview, z: .back)
//        boxView.sendSubviewToBack(errorLabel)
        boxView.animateChangesWithDurations(0.3)
    }
    
    @objc func onClickButton(sender: UIButton) {
        for field in [nameField, passwordField] {
            if field.text?.isEmpty ?? true {
                showErrorForField(field)
                return
            }
        }
        self.navigationController?.pushViewController(PuppiesViewController(), animated: true)
    }
    
    @objc func onChangeTextField(sender: UITextField) {
        errorLabel.removeFromSuperview()
        boxView.animateChangesWithDurations(0.3)
    }
    
}
