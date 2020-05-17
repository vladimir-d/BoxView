//
//  SimpleSampleViewController.swift
//  BoxViewExample
//
//  Created by Vlad on 5/11/20.
//  Copyright © 2020 Vladimir Dudkin. All rights reserved.
//

import UIKit

class MixLayoutViewController: BaseViewController {
    
    let btnBoxView = BoxView(axis: .horizontal)
    let button1 = UIButton.alWithText(" < Back ", color: .green)
    let titleLabel = UILabel.alWithText("Mixed Layout", color: .red)
    let textLabel1 = UILabel.alWithText("This is an example of vertical box where child views  have additional layouting:\nTitle is placed in center with minimum padding from both sides.\nBoth text label has differnt padding from both sides.", color: .lightGray)
    let textLabel2 = UILabel.alWithText("Last stack item is another boxView with horizontal layout containing two buttons.\nAny of these views can be skiped in boxView.items, without affecting other views.", color: .lightGray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        button1.addTarget(self, action:#selector(onClickButton1), for: .touchUpInside)
        let button2 = UIButton.alWithText(" Next > ", color: .green)
        button2.addTarget(self, action:#selector(onClickButton2), for: .touchUpInside)
        boxView.backgroundColor = .yellow
        btnBoxView.layer.borderColor = UIColor.black.cgColor
        btnBoxView.layer.borderWidth = 1.0
        
        //All layouting code is here:
        boxView.insets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        btnBoxView.items = [
            button1.hv(.pins(10.0, >=10.0), .pins(10.0, 10.0)),
            button2.hv(.pins(10.0, 10.0), .pins(10.0, 10.0)),
        ]
        boxView.items = [
            titleLabel.hv(.align(padding: 16.0), .zero),
            textLabel1.hv(.pins(0.0, 50.0), .pins(5.0, 0.0)),
            textLabel2.hv(.pins(50.0, 0.0), .pins(5.0, 0.0)),
            btnBoxView.hv(.pins(50.0, 50.0), .pins(10.0, >=10.0)),
        ]
    }
    
    @objc func onClickButton1(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func onClickButton2(sender: UIButton) {
        self.navigationController?.pushViewController(UpdatingViewController(), animated: true)
    }

}


