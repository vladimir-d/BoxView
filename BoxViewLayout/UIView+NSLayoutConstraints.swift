//
//  UIViw+NSLayoutConstraints.swift
//  BoxView
//
//  Created by Vlad on 5/10/20.
//  Copyright © 2020 Vladimir Dudkin. All rights reserved.
//

import UIKit

extension BoxAnchorable {
    
    @discardableResult
    public func pin(_ edge : BoxEdge, to toEdge: BoxEdge? = nil, of anchorable: BoxAnchorable, pin: BoxLayout.Pin = .zero, sca: UISemanticContentAttribute = .unspecified, activate: Bool = true) -> NSLayoutConstraint {
        let toEdge = toEdge ?? edge
        let anchor = anchorForEdge(edge, sca: sca)
        let toAnchor = anchorable.anchorForEdge(toEdge, sca: sca)
        let constraint = anchor.pin(pin, to: toAnchor)
        if activate {
            NSLayoutConstraint.activate([constraint])
        }
        return constraint
    }
    
    @discardableResult
    public func pin(_ edge : BoxEdge, to toEdge: BoxEdge, of anchorable: BoxAnchorable, offset: CGFloat, sca: UISemanticContentAttribute = .unspecified, activate: Bool = true) -> NSLayoutConstraint {
        return pin(edge, to: toEdge, of: anchorable, pin: ==offset, sca: sca, activate: activate)
    }
    
    @discardableResult
    public func pinHeight(to anchorable: BoxAnchorable, multiPin: BoxLayout.MultiPin) -> NSLayoutConstraint {
        let constr: NSLayoutConstraint
        switch multiPin.relation {
            case .greaterThanOrEqual: constr = self.heightAnchor.constraint(greaterThanOrEqualTo: anchorable.heightAnchor, multiplier: multiPin.multiplier, constant: multiPin.constant)
            case .lessThanOrEqual: constr = self.heightAnchor.constraint(lessThanOrEqualTo: anchorable.heightAnchor, multiplier: multiPin.multiplier, constant: multiPin.constant)
            default: constr = self.heightAnchor.constraint(equalTo: anchorable.heightAnchor, multiplier: multiPin.multiplier, constant: multiPin.constant)
        }
        constr.isActive = true
        return constr
    }
    
    @discardableResult
    public func pinHeight(to anchorable: BoxAnchorable, pin: BoxLayout.Pin) -> NSLayoutConstraint {
        return pinHeight(to: anchorable, multiPin: BoxLayout.MultiPin(pin))
    }
    
    @discardableResult
    public func pinHeight(to anchorable: BoxAnchorable, offset: CGFloat = 0.0) -> NSLayoutConstraint {
        return pinHeight(to: anchorable, pin: ==offset)
    }
    
    @discardableResult
    public func pinWidth(to anchorable: BoxAnchorable, multiPin: BoxLayout.MultiPin) -> NSLayoutConstraint {
        let constr: NSLayoutConstraint
        switch multiPin.relation {
            case .greaterThanOrEqual: constr = self.widthAnchor.constraint(greaterThanOrEqualTo: anchorable.widthAnchor, multiplier: multiPin.multiplier, constant: multiPin.constant)
            case .lessThanOrEqual: constr = self.widthAnchor.constraint(lessThanOrEqualTo: anchorable.widthAnchor, multiplier: multiPin.multiplier, constant: multiPin.constant)
            default: constr = self.widthAnchor.constraint(equalTo: anchorable.widthAnchor, multiplier: multiPin.multiplier, constant: multiPin.constant)
        }
        constr.isActive = true
        return constr
    }
    
    @discardableResult
    public func pinWidth(to anchorable: BoxAnchorable, pin: BoxLayout.Pin) -> NSLayoutConstraint {
        return pinWidth(to: anchorable, multiPin: BoxLayout.MultiPin(pin))
    }
    
    @discardableResult
    public func pinWidth(to anchorable: BoxAnchorable, offset: CGFloat = 0.0) -> NSLayoutConstraint {
        return pinWidth(to: anchorable, pin: ==offset)
    }
    
    @discardableResult
    public func pinHeight(_ pin: BoxLayout.Pin) -> NSLayoutConstraint {
        let constr: NSLayoutConstraint
        switch pin.relation {
            case .greaterThanOrEqual: constr = self.heightAnchor.constraint(greaterThanOrEqualToConstant: pin.constant)
            case .lessThanOrEqual: constr = self.heightAnchor.constraint(lessThanOrEqualToConstant: pin.constant)
            default: constr = self.heightAnchor.constraint(equalToConstant: pin.constant)
        }
        constr.isActive = true
        return constr
    }
    
    @discardableResult
    public func pinHeight(_ height: CGFloat) -> NSLayoutConstraint {
        return pinHeight(==height)
    }
    
    @discardableResult
    public func pinWidth(_ pin: BoxLayout.Pin) -> NSLayoutConstraint {
        let constr: NSLayoutConstraint
        switch pin.relation {
            case .greaterThanOrEqual: constr = self.widthAnchor.constraint(greaterThanOrEqualToConstant: pin.constant)
            case .lessThanOrEqual: constr = self.widthAnchor.constraint(lessThanOrEqualToConstant: pin.constant)
            default: constr = self.widthAnchor.constraint(equalToConstant: pin.constant)
        }
        constr.isActive = true
        return constr
    }
    
    @discardableResult
    public func pinWidth(_ width: CGFloat) -> NSLayoutConstraint {
        return pinWidth(==width)
    }
    
