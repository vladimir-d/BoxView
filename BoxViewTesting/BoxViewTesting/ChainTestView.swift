//
//  ChainTestView.swift
//  BoxViewTesting
//
//  Created by Vlad on 13.12.2020.
//

import UIKit

class ChainItem {
    var v: UIView
    var e: UIEdgeInsets
    var s: CGSize
    var f: CGRect = .zero
    
    init(v: UIView, e: UIEdgeInsets, s: CGSize) {
        self.v = v
        self.e = e
        self.s = s
    }
    
}

class ChainTestView: TestView {

    let chainItems = [
        ChainItem(v: UIView(color: .red),
                  e: UIEdgeInsets.tlbr(1.0, 3.0, 4.0, 9.0),
                  s: CGSize.wh(10.0, 30.0)),
        ChainItem(v: UIView(color: .orange),
                  e: UIEdgeInsets.tlbr(5.0, 7.0, 8.0, 4.0),
                  s: CGSize.wh(40.0, 20.0)),
        ChainItem(v: UIView(color: .yellow),
                  e: UIEdgeInsets.tlbr(13.0, 16.0, 19.0, 17.0),
                  s: CGSize.wh(30.0, 70.0)),
    ]
    
    var weakSizeView: UIView?

    let insets = UIEdgeInsets.tlbr(50.0, 30.0, 40.0, 10.0)
    
    override func setup() {
        boxView.insets = insets
        boxView.spacing = 3.0
        weakSizeView = chainItems[0].v
        boxView.items = chainItems.map { ci in
            let priority: UILayoutPriority = (ci.v == chainItems[0].v) ? .fittingSizeLevel : .defaultLow
            if boxView.axis == .x {
                ci.v.setWidth(ci.s.width, priority: priority)
                ci.v.setWeekHeight(ci.s.height)
            }
            else {
                ci.v.setHeight(ci.s.height, priority: priority)
                ci.v.setWeekWidth(ci.s.width)
            }
            return ci.v.boxed.top(ci.e.top).left(ci.e.left).bottom(ci.e.bottom).right(ci.e.right)
        }
    }
    
    func widthExceptWeak() -> CGFloat {
        var w: CGFloat = 0.0
        for ci in chainItems {
            w += ci.e.width
            if ci.v != weakSizeView {
                w += ci.s.width
                w += boxView.spacing
            }
        }
        return w
    }
    
    func heightExceptWeak() -> CGFloat {
        var h: CGFloat = 0.0
        for ci in chainItems {
            h += ci.e.height
            if ci.v != weakSizeView {
                h += ci.s.height
                h += boxView.spacing
            }
        }
        return h
    }

    override func checkFrames() -> Bool {
        let mInsets = insets.modified(sca: boxView.semanticContentAttribute)
        let mItems = chainItems.modified(axis: boxView.axis, sca: boxView.semanticContentAttribute)
        let innerSize = boxView.frame.inset(by: mInsets).size
        print("innerSize: \(innerSize)")
        var p = CGPoint(x: mInsets.left, y: mInsets.top)
        for ci in mItems {
            let e = ci.e.modified(sca: boxView.semanticContentAttribute)
            
            if boxView.axis == .x {
                ci.f.size.width = ci.s.width
                if ci.v == weakSizeView {
                    ci.f.size.width = innerSize.width - widthExceptWeak()
                }
                ci.f.size.height = innerSize.height - e.height
                ci.f.origin = CGPoint(x: p.x + e.left, y: mInsets.top + e.top)
                p.x = ci.f.maxX + e.right + boxView.spacing
            }
            else {
                ci.f.size.width = innerSize.width - e.width
                ci.f.size.height = ci.s.height
                if ci.v == weakSizeView {
                    ci.f.size.height = innerSize.height - heightExceptWeak()
                }
                ci.f.origin = CGPoint(x: mInsets.left + e.left, y: p.y + e.top)
                p.y = ci.f.maxY + e.bottom + boxView.spacing
            }
            if !ci.v.checkFrame(ci.f) {
                return false
            }
        }
        return true
    }
}
