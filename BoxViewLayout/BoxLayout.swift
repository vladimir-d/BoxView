//
//  BoxLayout.swift
//  BoxView
//
//  Created by Vlad on 5/10/20.
//  Copyright © 2020 Vladimir Dudkin. All rights reserved.
//

import UIKit

public struct BoxLayout {
    
    public typealias EdgePins =  [BoxEdge: Pin?]

    public static var padding = CGSize(width: 16.0, height: 16.0)
    
    public var h: H
    
    public var v: V
    
    public init(h: H, v: V) {
        self.h = h
        self.v = v
    }
    
    public init(top: CGFloat?, left: CGFloat?, bottom: CGFloat?, right: CGFloat?) {
        self.h = H(left: ==left, right: ==right, center: nil)
        self.v = V(top: ==top, bottom: ==bottom, center: nil)
    }

    public static let zero = BoxLayout(h: .zero, v: .zero)
    
    public static func hv(_ h: H, _ v: V) -> BoxLayout {
        return BoxLayout(h: h, v: v)
    }
    
    public mutating func setPin(_ pin: Pin?, for edge: BoxEdge) {
        switch edge {
            case .left: h.left = pin
            case .right: h.right = pin
            case .top: v.top = pin
            case .bottom: v.bottom = pin
            default: ()
        }
    }
    
    public static func withEdgePins(_ pins: EdgePins) -> BoxLayout {
        var layout = BoxLayout.zero
        for (edge, pin) in pins {
            layout.setPin(pin, for: edge)
        }
        return layout
    }
    
    public func with(_ edge: BoxEdge, _ pin: Pin?) -> BoxLayout {
        var newLayout = self
        switch edge {
            case .top: newLayout.v.top = pin
            case .left: newLayout.h.left = pin
            case .bottom: newLayout.v.bottom = pin
            case .right: newLayout.h.right = pin
            default: ()
        }
        return newLayout
    }
    
    func begin(_ axis: Axis) -> Pin? {
        return (axis == .y) ? v.top : h.left
    }
    
    func end(_ axis: Axis) -> Pin? {
        return (axis == .y) ? v.bottom : h.right
    }
    
    func center(_ axis: Axis) -> Pin? {
        return (axis == .y) ? v.center : h.center
    }
    
    func pinForAxis(_ axis: Axis, position: BoxEdge.Position) -> Pin? {
        switch position {
            case .begin: return (axis == .y) ? v.top : h.left
            case .center: return (axis == .y) ? v.center : h.center
            case .end: return (axis == .y) ? v.bottom : h.right
        }
    }

}



