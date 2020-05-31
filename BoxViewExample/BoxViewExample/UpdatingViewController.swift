//
//  UpdatingViewController.swift
//  BoxViewExample
//
//  Created by Vlad on 5/13/20.
//  Copyright © 2020 Vladimir Dudkin. All rights reserved.
//

import UIKit

class UpdatingViewController: BaseViewController {

    let btnRowBoxView = BoxView(axis: .y)
    
    let titleLabel = UILabel.alWithText("Updating Layout", color: UIColor.orange.withAlphaComponent(0.3))
    
    let textLabel1 = UILabel.alWithText("Any layouting parameter can be updated dynamically and animated.", color: UIColor.yellow.withAlphaComponent(0.3))
    
    let textLabel2 = UILabel.alWithText("BoxView axis and any item in boxView.items also can be changed with animation.", color: UIColor.yellow.withAlphaComponent(0.3))
    
    var fourButtons = [UIButton]()

    let spacingButton = UIButton.alWithText(" Change spacing ", color: .darkGreen)
    
    let axisButton = UIButton.alWithText(" Change axis ", color: .darkGreen)
    
    let btnBoxView = BoxView(axis: .x)
    
    let backButton = UIButton.alWithText(" < Back ", color: .darkGreen)
    
    let nextButton = UIButton.alWithText(" Next > ", color: .darkGreen)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        spacingButton.addTarget(self, action:#selector(onClickSpacingButton), for: .touchUpInside)
        backButton.addTarget(self, action:#selector(onClickBackButton), for: .touchUpInside)
        axisButton.addTarget(self, action:#selector(onClickAxisButton), for: .touchUpInside)
        fourButtons = (0..<4).map {
            let btn = UIButton.alWithText("\($0 + 1)", color: .darkGreen)
            btn.addTarget(self, action:#selector(onClickFourButton), for: .touchUpInside)
            btn.contentHorizontalAlignment = .center
            return btn
        }
        boxView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        btnRowBoxView.layer.borderColor = UIColor.black.cgColor
        btnRowBoxView.layer.borderWidth = 2.0
        
        backButton.addTarget(self, action:#selector(onClickBackButton), for: .touchUpInside)
        nextButton.addTarget(self, action:#selector(onClickNextButton), for: .touchUpInside)
        btnBoxView.layer.borderColor = UIColor.black.cgColor
        btnBoxView.layer.borderWidth = 1.0
        
        //All layouting code is here:
        boxView.insets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        boxView.spacing = 2.0
        btnRowBoxView.insets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        btnRowBoxView.spacing = 10.0
        btnRowBoxView.items = fourButtons.boxZero
        btnBoxView.items = [
            backButton.boxXY(.xPins(10.0, >=10.0), .yPins(10.0, 10.0)),
            nextButton.boxXY(.xPins(10.0, 10.0), .yPins(10.0, 10.0)),
        ]
        boxView.items = [
            titleLabel.xAligned(padding: 16.0),
            textLabel1.boxLeftRight(0.0, 50.0).boxTopBottom(5.0, 0.0),
            spacingButton.boxZero,
            textLabel2.boxLeftRight(50.0, 0.0),
            axisButton.xAligned(padding: 50.0),
            btnRowBoxView.xAligned(padding: 50.0).boxTopBottom(5.0, 0.0),
            btnBoxView.boxTop(10.0)
        ]
    }

    
    @objc func onClickSpacingButton(sender: UIButton) {
        boxView.spacing = (boxView.spacing == 2.0) ? 20.0 : 2.0
        boxView.animateChangesWithDurations(0.5)

    }
    
    @objc func onClickFourButton(sender: UIButton) {
        let ind = fourButtons.firstIndex(of: sender)
        if let ind = ind {
            let element = fourButtons.remove(at: ind)
            if ind == 0 {
                fourButtons.insert(element, at: 3)
            }else {
                fourButtons.insert(element, at: 0)
            }
            btnBoxView.items = fourButtons.boxZero
            boxView.animateChangesWithDurations(0.5)
        }
    }
    
    @objc func onClickAxisButton(sender: UIButton) {
        btnBoxView.axis = btnBoxView.axis.other
        boxView.animateChangesWithDurations(0.5)
    }
    
    @objc func onClickBackButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func onClickNextButton(sender: UIButton) {
        self.navigationController?.pushViewController(LoginViewController(), animated: true)
    }

}
