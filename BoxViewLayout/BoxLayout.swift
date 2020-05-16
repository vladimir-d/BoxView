//
//  BoxLayout.swift
//  BoxView
//
//  Created by Vlad on 5/10/20.
//  Copyright © 2020 Vladimir Dudkin. All rights reserved.
//

import UIKit

public struct BoxLayout {
    
    public static var systemDirectionFactor: CGFloat {
        switch UIApplication.shared.userInterfaceLayoutDirection {
            case .leftToRight: return 1.0
            case .rightToLeft: return -1.0
            @unknown default:
            return 1.0
        }
    }

    public static var padding = CGSize(width: 16.0, height: 16.0)
    
    var h: H
    
    var v: V
    
    public typealias EdgePins =  [BoxEdge: Pin?]
    
    public static let zero = BoxLayout(h: .zero, v: .zero)
    
    public static func hv(_ h: H, _ v: V) -> BoxLayout {
        return BoxLayout(h: h, v: v)
    }
    
    mutating func setPin(_ pin: Pin?, for edge: BoxEdge) {
        switch edge {
            case .left: h.left = pin
            case .right: h.right = pin
            case .top: v.top = pin
            case .bottom: v.bottom = pin
            default: ()
        }
    }
    
    static func pins(_ pins: EdgePins) -> BoxLayout {
        var layout = BoxLayout.zero
        for (edge, pin) in pins {
            layout.setPin(pin, for: edge)
        }
        return layout
    }
    
    func with(_ edge: BoxEdge, _ pin: Pin?) -> BoxLayout {
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
    
    init(h: H, v: V) {
        self.h = h
        self.v = v
    }
    
    init(top: CGFloat?, left: CGFloat?, bottom: CGFloat?, right: CGFloat?) {
        self.h = H(left: Pin.eq(left), right: Pin.eq(right), center: nil)
        self.v = V(top: Pin.eq(top), bottom: Pin.eq(bottom), center: nil)
    }
    
    func begin(_ axis: Axis) -> Pin? {
        return (axis == .vertical) ? v.top : h.left
    }
    
    func end(_ axis: Axis) -> Pin? {
        return (axis == .vertical) ? v.bottom : h.right
    }
    
    func center(_ axis: Axis) -> Pin? {
        return (axis == .vertical) ? v.center : h.center
    }
    
    func pinForAxis(_ axis: Axis, position: BoxEdge.Position) -> Pin? {
        switch position {
            case .begin: return (axis == .vertical) ? v.top : h.left
            case .center: return (axis == .vertical) ? v.center : h.center
            case .end: return (axis == .vertical) ? v.bottom : h.right
        }
    }

}


public struct BoxItem {
    var view: UIView
    var layout: BoxLayout
    
    public init(view: UIView, layout: BoxLayout = .zero) {
        self.view = view
        self.layout = layout
    }
}

extension UIEdgeInsets {
    func begin(_ axis: BoxLayout.Axis) -> CGFloat {
        return (axis == .vertical) ? self.top : self.left
    }
    
    func end(_ axis: BoxLayout.Axis)  -> CGFloat {
        return (axis == .vertical) ? self.bottom : self.right
    }
    
    func insetForAxis(_ axis: BoxLayout.Axis, position: BoxEdge.Position)  -> CGFloat {
        switch position {
            case .begin: return (axis == .vertical) ? self.top : self.left
            case .center: return 0.0
            case .end: return (axis == .vertical) ? self.bottom : self.right
        }
    }
}

extension UIView {
    
    public func hv(_ h: BoxLayout.H, _ v: BoxLayout.V) -> BoxItem {
        return BoxItem(view: self, layout: .hv(h, v))
    }
    
    public func withLayout(_ layout: BoxLayout) -> BoxItem {
        return BoxItem(view: self, layout: layout)
    }
    
    public func withPins(_ pins: BoxLayout.EdgePins) -> BoxItem {
        return BoxItem(view: self, layout: .pins(pins))
    }

    public var zeroLayout: BoxItem {
        return BoxItem(view: self, layout: .zero)
    }
}
