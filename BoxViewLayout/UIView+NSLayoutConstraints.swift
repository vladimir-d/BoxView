//
//  UIViw+NSLayoutConstraints.swift
//  BoxView
//
//  Created by Vlad on 5/10/20.
//  Copyright © 2020 Vladimir Dudkin. All rights reserved.
//

import UIKit

public typealias  LayoutAttributeValues = [NSLayoutConstraint.Attribute: CGFloat]
public typealias  LayoutAttributeConstraints = [NSLayoutConstraint.Attribute: NSLayoutConstraint]

extension UIView {
    
    public class func newAL() -> Self {
        let v = Self.init()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }
    
    @discardableResult
    public func alPin(_ attribute: NSLayoutConstraint.Attribute, to toAttribute: NSLayoutConstraint.Attribute, of view: UIView, constant: CGFloat = 0.0, relation: NSLayoutConstraint.Relation = .equal, activate: Bool = true) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(
            item: self,
            attribute: attribute,
            relatedBy: relation,
            toItem: view,
            attribute: toAttribute,
            multiplier: 1.0,
            constant: constant)
        if activate {
            NSLayoutConstraint.activate([constraint])
        }
        return constraint
    }
    
    @discardableResult
    public func alPinToSuperview(_ attribute: NSLayoutConstraint.Attribute, _ constant: CGFloat = 0.0, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint? {
        self.translatesAutoresizingMaskIntoConstraints = false
        guard let sv = superview else {
            return nil
        }
        let constraint = NSLayoutConstraint(
            item: self,
            attribute: attribute,
            relatedBy: relation,
            toItem: sv,
            attribute: attribute,
            multiplier: 1.0,
            constant: constant)
        sv.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult
    public func alToSuperviewWithEdgeValues(_ dict: LayoutAttributeValues) -> LayoutAttributeConstraints {
        var constraints = LayoutAttributeConstraints()
        guard let sv = superview else {
            assertionFailure("Can't add constraints as superview is nil for \(self)")
            return constraints
        }
        for (attr, value) in dict {
            var const = value
            if (attr == .right) || (attr == .bottom) || (attr == .trailing) {
                const = -value
            }
            let constraint = NSLayoutConstraint(
                item: self,
                attribute: attr,
                relatedBy: .equal,
                toItem: sv,
                attribute: attr,
                multiplier: 1.0,
                constant: const)
            constraints[attr] = constraint
        }
        
        NSLayoutConstraint.activate(Array(constraints.values))
        return constraints
    }
    
    @discardableResult
    public func alSetHeight(_ height: CGFloat, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
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
    public func alHeightPin(_ pin: BoxLayout.Pin, to view: UIView? = nil) -> NSLayoutConstraint {
        let constr: NSLayoutConstraint
        if let view = view {
            switch pin.relation {
                case .greaterThanOrEqual: constr = self.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor, constant: pin.value)
                case .lessThanOrEqual: constr = self.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, constant: pin.value)
                default: constr = self.heightAnchor.constraint(equalTo: view.heightAnchor, constant: pin.value)
            }
            constr.isActive = true
            return constr
        }
        else {
            return alSetHeight(pin.value, relation: pin.relation)
        }
    }
    
    @discardableResult
    public func alSetWidth(_ width: CGFloat, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
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
    public func alWidthPin(_ pin: BoxLayout.Pin, to view: UIView? = nil) -> NSLayoutConstraint {
        let constr: NSLayoutConstraint
        if let view = view {
            switch pin.relation {
                case .greaterThanOrEqual: constr = self.widthAnchor.constraint(greaterThanOrEqualTo: view.widthAnchor, constant: pin.value)
                case .lessThanOrEqual: constr = self.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, constant: pin.value)
                default: constr = self.widthAnchor.constraint(equalTo: view.widthAnchor, constant: pin.value)
            }
            constr.isActive = true
            return constr
        }
        else {
            return alSetWidth(pin.value, relation: pin.relation)
        }
    }
    
    @discardableResult
    public func alSetSize(_ size: CGSize) -> [NSLayoutConstraint] {
        return [alSetWidth(size.width), alSetHeight(size.height)]
    }
    
    @discardableResult
    public func alSetSetAspectFromSize(_ size: CGSize) -> NSLayoutConstraint? {
        var aspectConstraint: NSLayoutConstraint?
        if size.width != 0.0 {
            let aspect = size.height / size.width
            aspectConstraint = self.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: aspect)
            aspectConstraint?.isActive = true
        }
        return aspectConstraint
    }
    

    
    public func alRemoveConstraintsForAttribute(_ attr: NSLayoutConstraint.Attribute) {
        let existing = constraints.filter { constraint in
            return constraint.firstAttribute == attr
        }
        existing.forEach{ self.removeConstraint($0)}
    }

}


extension LayoutAttributeValues {

    public static let zero = all(0.0)

    public static func all(_ value: CGFloat = 0.0, excluding edge: NSLayoutConstraint.Attribute? = nil) -> LayoutAttributeValues {
        var dict: LayoutAttributeValues = [.top: value, .bottom: value, .left: value, .right: value]
        if let edge = edge {
            dict[edge] = nil
        }
        return dict
    }
}




