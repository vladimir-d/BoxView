//
//  BoxLayout+Pin.swift
//  BoxView
//
//  Created by Vlad on 5/11/20.
//  Copyright © 2020 Vladimir Dudkin. All rights reserved.
//

import UIKit

// MARK: - Public

public typealias BoxEdgePins = [BoxEdge: BoxLayout.Pin]

extension BoxLayout {
    
    public struct Pin {  //: ExpressibleByFloatLiteral
        
        public var value: CGFloat = 0.0
        
        public var relation: NSLayoutConstraint.Relation = .equal
        
        public init(value: CGFloat = 0.0, relation: NSLayoutConstraint.Relation = .equal) {
            self.value = value
            self.relation = relation
        }
        
        public init(_ value: Double) {
            self = Pin(value: CGFloat(value), relation: .equal)
        }
        
//        public init(floatLiteral value: FloatLiteralType) {
//            self = Pin(value: CGFloat(value), relation: .equal)
//        }
        
        public static let zero = Pin(value: 0.0, relation: .equal)
        
        public static func equal(_ value: CGFloat?) -> Pin? {
            if let value = value {
                return Pin(value: value, relation: .equal)
            }
            else{
                return nil
            }
        }
        
        public static func greaterThanOrEqual(_ value: CGFloat? = 0.0) -> Pin? {
            if let value = value {
                return Pin(value: value, relation: .greaterThanOrEqual)
            }
            else{
                return nil
            }
        }
        
        public static func lessThanOrEqual(_ value: CGFloat?) -> Pin? {
            if let value = value {
                return Pin(value: value, relation: .lessThanOrEqual)
            }
            else{
                return nil
            }
        }
        
        fileprivate static func joinRelations(_ rel1: NSLayoutConstraint.Relation, _ rel2: NSLayoutConstraint.Relation) -> NSLayoutConstraint.Relation? {
            if (rel1 == rel2) || (rel2 == .equal) {
                return rel1
            }
            else if rel1 == .equal {
                return rel2
            }
            else{
                return nil
            }
        }
    }
}

extension BoxLayout.Pin {
    public struct Pair {
        var begin: BoxLayout.Pin?
        var end: BoxLayout.Pin?
        
        public static let zero = Pair(begin: .zero, end: .zero)
        
        public static func pins(_ begin: BoxLayout.Pin?, _ end: BoxLayout.Pin?) -> Pair {
            return Pair(begin: begin, end: end)
        }
        
    }
}

func + (pin1: BoxLayout.Pin?, pin2: BoxLayout.Pin?) -> BoxLayout.Pin? {
    guard let pin1 = pin1, let pin2 = pin2 else { return nil }
    guard let rel = BoxLayout.Pin.joinRelations(pin1.relation, pin2.relation) else { return nil }
    return BoxLayout.Pin(value: pin1.value + pin2.value, relation: rel)
}

prefix operator >=

public prefix func >=(v: CGFloat) -> BoxLayout.Pin {
    return .greaterThanOrEqual(v)!
}

public prefix func >=(v: Double) -> BoxLayout.Pin {
    return .greaterThanOrEqual(CGFloat(v))!
}
public prefix func >=(v: CGFloat?) -> BoxLayout.Pin? {
    return .greaterThanOrEqual(v)
}

public prefix func >=(v: Double?) -> BoxLayout.Pin? {
    if let v = v {
        return .greaterThanOrEqual(CGFloat(v))
    }
    return nil
}

prefix operator <=

public prefix func <=(v: CGFloat) -> BoxLayout.Pin {
    return .lessThanOrEqual(v)!
}

public prefix func <=(v: Double) -> BoxLayout.Pin {
    return .lessThanOrEqual(CGFloat(v))!
}

public prefix func <=(v: CGFloat?) -> BoxLayout.Pin? {
    return .lessThanOrEqual(v)
}

public prefix func <=(v: Double?) -> BoxLayout.Pin? {
    if let v = v {
        return .lessThanOrEqual(CGFloat(v))
    }
    return nil
}

prefix operator ==

public prefix func ==(v: CGFloat) -> BoxLayout.Pin {
    return .equal(v)!
}

public prefix func ==(v: Double) -> BoxLayout.Pin {
    return .equal(CGFloat(v))!
}

public prefix func ==(v: CGFloat?) -> BoxLayout.Pin? {
    return .equal(v)
}

public prefix func ==(v: Double?) -> BoxLayout.Pin? {
    if let v = v {
        return .equal(CGFloat(v))
    }
    return nil
}

extension UIView {
    
    public func alPin(_ attribute: NSLayoutConstraint.Attribute, to toAttribute: NSLayoutConstraint.Attribute, of view: UIView, pin: BoxLayout.Pin) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(
            item: self,
            attribute: attribute,
            relatedBy: pin.relation,
            toItem: view,
            attribute: toAttribute,
            multiplier: 1.0,
            constant: pin.value)
        NSLayoutConstraint.activate([constraint])
        return constraint
    }
    
}
