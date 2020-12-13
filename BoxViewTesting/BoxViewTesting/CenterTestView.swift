//
//  CenterTestView.swift
//  BoxViewTesting
//
//  Created by Vlad on 06.12.2020.
//

import UIKit

class CenterTestView: TestView {
    var innerRectSize = CGSize.wh(105.0, 200.0)
    let v = UIView()
    let insets = UIEdgeInsets.tlbr(30.0, 20.0, 10.0, 70.0)
    var offset = CGPoint(x: 7.0, y: 173.0)
    var xPadding: CGFloat? = nil
    var yPadding: CGFloat? = nil
    
    override func setup() {
        super.setup()
        v.backgroundColor = .red
        v.setWeekSize(innerRectSize)
        boxView.insets = insets
        boxView.items = [v.boxed.centerX(offset: offset.x, padding: xPadding).centerY(offset: offset.y, padding: yPadding)]
    }
    
//    override func scaToTest() -> [UISemanticContentAttribute] {
//        return [.unspecified, .forceLeftToRight]
//    }

    override func checkFrames() -> Bool {
        let mInsets = insets.modified(sca: boxView.semanticContentAttribute)
        let innerSize = frame.inset(by: mInsets).size
        var p: CGPoint = .zero
        let xDirFactor = boxView.languageDirectionFactorForAxis(.x)
        var actualRectSize = innerRectSize
        if let xPadding = xPadding {
            let widthInset = 2.0 * (xPadding + abs(offset.x))
            let w = min(innerRectSize.width, innerSize.width - widthInset)
            actualRectSize.width = max(0.0, w)
        }
        if let yPadding = yPadding {
            let heightInset = 2.0 * (yPadding + abs(offset.y))
            let h = min(innerRectSize.height, innerSize.height - heightInset)
            actualRectSize.height = max(0.0, h)
        }
        p.x = mInsets.left + (innerSize.width - actualRectSize.width) / 2.0 + offset.x * xDirFactor
        p.y = mInsets.top + (innerSize.height - actualRectSize.height) / 2.0 + offset.y

  
        let expFrame = CGRect(point: p, size: actualRectSize)
        print("------------")
        print("owner frame: \(frame)")
        print("owner frame inseted: \(frame.inset(by: mInsets))")
        return v.checkFrame(expFrame)
    }
}

class CenterTestViewB: CenterTestView {
    override func setup() {
        xPadding = 40.0
        yPadding = 80.0
        innerRectSize = CGSize.wh(200.0, 400.0)
        super.setup()
    }
    
}
