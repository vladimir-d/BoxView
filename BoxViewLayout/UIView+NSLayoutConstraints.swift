//
//  UIViw+NSLayoutConstraints.swift
//  BoxView
//
//  Created by Vlad on 5/10/20.
//  Copyright © 2020 Vladimir Dudkin. All rights reserved.
//

import UIKit

extension UIView {

    @discardableResult
    public func bxPin(_ attribute: NSLayoutConstraint.Attribute, to toAttribute: NSLayoutConstraint.Attribute, of view: UIView, pin: BoxLayout.Pin = .zero, activate: Bool = true) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(
            item: self,
            attribute: attribute,
            relatedBy: pin.relation,
            toItem: view,
            attribute: toAttribute,
            multiplier: 1.0,
            constant: pin.constant)
        if pin.priority != .required {
            constraint.priority = pin.priority
        }
        if activate {
            NSLayoutConstraint.activate([constraint])
        }
        return constraint
    }
    
    @discardableResult
    func bxSetHeight(_ height: CGFloat, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        let constr: NSLayoutConstraint
        switch relation {
            case .greaterThanOrEqual: constr = self.heightAnchor.constraint(greaterThanOrEqualToConstant: height)
            case .lessThanOrEqual: constr = self.heightAnchor.constraint(lessThanOrEqualToConstant: height)
            default: constr = self.heightAnchor.constraint(equalToConstant: height)
        }
        constr.isActive = true
        return constr
    }
    
    @discardableResult
    public func bxPinHeight(_ multiPin: BoxLayout.MultiPin, to view: UIView? = nil) -> NSLayoutConstraint {
        let constr: NSLayoutConstraint
        if let view = view {
            switch multiPin.relation {
                case .greaterThanOrEqual: constr = self.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor, multiplier: multiPin.multiplier, constant: multiPin.constant)
                case .lessThanOrEqual: constr = self.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: multiPin.multiplier, constant: multiPin.constant)
                default: constr = self.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: multiPin.multiplier, constant: multiPin.constant)
            }
            constr.isActive = true
            return constr
        }
        else {
            return bxSetHeight(multiPin.constant, relation: multiPin.relation)
        }
    }

    @discardableResult
    public func bxPinHeight(_ pin: BoxLayout.Pin, to view: UIView? = nil) -> NSLayoutConstraint {
        return bxPinHeight(BoxLayout.MultiPin(pin) , to: view)
    }
    
    @discardableResult
    public func bxPinHeight(_ height: CGFloat = 0.0, to view: UIView? = nil) -> NSLayoutConstraint {
        return bxPinHeight(==height, to: view)
    }
    
    @discardableResult
    private func bxSetWidth(_ width: CGFloat, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        let constr: NSLayoutConstraint
        switch relation {
            case .greaterThanOrEqual: constr = self.widthAnchor.constraint(greaterThanOrEqualToConstant: width)
            case .lessThanOrEqual: constr = self.widthAnchor.constraint(lessThanOrEqualToConstant: width)
            default: constr = self.widthAnchor.constraint(equalToConstant: width)
        }
        constr.isActive = true
        return constr
    }
    
    @discardableResult
    public func bxPinWidth(_ multiPin: BoxLayout.MultiPin, to view: UIView? = nil) -> NSLayoutConstraint {
        let constr: NSLayoutConstraint
        if let view = view {
            switch multiPin.relation {
                case .greaterThanOrEqual: constr = self.widthAnchor.constraint(greaterThanOrEqualTo: view.widthAnchor, multiplier: multiPin.multiplier, constant: multiPin.constant)
                case .lessThanOrEqual: constr = self.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: multiPin.multiplier, constant: multiPin.constant)
                default: constr = self.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: multiPin.multiplier, constant: multiPin.constant)
            }
            constr.isActive = true
            return constr
        }
        else {
            return bxSetWidth(multiPin.constant, relation: multiPin.relation)
        }
    }
    
    @discardableResult
    public func bxPinWidth(_ pin: BoxLayout.Pin , to view: UIView? = nil) -> NSLayoutConstraint {
        return bxPinWidth(BoxLayout.MultiPin(pin) , to: view)
    }
    
    @discardableResult
    public func bxPinWidth(_ width: CGFloat = 0.0, to view: UIView? = nil) -> NSLayoutConstraint {
        return bxPinWidth(==width, to: view)
    }
    
    @discardableResult
    public func bxSetSize(_ size: CGSize) -> [NSLayoutConstraint] {
        return [bxSetWidth(size.width), bxSetHeight(size.height)]
    }
    
    @discardableResult
    public func bxSetAspect(_ aspect: CGFloat = 1.0) -> NSLayoutConstraint? {
        var aspectConstraint: NSLayoutConstraint?
        aspectConstraint = self.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: aspect)
        aspectConstraint?.isActive = true
        return aspectConstraint
    }
    
    @discardableResult
    public func bxSetAspectFromSize(_ size: CGSize) -> NSLayoutConstraint? {
        if size.width != 0.0 {
            let aspect = size.height / size.width
            return bxSetAspect(aspect)
        }
        return nil
    }

    public func bxRemoveConstraintsForAttribute(_ attr: NSLayoutConstraint.Attribute) {
        let existing = constraints.filter { constraint in
            return constraint.firstAttribute == attr
        }
        existing.forEach{ self.removeConstraint($0)}
    }
    
    public func bxRemoveConstraintsToView(_ view: UIView) {
        let existing = constraints.filter { constraint in
            return constraint.firstItem === view || constraint.secondItem === view
        }
        existing.forEach{ self.removeConstraint($0)}
    }
}

extension Array where Element: UIView {
    
    @discardableResult
    func bxSameWidth() -> [NSLayoutConstraint] {
        let firstEl = first
        let firstAnchor = firstEl?.widthAnchor
        let constraints: [NSLayoutConstraint] = self.compactMap{
            var constr: NSLayoutConstraint?
            if $0 != firstEl {
                constr = firstAnchor?.constraint(equalTo: $0.widthAnchor)
            }
            return constr
        }
        NSLayoutConstraint.activate(constraints)
        return constraints
    }
    
    @discardableResult
    func bxSameHeight()  -> [NSLayoutConstraint] {
        let firstEl = first
        let firstAnchor = firstEl?.heightAnchor
        let constraints: [NSLayoutConstraint] = self.compactMap{
            var constr: NSLayoutConstraint?
            if $0 != firstEl {
                constr = firstAnchor?.constraint(equalTo: $0.heightAnchor)
            }
            return constr
        }
        NSLayoutConstraint.activate(constraints)
        return constraints
    }
}









