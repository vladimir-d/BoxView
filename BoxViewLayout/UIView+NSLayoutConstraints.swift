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
    public func alPin(_ attribute: NSLayoutConstraint.Attribute, to toAttribute: NSLayoutConstraint.Attribute, of view: UIView, constant: CGFloat = 0.0, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(
            item: self,
            attribute: attribute,
            relatedBy: relation,
            toItem: view,
            attribute: toAttribute,
            multiplier: 1.0,
            constant: constant)
        NSLayoutConstraint.activate([constraint])
        return constraint
    }
    
    @discardableResult
    public func alPinToSuperview(_ attribute: NSLayoutConstraint.Attribute, constant: CGFloat = 0.0, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint? {
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
        if let sv = superview {
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
        }
        NSLayoutConstraint.activate(Array(constraints.values))
        return constraints
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




