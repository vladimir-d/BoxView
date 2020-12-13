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
        
        if #available(iOS 11, *) {
            view.addSubview(scrollView)
            let guide = view.safeAreaLayoutGuide
            guide.addBoxItems([scrollView.boxed])
        }
        else {
            view.addBoxItem(scrollView.boxed)
        }
        boxView.pinWidth(to: scrollView, offset: -boxPadding * 2.0)
    }

}
