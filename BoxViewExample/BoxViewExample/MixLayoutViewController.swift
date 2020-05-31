//
//  SimpleSampleViewController.swift
//  BoxViewExample
//
//  Created by Vlad on 5/11/20.
//  Copyright © 2020 Vladimir Dudkin. All rights reserved.
//

import UIKit

class MixLayoutViewController: BaseViewController {
    
    let btnBoxView = BoxView(axis: .x)
    
    let backButton = UIButton.alWithText(" < Back ", color: .darkGreen)
    
    let nextButton = UIButton.alWithText(" Next > ", color: .darkGreen)
    
    let titleLabel = UILabel.alWithText("Mixed Layout", color: UIColor.orange.withAlphaComponent(0.3))
    
    let textLabel1 = UILabel.alWithText("This is an example of vertical box where child views  have additional layouting:\nTitle is placed in center with minimum padding from both sides.\nBoth text label have differnt padding from left and right sides.", color: UIColor.yellow.withAlphaComponent(0.3))
    
    let textLabel2 = UILabel.alWithText("Last stack item is another boxView with horizontal layout containing two buttons.\nAny of these views can be skiped in boxView.items, without affecting other views.", color: UIColor.yellow.withAlphaComponent(0.3))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        boxView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        backButton.addTarget(self, action:#selector(onClickBackButton), for: .touchUpInside)
        nextButton.addTarget(self, action:#selector(onClickNextButton), for: .touchUpInside)
        btnBoxView.layer.borderColor = UIColor.black.cgColor
        btnBoxView.layer.borderWidth = 1.0
        
        //All layouting code is here:
        boxView.insets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        btnBoxView.items = [
            backButton.boxXY(.xPins(10.0, >=10.0), .yPins(10.0, 10.0)),
            nextButton.boxXY(.xPins(10.0, 10.0), .yPins(10.0, 10.0)),
        ]
        boxView.items = [
            titleLabel.xAligned(padding: 16.0),
            textLabel1.boxRight(50.0).boxTop(10.0),
            textLabel2.boxLeft(50.0),
            btnBoxView.boxLeftRight(50.0, 50.0).boxTopBottom(10.0, >=10.0),
        ]
    }
    
    @objc func onClickBackButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func onClickNextButton(sender: UIButton) {
        self.navigationController?.pushViewController(UpdatingViewController(), animated: true)
    }

}


