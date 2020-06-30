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
public struct BoxLayout: CustomStringConvertible {

    public typealias EdgePins =  [BoxEdge: Pin?]
    
    public var left: Pin?

    public var right: Pin?

    public var centerX: Pin? = nil
    
    public var top: Pin?

    public var bottom: Pin?

    public var centerY: Pin?
    
    public var width: Pin?
    
    public var relativeWidth: MultiPin?
    
    public var height: Pin?
    
    public var relativeHeight: MultiPin?
    
    public var flex: CGFloat?
    
    public init() {
        top = .zero
        bottom = .zero
        left = .zero
        right = .zero
    }
    
    public static func withPins(top: Pin? = .zero, left: Pin? = .zero, bottom: Pin? = .zero, right: Pin? = .zero) -> BoxLayout {
        return BoxLayout().withPins(top: top, left: left, bottom: bottom, right: right)
    }

    public static let zero = withPins()
    
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
    
    public func pinForEdge(_ edge: BoxEdge) -> Pin? {
        switch edge {
            case .left: return self.left
            case .right: return self.right
            case .top: return self.top
            case .bottom: return self.bottom
            case .centerX: return self.centerX
            case .centerY: return self.centerY
        }
    }
    
    public static func boxEdgePins(_ pins: EdgePins) -> BoxLayout {
        var layout = BoxLayout.zero
        for (edge, pin) in pins {
            layout.setPin(pin, for: edge)
        }
        return layout
    }
    
    public static func xCentered(offset: CGFloat = 0.0, padding: CGFloat? = 0.0) -> BoxLayout {
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
    
    public static func yCentered(offset: CGFloat = 0.0, padding: CGFloat? = 0.0) -> BoxLayout {
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
    
    public func withPins(top: Pin? = .zero, left: Pin? = .zero, bottom: Pin? = .zero, right: Pin? = .zero) -> BoxLayout {
        var layout = self
        layout.top = top
        layout.bottom = bottom
        layout.left = left
        layout.right = right
        return layout
    }
    
    public func with(_ edge: BoxEdge, _ pin: Pin?) -> BoxLayout {
        var newLayout = self
        newLayout.setPin(pin, for: edge)
        return newLayout
    }
    
    public func withLeft(_ leftPin: Pin?) -> BoxLayout {
        var newLayout = self
        newLayout.left = leftPin
        return newLayout
    }
    
    public func withRight(_ rightPin: Pin?) -> BoxLayout {
        var newLayout = self
        newLayout.right = rightPin
        return newLayout
    }
    
    public func withTop(_ topPin: Pin?) -> BoxLayout {
        var newLayout = self
        newLayout.top = topPin
        return newLayout
    }
    
    public func withBottom(_ bottomPin: Pin?) -> BoxLayout {
        var newLayout = self
        newLayout.top = bottomPin
        return newLayout
    }
    
    public func withWidth(_ widthPin: Pin?) -> BoxLayout {
        var newLayout = self
        newLayout.width = widthPin
        return newLayout
    }
    
    public func withRelativeWidth(_ widthPin: MultiPin?) -> BoxLayout {
        var newLayout = self
        newLayout.relativeWidth = widthPin
        return newLayout
    }
    
    public func withHeight(_ heightPin: Pin?) -> BoxLayout {
        var newLayout = self
        newLayout.height = heightPin
        return newLayout
    }
    
    public func withRelativeHeight(_ heightPin: MultiPin?) -> BoxLayout {
        var newLayout = self
        newLayout.relativeHeight = heightPin
        return newLayout
    }
    
    public func withFlex(_ flexValue: CGFloat?) -> BoxLayout {
        var newLayout = self
        newLayout.flex = flexValue
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
    
    public var description: String {
        let str = BoxEdge.allCases.compactMap { (edge) -> String? in
            if let pin = pinForEdge(edge) {
                 return "\(edge.str):\(pin)"
            }
            else{
                return nil
            }
        }.joined(separator: ", ")
        
        return str
    }

}



