//
//  BaseViewController.swift
//  BoxViewExample
//
//  Created by Vlad on 5/13/20.
//  Copyright © 2020 Vladimir Dudkin. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    let scrollView = UIScrollView()
    let boxView = BoxView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(boxView)
        let boxPadding: CGFloat = 16.0
        boxView.alToSuperviewWithEdgeValues(.all(16.0))
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11, *) {
            let guide = view.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                scrollView.topAnchor.constraint(equalToSystemSpacingBelow: guide.topAnchor, multiplier: 1.0),
                guide.bottomAnchor.constraint(equalToSystemSpacingBelow: scrollView.bottomAnchor, multiplier: 1.0),
                scrollView.leftAnchor.constraint(equalToSystemSpacingAfter:guide.leftAnchor, multiplier: 1.0),
                guide.rightAnchor.constraint(equalToSystemSpacingAfter: scrollView.rightAnchor, multiplier: 1.0)
            ])
        } else {
            scrollView.alToSuperviewWithEdgeValues(.all(20.0))
        }
        boxView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -boxPadding * 2.0).isActive = true
    }

}
