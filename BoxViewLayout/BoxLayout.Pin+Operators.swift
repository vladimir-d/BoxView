//
//  BoxLayout.Pin+Operators.swift
//  BoxViewExample
//
//  Created by Vlad on 19.10.2020.
//  Copyright © 2020 Vlad. All rights reserved.
//

import UIKit

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
