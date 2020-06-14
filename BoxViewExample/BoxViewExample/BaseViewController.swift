//
//  BaseViewController.swift
//  BoxViewExample
//
//  Created by Vlad on 5/13/20.
//  Copyright © 2020 Vladimir Dudkin. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    let scrollView = UIScrollView.newAL()
    let boxView = BoxView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let boxPadding: CGFloat = 16.0
        scrollView.addBoxItem(boxView.boxAll(boxPadding))
        boxView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11, *) {
            view.addSubview(scrollView)
            let guide = view.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                scrollView.topAnchor.constraint(equalToSystemSpacingBelow: guide.topAnchor, multiplier: 1.0),
                guide.bottomAnchor.constraint(equalToSystemSpacingBelow: scrollView.bottomAnchor, multiplier: 1.0),
                scrollView.leftAnchor.constraint(equalToSystemSpacingAfter:guide.leftAnchor, multiplier: 1.0),
                guide.rightAnchor.constraint(equalToSystemSpacingAfter: scrollView.rightAnchor, multiplier: 1.0)
            ])
        } else {
            view.addBoxItem(scrollView.boxAll(20.0))
        }
        boxView.alWidthPin(==(-boxPadding * 2.0), to: scrollView)
    }

}
