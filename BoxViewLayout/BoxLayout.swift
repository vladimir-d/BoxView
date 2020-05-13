//
//  BoxLayout.swift
//  BoxView
//
//  Created by Vlad on 5/10/20.
//  Copyright © 2020 Vladimir Dudkin. All rights reserved.
//

import UIKit

struct BoxLayout {
    
    static var systemDirectionFactor: CGFloat {
        switch UIApplication.shared.userInterfaceLayoutDirection {
            case .leftToRight: return 1.0
            case .rightToLeft: return -1.0
            @unknown default:
            return 1.0
        }
    }

    static var padding = CGSize(width: 16.0, height: 16.0)
    
    var h: H
    
    var v: V
    
    typealias EdgePins =  [BoxLayout.Edge: Pin?]
    
    static let zero = BoxLayout(h: .zero, v: .zero)
    
    static func hv(_ h: H, _ v: V) -> BoxLayout {
        return BoxLayout(h: h, v: v)
    }
    
    mutating func setPin(_ pin: Pin?, for edge: BoxLayout.Edge) {
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

    
    func with(_ edge: BoxLayout.Edge, _ pin: Pin?) -> BoxLayout {
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
    
    func beginAttributeForAxis(_ axis: Axis) -> NSLayoutConstraint.Attribute {
        if axis == .vertical {
            return .top
        }
        else {
            switch h.semanticDirection {
                case .system: return .leading
                case .fixedLTR: return .left
                case .fixedRTL: return .right
            }
        }
    }
    
    func endAttributeForAxis(_ axis: Axis) -> NSLayoutConstraint.Attribute {
        if axis == .vertical {
            return .bottom
        }
        else {
            switch h.semanticDirection {
                case .system: return .trailing
                case .fixedLTR: return .right
                case .fixedRTL: return .left
            }
        }
    }
    
    func centerOffsetFactorForAxis(_ axis: Axis) -> CGFloat {
        if axis == .vertical {
            return 1.0
        }
        else {
            switch h.semanticDirection {
                case .system: return BoxLayout.systemDirectionFactor
                case .fixedLTR: return 1.0
                case .fixedRTL: return 1.0
            }
        }
    }
}


struct BoxItem {
    var view: UIView
    var layout: BoxLayout
    
    init(view: UIView, layout: BoxLayout = .zero) {
        self.view = view
        self.layout = layout
    }
}

extension UIView {
    
    func hv(_ h: BoxLayout.H, _ v: BoxLayout.V) -> BoxItem {
        return BoxItem(view: self, layout: .hv(h, v))
    }
    
    func withLayout(_ layout: BoxLayout) -> BoxItem {
        return BoxItem(view: self, layout: layout)
    }
    
    func withPins(_ pins: BoxLayout.EdgePins) -> BoxItem {
        return BoxItem(view: self, layout: .pins(pins))
    }

    var zeroLayout: BoxItem {
        return BoxItem(view: self, layout: .zero)
    }
}
