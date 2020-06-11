//
//  BoxLayout.swift
//  BoxView
//
//  Created by Vlad on 5/10/20.
//  Copyright © 2020 Vladimir Dudkin. All rights reserved.
//

import UIKit

// MARK: - Public

// BoxLayout contains information about constraint parameters (constant and relation)
// for 6 NSLayoutConstraint Attributes: top, left, bottom, right, centerX and centerY
public struct BoxLayout {

    public typealias EdgePins =  [BoxEdge: Pin?]
    
    public var left: Pin?

    public var right: Pin?

    public var centerX: Pin?
    
    public var top: Pin?

    public var bottom: Pin?

    public var centerY: Pin?
    
    public init() {
    }
    
    public static func withPins(top: Pin? = .zero, left: Pin? = .zero, bottom: Pin? = .zero, right: Pin? = .zero) -> BoxLayout {
        var layout = BoxLayout()
        layout.top = top
        layout.bottom = bottom
        layout.left = left
        layout.right = right
        return layout
    }

    public static let zero = withPins()
    
    public static func pairs(x: BoxLayout.Pin.Pair, y: BoxLayout.Pin.Pair) -> BoxLayout {
        return withPins(top: y.begin, left: x.begin, bottom: y.end, right: x.end)
    }
    
    public mutating func setPin(_ pin: Pin?, for edge: BoxEdge) {
        switch edge {
            case .left: self.left = pin
            case .right: self.right = pin
            case .top: self.top = pin
            case .bottom: self.bottom = pin
            case .centerX: self.centerX = pin
            case .centerY: self.centerY = pin
        }
    }
    
    public static func boxEdgePins(_ pins: EdgePins) -> BoxLayout {
        var layout = BoxLayout.zero
        for (edge, pin) in pins {
            layout.setPin(pin, for: edge)
        }
        return layout
    }
    
    public static func xAligned(offset: CGFloat = 0.0, padding: CGFloat? = 0.0) -> BoxLayout {
        var layout = BoxLayout()
        layout.centerX = ==offset
        if let padding = padding {
            layout.left = >=padding
            layout.right = >=padding
        }
        layout.top = .zero
        layout.bottom = .zero
        return layout
    }
    
    public static func yAligned(offset: CGFloat = 0.0, padding: CGFloat? = 0.0) -> BoxLayout {
        var layout = BoxLayout()
        layout.centerY = ==offset
        layout.left = .zero
        layout.right = .zero
        if let padding = padding {
            layout.top = >=padding
            layout.bottom = >=padding
        }
        return layout
    }
    
    public func with(_ edge: BoxEdge, _ pin: Pin?) -> BoxLayout {
        var newLayout = self
        newLayout.setPin(pin, for: edge)
        return newLayout
    }
    
    func begin(_ axis: Axis) -> Pin? {
        return (axis == .y) ? self.top : self.left
    }
    
    func end(_ axis: Axis) -> Pin? {
        return (axis == .y) ? self.bottom : self.right
    }
    
    func center(_ axis: Axis) -> Pin? {
        return (axis == .y) ? self.centerY : self.centerX
    }
    
    func pinForAxis(_ axis: Axis, position: BoxEdge.Position) -> Pin? {
        switch position {
            case .begin: return (axis == .y) ? self.top : self.left
            case .center: return (axis == .y) ? self.centerY : self.centerX
            case .end: return (axis == .y) ? self.bottom : self.right
        }
    }

}



