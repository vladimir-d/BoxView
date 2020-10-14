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
    
    public struct Pin: CustomStringConvertible {
        
        public var constant: CGFloat = 0.0
        public var relation: NSLayoutConstraint.Relation = .equal
        public var priority: UILayoutPriority = .required
        
        public init(constant: CGFloat = 0.0, relation: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) {
            self.constant = constant
            self.relation = relation
            self.priority = priority
        }
        
        public init(_ constant: Double) {
            self = Pin(constant: CGFloat(constant))
        }

        public static let zero = Pin(constant: 0.0)
        
        public static func equal(_ constant: CGFloat?) -> Pin? {
            if let constant = constant {
                return Pin(constant: constant, relation: .equal)
            }
            else{
                return nil
            }
        }
        
        public static func greaterThanOrEqual(_ constant: CGFloat? = 0.0) -> Pin? {
            if let constant = constant {
                return Pin(constant: constant, relation: .greaterThanOrEqual)
            }
            else{
                return nil
            }
        }
        
        public static func lessThanOrEqual(_ constant: CGFloat?) -> Pin? {
            if let constant = constant {
                return Pin(constant: constant, relation: .lessThanOrEqual)
            }
            else{
                return nil
            }
        }
        
        public func withPriority(_ pr: UILayoutPriority) -> Pin {
            return Pin(constant: constant, relation: relation, priority: pr)
        }
        
        public func required(_ offset: Float = 0.0) -> Pin {
            var newPin = self
            newPin.priority = UILayoutPriority(UILayoutPriority.required.rawValue + offset)
            return newPin
        }
        
        public func high(_ offset: Float = 0.0) -> Pin {
            var newPin = self
            newPin.priority = UILayoutPriority(UILayoutPriority.defaultHigh.rawValue + offset)
            return newPin
        }
        
        public func low(_ offset: Float = 0.0) -> Pin {
            var newPin = self
            newPin.priority = UILayoutPriority(UILayoutPriority.defaultLow.rawValue + offset)
            return newPin
        }
        
        public func exact(_ value: Float) -> Pin {
            var newPin = self
            newPin.priority = UILayoutPriority(value)
            return newPin
        }
        
        public var description: String {
            var str = "\(relationString)\(constant)"
            if priority != .required {
                str += " & \(priority)"
            }
            return str
        }
        
        var relationString: String {
            switch self.relation {
                case .greaterThanOrEqual: return ">="
                case .lessThanOrEqual: return "<="
                default: return ""
            }
        }
        
        
         static func joinRelations(_ rel1: NSLayoutConstraint.Relation, _ rel2: NSLayoutConstraint.Relation) -> NSLayoutConstraint.Relation? {
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
        
        static func sumPinWarning() {
            assertionFailure("Joining constraints relations must be either same or one of them must be NSLayoutConstraint.Relation.equal")
        }
        
    }
}

extension BoxLayout {

    public struct MultiPin {
        public var pin: Pin = .zero
        public var multiplier: CGFloat = 1.0
        
        public var constant: CGFloat {
            get { return pin.constant }
            set { pin.constant = newValue }
        }
        
        public var relation: NSLayoutConstraint.Relation {
            get { return pin.relation }
            set { pin.relation = newValue }
        }
        
        public var priority: UILayoutPriority {
            get { return pin.priority }
            set { pin.priority = newValue }
        }
        
        public init(_ pin: Pin) {
            self.pin = pin
        }
        
        public init?(_ pin: Pin?) {
            if let pin = pin {
                self.pin = pin
            }
            else {
                return nil
            }
        }
        
        public func withPriority(_ pr: UILayoutPriority) -> MultiPin {
            var newPin = self
            newPin.priority = pr
            return newPin
        }
        
        public func required(_ offset: Float = 0.0) -> MultiPin {
            var newPin = self
            newPin.priority = UILayoutPriority(UILayoutPriority.required.rawValue + offset)
            return newPin
        }
        
        public func high(_ offset: Float = 0.0) -> MultiPin {
            var newPin = self
            newPin.priority = UILayoutPriority(UILayoutPriority.defaultHigh.rawValue + offset)
            return newPin
        }
        
        public func low(_ offset: Float = 0.0) -> MultiPin {
            var newPin = self
            newPin.priority = UILayoutPriority(UILayoutPriority.defaultLow.rawValue + offset)
            return newPin
        }
        
        public func exact(_ value: Float) -> MultiPin {
            var newPin = self
            newPin.priority = UILayoutPriority(value)
            return newPin
        }
        
        public init(multiplier: CGFloat = 1.0, pin: Pin = .zero) {
            self.pin = pin
            self.multiplier = multiplier
        }
        
        public init(multiplier: CGFloat = 1.0, constant: CGFloat = 0.0, relation: NSLayoutConstraint.Relation = .equal) {
            self.constant = constant
            self.multiplier = multiplier
            self.relation = relation
        }
        
        public init(_ multiplier: Double) {
            self = MultiPin(multiplier: CGFloat(multiplier), pin: .zero)
        }
        
    }
}

func + (pin1: BoxLayout.Pin?, pin2: BoxLayout.Pin?) -> BoxLayout.Pin? {
    guard let pin1 = pin1, let pin2 = pin2 else { return nil }
    guard let rel = BoxLayout.Pin.joinRelations(pin1.relation, pin2.relation) else { return nil }
    return BoxLayout.Pin(constant: pin1.constant + pin2.constant, relation: rel, priority: min(pin1.priority, pin2.priority))
}

func + (pin: BoxLayout.Pin, value: CGFloat) -> BoxLayout.Pin {
    return BoxLayout.Pin(constant: pin.constant + value, relation: pin.relation, priority: pin.priority)
}

func + (pin: BoxLayout.Pin?, value: CGFloat) -> BoxLayout.Pin? {
    if let pin = pin {
        return BoxLayout.Pin(constant: pin.constant + value, relation: pin.relation, priority: pin.priority)
    }
    return nil
}

func & (pin: BoxLayout.Pin, priority: UILayoutPriority) -> BoxLayout.Pin {
    return BoxLayout.Pin(constant: pin.constant, relation: pin.relation, priority: priority)
}

func & (priority: UILayoutPriority, pin: BoxLayout.Pin) -> BoxLayout.Pin {
    return BoxLayout.Pin(constant: pin.constant, relation: pin.relation, priority: priority)
}


func * (pin: BoxLayout.Pin?, multiplier: CGFloat) -> BoxLayout.MultiPin? {
    guard let pin = pin else { return nil }
    return BoxLayout.MultiPin(multiplier: multiplier, pin: pin)
}

func * (mPin: BoxLayout.MultiPin?, multiplier: CGFloat) -> BoxLayout.MultiPin? {
    guard let mPin = mPin else { return nil }
    return BoxLayout.MultiPin(multiplier: mPin.multiplier * multiplier, pin: mPin.pin)
}

func & (mPin: BoxLayout.MultiPin, priority: UILayoutPriority) -> BoxLayout.MultiPin {
    return mPin.withPriority(priority)
}

func & (priority: UILayoutPriority, mPin: BoxLayout.MultiPin) -> BoxLayout.MultiPin {
    return mPin.withPriority(priority)
}


prefix operator *
public prefix func *(m: CGFloat) -> BoxLayout.MultiPin {
    return BoxLayout.MultiPin(multiplier: m)
}

public prefix func *(m: Double) -> BoxLayout.MultiPin {
    return BoxLayout.MultiPin(multiplier: CGFloat(m))
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
            constant: pin.constant)
        NSLayoutConstraint.activate([constraint])
        return constraint
    }
}
