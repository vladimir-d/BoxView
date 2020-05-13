//
//  UpdatingViewController.swift
//  BoxViewExample
//
//  Created by Vlad on 5/13/20.
//  Copyright © 2020 Vladimir Dudkin. All rights reserved.
//

import UIKit

class UpdatingViewController: BaseViewController {

    let btnBoxView = BoxView(axis: .vertical)
    let titleLabel = UILabel.withText("Updating Layout", color: .red)
    let textLabel1 = UILabel.withText("Any layouting paranmeter can be updated dynamically and animated.", color: .lightGray)
    let textLabel2 = UILabel.withText("BoxView axis and any item in boxView.items also can be changed with animation.", color: .lightGray)
    var fourButtons = [UIButton]()

    let spacingButton = UIButton.withText(" Change spacing ", color: .green)
    let axisButton = UIButton.withText(" Change axis ", color: .green)
    let backButton = UIButton.withText(" < Back ", color: .green)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        spacingButton.addTarget(self, action:#selector(onClickSpacingButton), for: .touchUpInside)
        backButton.addTarget(self, action:#selector(onClickBackButton), for: .touchUpInside)
        axisButton.addTarget(self, action:#selector(onClickAxisButton), for: .touchUpInside)
        fourButtons = (0..<4).map {
            let btn = UIButton.withText("\($0 + 1)", color: .green)
            btn.addTarget(self, action:#selector(onClickFourButton), for: .touchUpInside)
            btn.contentHorizontalAlignment = .center
            return btn
        }
        boxView.backgroundColor = .yellow
        btnBoxView.layer.borderColor = UIColor.black.cgColor
        btnBoxView.layer.borderWidth = 2.0
        
        //All layouting code is here:
        boxView.insets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        boxView.spacing = 2.0
        btnBoxView.insets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        btnBoxView.spacing = 10.0
        btnBoxView.setViews(fourButtons)
        boxView.items = [
            titleLabel.hv(.align(padding: 16.0), .zero),
            textLabel1.hv(.leftRight(0.0, 50.0), .topBottom(5.0, 0.0)),
            spacingButton.zeroLayout,
            textLabel2.hv(.leftRight(50.0, 0.0), .zero),
            axisButton.hv(.align(padding: 50.0), .zero),
            btnBoxView.hv(.align(padding: 50.0), .pins(10.0, 10.0)),
            backButton.zeroLayout
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
            btnBoxView.setViews(fourButtons)
            boxView.animateChangesWithDurations(0.5)
        }
    }
    
    @objc func onClickBackButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func onClickAxisButton(sender: UIButton) {
        btnBoxView.axis = btnBoxView.axis.other
        boxView.animateChangesWithDurations(0.5)
    }

}