    @discardableResult
    public func pinSize(_ size: CGSize) -> [NSLayoutConstraint] {
        return [pinWidth(size.width), pinHeight(size.height)]
    }

    @discardableResult
    public func pinAspect(_ aspect: CGFloat = 1.0) -> NSLayoutConstraint? {
        var aspectConstraint: NSLayoutConstraint?
        aspectConstraint = self.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: aspect)
        aspectConstraint?.isActive = true
        return aspectConstraint
    }
    
    @discardableResult
    public func pinAspectFromSize(_ size: CGSize) -> NSLayoutConstraint? {
        if size.width != 0.0 {
            let aspect = size.height / size.width
            return pinAspect(aspect)
        }
        return nil
    }
}

extension Array where Element: BoxAnchorable & Equatable {
    
    @discardableResult
    public func pinSameWidth() -> [NSLayoutConstraint] {
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
    public func pinSameHeight() -> [NSLayoutConstraint] {
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

extension UIView {
    
    public var al: Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
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


// MARK: - Deprecated -
// Deprecated UIView methods - more general BoxAnchorable methods should be used instead.

extension UIView {
    
    // Deprecated, use BoxAnchorable pin(...) instead
    @discardableResult
    @available(*, deprecated, renamed: "pin")
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
        
    // Deprecated, use BoxAnchorable pinHeight(...) instead
    @discardableResult
    @available(*, deprecated, renamed: "pinHeight")
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
    
    // Deprecated, use BoxAnchorable pinWidth(...) instead
    @discardableResult
    @available(*, deprecated, renamed: "pinWidth")
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
    
    // Deprecated, use BoxAnchorable pinHeight(...) instead
    @discardableResult
    @available(*, deprecated, renamed: "pinHeight")
    public func bxPinHeight(_ pin: BoxLayout.Pin , to view: UIView? = nil) -> NSLayoutConstraint {
        return bxPinHeight(BoxLayout.MultiPin(pin) , to: view)
    }
    
    // Deprecated, use BoxAnchorable pinHeight(...) instead
    @discardableResult
    @available(*, deprecated, renamed: "pinHeight")
    public func bxPinHeight(_ height: CGFloat = 0.0, to view: UIView? = nil) -> NSLayoutConstraint {
        return bxPinHeight(==height, to: view)
    }

    // Deprecated, use BoxAnchorable pinWidth(...) instead
    @discardableResult
    @available(*, deprecated, renamed: "pinWidth")
    public func bxPinWidth(_ pin: BoxLayout.Pin , to view: UIView? = nil) -> NSLayoutConstraint {
        return bxPinWidth(BoxLayout.MultiPin(pin) , to: view)
    }
    
    // Deprecated, use BoxAnchorable pinWidth(...) instead
    @discardableResult
    @available(*, deprecated, renamed: "pinWidth")
    public func bxPinWidth(_ width: CGFloat = 0.0, to view: UIView? = nil) -> NSLayoutConstraint {
        return bxPinWidth(==width, to: view)
    }
    
    // Deprecated, use BoxAnchorable pinHeight(...) instead
    @discardableResult
    @available(*, deprecated, renamed: "pinHeight")
    private func bxSetHeight(_ height: CGFloat, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        let constr: NSLayoutConstraint
        switch relation {
            case .greaterThanOrEqual: constr = self.heightAnchor.constraint(greaterThanOrEqualToConstant: height)
            case .lessThanOrEqual: constr = self.heightAnchor.constraint(lessThanOrEqualToConstant: height)
            default: constr = self.heightAnchor.constraint(equalToConstant: height)
        }
        constr.isActive = true
        return constr
    }

    // Deprecated, use BoxAnchorable pinWidth(...) instead
    @discardableResult
    @available(*, deprecated, renamed: "pinWidth")
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
    
    
    // Deprecated, use BoxAnchorable pinSize(...) instead
    @discardableResult
    @available(*, deprecated, renamed: "pinSize")
    public func bxSetSize(_ size: CGSize) -> [NSLayoutConstraint] {
        return [bxSetWidth(size.width), bxSetHeight(size.height)]
    }
    
    // Deprecated, use BoxAnchorable pinAspect(...) instead
    @discardableResult
    @available(*, deprecated, renamed: "pinAspect")
    public func bxSetAspect(_ aspect: CGFloat = 1.0) -> NSLayoutConstraint? {
        var aspectConstraint: NSLayoutConstraint?
        aspectConstraint = self.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: aspect)
        aspectConstraint?.isActive = true
        return aspectConstraint
    }
    
    // Deprecated, use BoxAnchorable pinAspectFromSize(...) instead
    @discardableResult
    @available(*, deprecated, renamed: "pinAspectFromSize")
    public func bxSetAspectFromSize(_ size: CGSize) -> NSLayoutConstraint? {
        if size.width != 0.0 {
            let aspect = size.height / size.width
            return bxSetAspect(aspect)
        }
        return nil
    }

}

extension Array where Element: UIView {
    
    // Deprecated, use [BoxAnchorable] pinSameWidth(...) instead
    @discardableResult
    @available(*, deprecated, renamed: "pinSameWidth")
    public func bxSameWidth() -> [NSLayoutConstraint] {
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
    
    // Deprecated, use [BoxAnchorable] pinSameHeight(...) instead
    @discardableResult
    @available(*, deprecated, renamed: "pinSameHeight")
    public func bxSameHeight() -> [NSLayoutConstraint] {
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











