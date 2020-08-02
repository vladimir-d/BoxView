//
//  BoxItem.swift
//  BoxViewExample
//
//  Created by Vlad on 5/17/20.
//  Copyright © 2020 Vlad. All rights reserved.
//

import UIKit

// MARK: - Public

public protocol BoxAnchorable: class {

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
    
    var semanticContentAttribute: UISemanticContentAttribute { get }
}

extension UIView: BoxAnchorable {
}

extension UILayoutGuide: BoxAnchorable {
}

public struct BoxItem: CustomStringConvertible {
    
    // MARK: - Public
    
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
    
    public var description: String {
        var str = ""
        if let view = view {
            str = "view: \(view)"
        }
        else if let guide = guide {
            str = "guide: \(guide)"
        }
        str += "\nlayout: \(layout)"
        return str
    }
    
    // MARK: - Internal
    
    init(alObj: BoxAnchorable, layout: BoxLayout = .zero) {
        self.alObj = alObj
        self.layout = layout
    }
    
    internal var alObj: BoxAnchorable
    
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

protocol BoxAnchorPinnable {
   func pin(_ pin: BoxLayout.Pin, to anchor: BoxAnchorPinnable) -> NSLayoutConstraint
}

extension NSLayoutXAxisAnchor: BoxAnchorPinnable {
    func pin(_ pin: BoxLayout.Pin, to anchor: BoxAnchorPinnable) -> NSLayoutConstraint {
        let cnstr: NSLayoutConstraint
        switch pin.relation {
            case .greaterThanOrEqual: cnstr = self.constraint(greaterThanOrEqualTo: anchor as! NSLayoutXAxisAnchor, constant: pin.constant)
            case .lessThanOrEqual: cnstr = self.constraint(lessThanOrEqualTo: anchor as! NSLayoutXAxisAnchor, constant: pin.constant)
            default: cnstr = self.constraint(equalTo: anchor as! NSLayoutXAxisAnchor, constant: pin.constant)
        }
        if pin.priority != .required {
            cnstr.priority = pin.priority
        }
        return cnstr
    }
}

extension NSLayoutYAxisAnchor: BoxAnchorPinnable {
    func pin(_ pin: BoxLayout.Pin, to anchor: BoxAnchorPinnable) -> NSLayoutConstraint {
        let cnstr: NSLayoutConstraint
        switch pin.relation {
            case .greaterThanOrEqual: cnstr = self.constraint(greaterThanOrEqualTo: anchor as! NSLayoutYAxisAnchor, constant: pin.constant)
            case .lessThanOrEqual: cnstr = self.constraint(lessThanOrEqualTo: anchor as! NSLayoutYAxisAnchor, constant: pin.constant)
            default: cnstr = self.constraint(equalTo: anchor as! NSLayoutYAxisAnchor, constant: pin.constant)
        }
        if pin.priority != .required {
            cnstr.priority = pin.priority
        }
        return cnstr
    }
}

extension NSLayoutDimension {
    
    func pin(_ pin: BoxLayout.MultiPin, to anchor: NSLayoutDimension) -> NSLayoutConstraint {
        let cnstr: NSLayoutConstraint
        switch pin.relation {
            case .greaterThanOrEqual: cnstr = self.constraint(greaterThanOrEqualTo: anchor, multiplier: pin.multiplier, constant: pin.constant)
            case .lessThanOrEqual: cnstr = self.constraint(lessThanOrEqualTo: anchor, multiplier: pin.multiplier, constant: pin.constant)
            default: cnstr = self.constraint(equalTo: anchor, multiplier: pin.multiplier, constant: pin.constant)
        }
        if pin.priority != .required {
            cnstr.priority = pin.priority
        }
        return cnstr
    }
    
    func pin(_ pin: BoxLayout.Pin) -> NSLayoutConstraint {
        let cnstr: NSLayoutConstraint
        switch pin.relation {
            case .greaterThanOrEqual: cnstr = self.constraint(greaterThanOrEqualToConstant: pin.constant)
            case .lessThanOrEqual: cnstr = self.constraint(lessThanOrEqualToConstant: pin.constant)
            default: cnstr = self.constraint(equalToConstant: pin.constant)
        }
        if pin.priority != .required {
            cnstr.priority = pin.priority
        }
        return cnstr
    }
    
}



