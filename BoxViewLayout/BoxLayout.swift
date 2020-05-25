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
    
    public var x: X
    
    public var y: Y
    
    public init(x: X, y: Y) {
        self.x = x
        self.y = y
    }
    
    public init(top: CGFloat?, left: CGFloat?, bottom: CGFloat?, right: CGFloat?) {
        self.x = X(left: ==left, right: ==right, center: nil)
        self.y = Y(top: ==top, bottom: ==bottom, center: nil)
    }

    public static let zero = BoxLayout(x: .zero, y: .zero)
    
    public static func boxXY(_ x: X, _ y: Y) -> BoxLayout {
        return BoxLayout(x: x, y: y)
    }
    
    public mutating func setPin(_ pin: Pin?, for edge: BoxEdge) {
        switch edge {
            case .left: x.left = pin
            case .right: x.right = pin
            case .top: y.top = pin
            case .bottom: y.bottom = pin
            default: ()
        }
    }
    
    public static func boxEdgePins(_ pins: EdgePins) -> BoxLayout {
        var layout = BoxLayout.zero
        for (edge, pin) in pins {
            layout.setPin(pin, for: edge)
        }
        return layout
    }
    
    public func with(_ edge: BoxEdge, _ pin: Pin?) -> BoxLayout {
        var newLayout = self
        switch edge {
            case .top: newLayout.y.top = pin
            case .left: newLayout.x.left = pin
            case .bottom: newLayout.y.bottom = pin
            case .right: newLayout.x.right = pin
            default: ()
        }
        return newLayout
    }
    
    func begin(_ axis: Axis) -> Pin? {
        return (axis == .y) ? y.top : x.left
    }
    
    func end(_ axis: Axis) -> Pin? {
        return (axis == .y) ? y.bottom : x.right
    }
    
    func center(_ axis: Axis) -> Pin? {
        return (axis == .y) ? y.center : x.center
    }
    
    func pinForAxis(_ axis: Axis, position: BoxEdge.Position) -> Pin? {
        switch position {
            case .begin: return (axis == .y) ? y.top : x.left
            case .center: return (axis == .y) ? y.center : x.center
            case .end: return (axis == .y) ? y.bottom : x.right
        }
    }

}



