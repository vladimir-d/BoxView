//
//  Extension.swift
//  BoxViewTesting
//
//  Created by Vlad on 05.12.2020.
//

import Foundation
import UIKit

extension CGSize {
    static func wh(_ w: CGFloat, _ h: CGFloat) -> CGSize {
         return CGSize(width: w, height: h)
    }
}

extension CGRect {
    init(point: CGPoint, size: CGSize) {
        self.init(x: point.x, y: point.y, width: size.width, height: size.height)
    }
    
    static func xywh(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat) -> CGRect {
         return CGRect(x: x, y: y, width: w, height: h)
    }
}

extension UIEdgeInsets {
    static func tlbr(_ t: CGFloat, _ l: CGFloat, _ b: CGFloat, _ r: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: t, left: l, bottom: b, right: r)
    }
    
    var xInverted: UIEdgeInsets {
        var insets = self
        swap(&insets.left, &insets.right)
        return insets
    }
    
    func modified(sca: UISemanticContentAttribute) -> UIEdgeInsets {
        let langDir = UIView.userInterfaceLayoutDirection(for: sca)
        return (langDir == .leftToRight) ? self : self.xInverted
    }
    
    var width: CGFloat {
        return left + right
    }
    
    var height: CGFloat {
        return top + bottom
    }

}

extension Array {
    func modified(axis: BoxLayout.Axis, sca: UISemanticContentAttribute) -> Self {
        let langDir = UIView.userInterfaceLayoutDirection(for: sca)
        return (axis == .y || langDir == .leftToRight) ? self : self.reversed()
    }
}


func + (v1: UIEdgeInsets, v2: UIEdgeInsets) -> UIEdgeInsets {
    return UIEdgeInsets(top: v1.top + v2.top,
                        left: v1.left + v2.left,
                        bottom: v1.bottom + v2.bottom,
                        right: v1.right + v2.right)
    
}

extension UIView {
    
    convenience init(color: UIColor) {
        self.init()
        self.backgroundColor = color
    }
    
    func checkFrame(_ rect: CGRect) -> Bool {
        print("expected frame: \(rect)")
        print("view     frame: \(frame)")
        if frame == rect {
            return true
        }
        return false
    }
    
    func addFillingSubview(_ subview: UIView) {
        subview.frame = frame
        subview.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(subview)
    }
    
    @discardableResult
    func setWeekWidth(_ w: CGFloat) -> NSLayoutConstraint {
        let cnstr = self.widthAnchor.constraint(equalToConstant: w)
        cnstr.priority = .fittingSizeLevel
        cnstr.isActive = true
        return cnstr
    }
    
    @discardableResult
    func setWeekHeight(_ h: CGFloat) -> NSLayoutConstraint {
        let cnstr = self.heightAnchor.constraint(equalToConstant: h)
        cnstr.priority = .fittingSizeLevel
        cnstr.isActive = true
        return cnstr
    }
    
    @discardableResult
    func setWidth(_ w: CGFloat, priority: UILayoutPriority) -> NSLayoutConstraint {
        let cnstr = self.widthAnchor.constraint(equalToConstant: w)
        cnstr.priority = priority
        cnstr.isActive = true
        return cnstr
    }
    
    @discardableResult
    func setHeight(_ h: CGFloat, priority: UILayoutPriority) -> NSLayoutConstraint {
        let cnstr = self.heightAnchor.constraint(equalToConstant: h)
        cnstr.priority = priority
        cnstr.isActive = true
        return cnstr
    }
    
    @discardableResult
    func setWeekSize(_ size: CGSize) -> [NSLayoutConstraint] {
        return [setWeekWidth(size.width), setWeekHeight(size.height)]
    }
}
