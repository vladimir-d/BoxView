//
//  TestView.swift
//  BoxViewTesting
//
//  Created by Vlad on 05.12.2020.
//

import UIKit

class TestView: UIView {
    
    let boxView = BoxView()
    
    init(axis: BoxLayout.Axis = .y) {
        super.init(frame: .zero)
        boxView.axis = axis
        addFillingSubview(boxView)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        
    }
    
    func scaToTest() -> [UISemanticContentAttribute] {
        return [.unspecified, .forceLeftToRight, .forceRightToLeft]
    }
    
    func logFrames() {
        boxView.managedViews.forEach { print("--- view: \($0)") }
    }
    
    func checkAllSCAFrames() -> Bool {
        for sca in scaToTest() {
            boxView.semanticContentAttribute = sca
            setNeedsLayout()
            layoutIfNeeded()
            if !checkFrames() {
                return false
            }
        }
        return true
    }

    func checkFrames() -> Bool {
        return true
    }
}
