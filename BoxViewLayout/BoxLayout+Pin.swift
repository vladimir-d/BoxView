//
//  BoxLayout+Pin.swift
//  BoxView
//
//  Created by Vlad on 5/11/20.
//  Copyright © 2020 Vladimir Dudkin. All rights reserved.
//

import UIKit

extension BoxLayout {
    struct Pin: ExpressibleByFloatLiteral {
        
        var value: CGFloat = 0.0
        
        var relation: NSLayoutConstraint.Relation = .equal
        
        public init(value: CGFloat = 0.0, relation: NSLayoutConstraint.Relation = .equal) {
            self.value = value
            self.relation = relation
        }
        
        public init(_ value: Double) {
            self = Pin(value: CGFloat(value), relation: .equal)
        }
        
        public init(floatLiteral value: FloatLiteralType) {
            self = Pin(value: CGFloat(value), relation: .equal)
        }
        
        static let zero = Pin(value: 0.0, relation: .equal)
        
        static func eq(_ value: CGFloat?) -> Pin? {
            if let value = value {
                return Pin(value: value, relation: .equal)
            }
            else{
                return nil
            }
        }
        
        static func gteq(_ value: CGFloat? = 0.0) -> Pin? {
            if let value = value {
                return Pin(value: value, relation: .greaterThanOrEqual)
            }
            else{
                return nil
            }
        }
        
        static func lteq(_ value: CGFloat?) -> Pin? {
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

func + (pin1: BoxLayout.Pin?, pin2: BoxLayout.Pin?) -> BoxLayout.Pin? {
    guard let pin1 = pin1, let pin2 = pin2 else { return nil }
    guard let rel = BoxLayout.Pin.joinRelations(pin1.relation, pin2.relation) else { return nil }
    return BoxLayout.Pin(value: pin1.value + pin2.value, relation: rel)
}

prefix operator >=
prefix func >=(v: CGFloat?) -> BoxLayout.Pin? {
    return .gteq(v)
}

prefix func >=(v: Double?) -> BoxLayout.Pin? {
    if let v = v {
        return .gteq(CGFloat(v))
    }
    return nil
}

prefix operator <=
prefix func <=(v: CGFloat?) -> BoxLayout.Pin? {
    return .lteq(v)
}

prefix func <=(v: Double?) -> BoxLayout.Pin? {
    if let v = v {
        return .lteq(CGFloat(v))
    }
    return nil
}

prefix operator ==
prefix func ==(v: CGFloat?) -> BoxLayout.Pin? {
    return .eq(v)
}

prefix func ==(v: Double?) -> BoxLayout.Pin? {
    if let v = v {
        return .eq(CGFloat(v))
    }
    return nil
}
