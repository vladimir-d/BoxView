//
//  BoxItem.swift
//  BoxViewExample
//
//  Created by Vlad on 5/17/20.
//  Copyright © 2020 Vlad. All rights reserved.
//

import UIKit

// MARK: - Public

protocol BoxAnchorPinnable {
   func pin(_ pin: BoxLayout.Pin, to anchor: BoxAnchorPinnable) -> NSLayoutConstraint
}

extension NSLayoutXAxisAnchor: BoxAnchorPinnable {
    func pin(_ pin: BoxLayout.Pin, to anchor: BoxAnchorPinnable) -> NSLayoutConstraint {
        switch pin.relation {
            case .greaterThanOrEqual: return self.constraint(greaterThanOrEqualTo: anchor as! NSLayoutXAxisAnchor, constant: pin.constant)
            case .lessThanOrEqual: return self.constraint(lessThanOrEqualTo: anchor as! NSLayoutXAxisAnchor, constant: pin.constant)
            default: return self.constraint(equalTo: anchor as! NSLayoutXAxisAnchor, constant: pin.constant)
        }
    }
}

extension NSLayoutYAxisAnchor: BoxAnchorPinnable {
    func pin(_ pin: BoxLayout.Pin, to anchor: BoxAnchorPinnable) -> NSLayoutConstraint {
        switch pin.relation {
            case .greaterThanOrEqual: return self.constraint(greaterThanOrEqualTo: anchor as! NSLayoutYAxisAnchor, constant: pin.constant)
            case .lessThanOrEqual: return self.constraint(lessThanOrEqualTo: anchor as! NSLayoutYAxisAnchor, constant: pin.constant)
            default: return self.constraint(equalTo: anchor as! NSLayoutYAxisAnchor, constant: pin.constant)
        }
    }
}

protocol BoxAnchorable {

    var leftAnchor: NSLayoutXAxisAnchor { get }
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    var rightAnchor: NSLayoutXAxisAnchor { get }
    var topAnchor: NSLayoutYAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var centerXAnchor: NSLayoutXAxisAnchor { get }
    var centerYAnchor: NSLayoutYAxisAnchor { get }
    var widthAnchor: NSLayoutDimension { get }
    var heightAnchor: NSLayoutDimension { get }
}

extension UIView: BoxAnchorable {
    
}

extension UILayoutGuide: BoxAnchorable {
    
}

public struct BoxItem {
    internal var alObj: BoxAnchorable
    public var layout: BoxLayout
    
    public var view: UIView? {
        get {
            return alObj as? UIView
        }
        set(aView) {
            if let aView = aView {
                alObj = aView
            }
        }
    }
    
    public var guide: UILayoutGuide? {
        get {
            return alObj as? UILayoutGuide
        }
        set(aGuide) {
            if let aGuide = aGuide {
                alObj = aGuide
            }
        }
    }
    
    public init(view: UIView, layout: BoxLayout = .zero) {
        self.alObj = view
        self.layout = layout
    }
    
    init(alObj: BoxAnchorable, layout: BoxLayout = .zero) {
        self.alObj = alObj
        self.layout = layout
    }
    var leftAnchor: NSLayoutXAxisAnchor? {
        return (layout.left != nil) ? alObj.leftAnchor : nil
    }
    var leadingAnchor: NSLayoutXAxisAnchor? {
        return (layout.left != nil) ? alObj.leadingAnchor : nil
    }
    var rightAnchor: NSLayoutXAxisAnchor? {
        return (layout.right != nil) ? alObj.rightAnchor : nil
    }
    var trailingAnchor: NSLayoutXAxisAnchor? {
        return (layout.left != nil) ? alObj.trailingAnchor : nil
    }
    var centerXAnchor: NSLayoutXAxisAnchor? {
        return (layout.centerX != nil) ? alObj.centerXAnchor : nil
    }
    var topAnchor: NSLayoutYAxisAnchor? {
        return (layout.top != nil) ? alObj.topAnchor : nil
    }
    var bottomAnchor: NSLayoutYAxisAnchor? {
        return (layout.bottom != nil) ? alObj.bottomAnchor : nil
    }
    var centerYAnchor: NSLayoutYAxisAnchor? {
        return (layout.centerY != nil) ? alObj.centerYAnchor : nil
    }

    func beginAnchor(axis: BoxLayout.Axis, isRTLDependent: Bool) -> BoxAnchorPinnable? {
        return (axis == .y) ? topAnchor : ((isRTLDependent) ? leadingAnchor : leftAnchor)
    }
    
    func endAnchor(axis: BoxLayout.Axis, isRTLDependent: Bool) -> BoxAnchorPinnable? {
        return (axis == .y) ? bottomAnchor : ((isRTLDependent) ? trailingAnchor : rightAnchor)
    }
    
    func centerAnchor(axis: BoxLayout.Axis) -> BoxAnchorPinnable? {
        return (axis == .y) ? centerYAnchor : centerXAnchor
    }
 
}



