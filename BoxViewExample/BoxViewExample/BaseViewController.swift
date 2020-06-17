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
        var insets = UIEdgeInsets.zero
        if #available(iOS 11, *) {
            insets = view.safeAreaInsets
        }
        view.addBoxItem(scrollView.boxInsets(insets))
        boxView.alPinWidth(-boxPadding * 2.0, to: scrollView)
    }

}
