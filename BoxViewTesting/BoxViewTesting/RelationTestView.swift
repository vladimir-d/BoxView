//
//  RelationTestView.swift
//  BoxViewTesting
//
//  Created by Vlad on 13.12.2020.
//

import UIKit

class RelationTestView: TestView {

    let v = UIView()
    let edges = UIEdgeInsets.tlbr(11.0, 3.0, 2.0, 9.0)
    let insets = UIEdgeInsets.tlbr(10.0, 30.0, 50.0, 170.0)
    let size = CGSize(width: 100.0, height: 200.0)
    
    override func setup() {
        v.backgroundColor = .red
        boxView.insets = insets
        v.setWeekSize(size)
        boxView.items = [v.boxed.left(edges.left).top(edges.top).right(<=edges.right).bottom(>=edges.bottom)]
    }

    override func checkFrames() -> Bool {
        let innerSize = boxView.frame.inset(by: insets).size
        print("innerSize: \(innerSize)")
        var actualEdges = edges
        actualEdges.bottom = innerSize.height - size.height - actualEdges.top
        actualEdges = actualEdges.modified(sca: boxView.semanticContentAttribute)
        let mInsets = insets.modified(sca: boxView.semanticContentAttribute)
        let actualInsets = mInsets + actualEdges

        print("------------")
        print("actualInsets: \(actualInsets)")
        let f1 = frame.inset(by: actualInsets)
        return v.checkFrame(f1)
    }
}
