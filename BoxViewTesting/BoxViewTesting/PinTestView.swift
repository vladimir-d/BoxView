//
//  PinTestView.swift
//  BoxViewTesting
//
//  Created by Vlad on 13.12.2020.
//

import UIKit

class PinTestView: TestView {

    let v = UIView()
    let v1 = UIView(color: .orange).al
    let f1 = CGRect.xywh(7.0, 20.0, 10.0, 5.0)
    let edges = UIEdgeInsets.tlbr(1.0, 3.0, 2.0, 9.0)
    let insets = UIEdgeInsets.tlbr(110.0, 30.0, 420.0, 90.0)
    
    override func setup() {
        v.backgroundColor = .red
        boxView.insets = insets
        boxView.items = [v.boxed.left(edges.left).top(edges.top).right(edges.right).bottom(edges.bottom)]
        boxView.addSubview(v1)
        
        v1.pin(.left, to: .left, of: v, offset: f1.origin.x, sca: boxView.semanticContentAttribute)
        v1.pin(.top, to: .bottom, of: v, offset: f1.origin.y, sca: boxView.semanticContentAttribute)
        v1.pinWidth(f1.width)
        v1.pinHeight(to: v, pin: ==f1.height)
    }

    override func checkFrames() -> Bool {
        let mInsets = insets.modified(sca: boxView.semanticContentAttribute)
        let mEdges = edges.modified(sca: boxView.semanticContentAttribute)
        let actualInsets = mInsets + mEdges
        print("------------")
        print("insets: \(actualInsets)")
        let fr = frame.inset(by: actualInsets)
        var fr1 = CGRect.zero
        let langDir = UIView.userInterfaceLayoutDirection(for: boxView.semanticContentAttribute)
        let rtl = (langDir == .rightToLeft)
        if rtl {
            fr1.origin.x = fr.maxX - f1.size.width - f1.origin.x
        }
        else {
            fr1.origin.x = fr.origin.x + f1.origin.x
        }
        
        fr1.origin.y = fr.maxY + f1.origin.y
        fr1.size = CGSize(width: f1.width, height: fr.size.height + f1.height)
        return v1.checkFrame(fr1)
    }
}
