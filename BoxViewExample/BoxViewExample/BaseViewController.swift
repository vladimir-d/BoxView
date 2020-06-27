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
        let boxPadding: CGFloat = 16.0
        scrollView.addBoxItem(boxView.boxed.all(boxPadding))
        var insets = UIEdgeInsets.zero
        if #available(iOS 11, *) {
            insets = view.safeAreaInsets
        }
        view.addBoxItem(scrollView.boxed.insets(insets))
        boxView.bxPinWidth(-boxPadding * 2.0, to: scrollView)
    }

}
