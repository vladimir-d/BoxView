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
    
    @discardableResult
    public func alPin(_ attribute: NSLayoutConstraint.Attribute, to toAttribute: NSLayoutConstraint.Attribute, of view: UIView, constant: CGFloat = 0.0, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(
            item: self,
            attribute: attribute,
            relatedBy: relation,
            toItem: view,
            attribute: toAttribute,
            multiplier: 1.0,
            constant: constant)
        commonSuperviewWith(view)?.addConstraint(constraint)
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
    
    func commonSuperviewWith(_ view: UIView) -> UIView? {
        var tryView: UIView? = self
        repeat {
            if view.isDescendant(of: tryView!) {
                return tryView
            }
            tryView = tryView?.superview
        } while tryView != nil
        return nil
    }
    
    @discardableResult
    public func alToSuperviewWithEdgeValues(_ dict: LayoutAttributeValues) -> LayoutAttributeConstraints {
        var constraints = LayoutAttributeConstraints()
        if let sv = superview {
            for (attr, value) in dict {
                if (attr == .right) || (attr == .bottom) {
                    constraints[attr] = sv.alPin(attr, to: attr, of: self, constant: value, relation: .equal)
                }
                else {
                    constraints[attr] = alPin(attr, to: attr, of: sv, constant: value, relation: .equal)
                }
            }
        }
        return constraints
    }
    
    func removeSubviewsConstraints() {
        var svConstraints = [NSLayoutConstraint]()
        for cnstr in constraints {
            if cnstr.firstItem != nil && cnstr.secondItem != nil {
                svConstraints.append(cnstr)
            }
        }
        removeConstraints(svConstraints)
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




