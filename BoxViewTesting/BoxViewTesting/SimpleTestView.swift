//
//  SimpleBoxSCAView.swift
//  BoxViewTesting
//
//  Created by Vlad on 05.12.2020.
//

import UIKit

class SimpleTestView: TestView {

    let v = UIView()
    let edges = UIEdgeInsets.tlbr(1.0, 3.0, 2.0, 9.0)
    let insets = UIEdgeInsets.tlbr(10.0, 30.0, 20.0, 90.0)
    
    override func setup() {
        v.backgroundColor = .red
        boxView.insets = insets
        boxView.items = [v.boxed.left(edges.left).top(edges.top).right(edges.right).bottom(edges.bottom)]
    }

    override func checkFrames() -> Bool {
        let mInsets = insets.modified(sca: boxView.semanticContentAttribute)
        let mEdges = edges.modified(sca: boxView.semanticContentAttribute)
        let actualInsets = mInsets + mEdges
        print("------------")
        print("insets: \(actualInsets)")
        let f1 = frame.inset(by: actualInsets)
        return v.checkFrame(f1)
    }
}
