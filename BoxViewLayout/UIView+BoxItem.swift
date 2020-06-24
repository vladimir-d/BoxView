//
//  BoxItem+UIView.swift
//  BoxViewExample
//
//  Created by Vlad on 6/24/20.
//  Copyright © 2020 Vlad. All rights reserved.
//

import UIKit

extension UIView {
    
    // Creates BoxItem with view and specified box layouts for X and Y ases.
    public func boxXY(_ x: BoxLayout.Pin.Pair, _ y: BoxLayout.Pin.Pair) -> BoxItem {
        return BoxItem(view: self, layout: .pairs(x: x, y: y))
    }
    
    // Creates BoxItem with view and specified box layout
    public func boxLayout(_ layout: BoxLayout) -> BoxItem {
        return BoxItem(view: self, layout: layout)
    }
    
    // deprecated, same as boxed
    public var boxZero: BoxItem {
        return BoxItem(view: self, layout: .zero)
    }
    
    // Creates BoxItem with view and zero constant constraints to all four edges.
    public var boxed: BoxItem {
        return BoxItem(view: self, layout: .zero)
    }
    
    // Creates BoxItem with view and layout with pins for edges from dictionary.
    public func boxEdgePins(_ pins: BoxLayout.EdgePins) -> BoxItem {
        return BoxItem(view: self, layout: .boxEdgePins(pins))
    }
    
    // Creates BoxItem with view and layout with left pin.
    public func boxLeft(_ leftPin: BoxLayout.Pin?) -> BoxItem {
        return BoxItem(view: self, layout: .withPins(left: leftPin))
    }
    
    // Creates BoxItem with view and layout with exact left padding.
    public func boxLeft(_ left: CGFloat) -> BoxItem {
        return BoxItem(view: self, layout: .withPins(left: ==left))
    }
    
    // Creates BoxItem with view and layout with right pin.
    public func boxRight(_ rightPin: BoxLayout.Pin?) -> BoxItem {
        return BoxItem(view: self, layout: .withPins(right: rightPin))
    }
    
    // Creates BoxItem with view and layout with exact right padding.
    public func boxRight(_ right: CGFloat) -> BoxItem {
        return BoxItem(view: self, layout: .withPins(right: ==right))
    }
    
    // Creates BoxItem with view and layout with left and right pins.
    public func boxLeftRight(_ leftPin: BoxLayout.Pin?, _ rightPin: BoxLayout.Pin?) -> BoxItem {
        return BoxItem(view: self, layout: .withPins(left: leftPin, right: rightPin))
    }
    
    // Creates BoxItem with view and layout with exact left and right paddings.
    public func boxLeftRight(_ left: CGFloat?, _ right: CGFloat) -> BoxItem {
        return BoxItem(view: self, layout: .withPins(left: ==left, right: ==right))
    }
    
    // Creates BoxItem with view and layout with top pin.
    public func boxTop(_ topPin: BoxLayout.Pin?) -> BoxItem {
        return BoxItem(view: self, layout: .withPins(top: topPin))
    }
    
    // Creates BoxItem with view and layout with exact top padding.
    public func boxTop(_ top: CGFloat) -> BoxItem {
        return BoxItem(view: self, layout: .withPins(top: ==top))
    }
    
    // Creates BoxItem with view and layout with bottom pin.
    public func boxBottom(_ bottomPin: BoxLayout.Pin?) -> BoxItem {
        return BoxItem(view: self, layout: .withPins(bottom: bottomPin))
    }
    
    // Creates BoxItem with view and layout with exact bottom padding.
    public func boxBottom(_ bottom: CGFloat) -> BoxItem {
        return BoxItem(view: self, layout: .withPins(bottom: ==bottom))
    }
    
    // Creates BoxItem with view and layout with top and bottom pins.
    public func boxTopBottom(_ topPin: BoxLayout.Pin?, _ bottomPin: BoxLayout.Pin?) -> BoxItem {
        return BoxItem(view: self, layout: .withPins(top: topPin, bottom: bottomPin))
    }
    
    // Creates BoxItem with view and layout with top and bottom pins.
    public func boxTopBottom(_ top: CGFloat?, _ bottom: CGFloat) -> BoxItem {
        return BoxItem(view: self, layout: .withPins(top: ==top, bottom: ==bottom))
    }
    
    // Creates BoxItem with view and layout is center alignment along X-Axis.
    // Offset from center and same minimal padding from both sides can be specified (default 0.0)
    public func boxCenterX(offset: CGFloat = 0.0, padding: CGFloat? = 0.0) -> BoxItem {
        return BoxItem(view: self, layout: .xCentered(offset: offset, padding: padding))
    }
    
    // Creates BoxItem with view and layout is center alignment along Y-Axis.
    // Offset from center and same minimal padding from both sides can be specified (default 0.0)
    public func boxCenterY(offset: CGFloat = 0.0, padding: CGFloat? = 0.0) -> BoxItem {
        return BoxItem(view: self, layout: .yCentered(offset: offset, padding: padding))
    }

    // Creates BoxItem with view and layout where top, left, bootom and right insets are taken from UIEdgeInsets.
    public func boxInsets(_ insets: UIEdgeInsets?) -> BoxItem {
        return BoxItem(view: self, layout: .withPins(top: ==(insets?.top), left: ==(insets?.left), bottom: ==(insets?.bottom), right: ==(insets?.right)))
    }
    
    public func boxAll(_ padding: CGFloat) -> BoxItem {
        return boxInsets(UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding))
    }
    
    @discardableResult
    public func addBoxItem(_ item: BoxItem, rtlDependent: Bool = true) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        item.view?.translatesAutoresizingMaskIntoConstraints = false
        if let view = item.view {
            addSubview(view)
        
            for edge in BoxEdge.allCases {
                if let pin = item.layout.pinForEdge(edge) {
                    let attr = edge.attribute(rtlDependent: rtlDependent)
                    if (edge.position == .end) {
                        constraints.append(self.alPin(attr, to: attr, of: view, pin: pin))
                    }
                    else {
                        constraints.append(view.alPin(attr, to: attr, of: self, pin: pin))
                    }
                }
            }
        }
        return constraints
    }

}

extension Array where Element: UIView {
    
    
    public func boxXY(_ x: BoxLayout.Pin.Pair, _ y: BoxLayout.Pin.Pair) -> [BoxItem] {
        let layout = BoxLayout.pairs(x: x, y: y)
        return map{BoxItem(view: $0, layout: layout)}
    }
    
    // Creates BoxItems array from array of views using specified layout for all views.
    public func boxLayout(_ layout: BoxLayout) -> [BoxItem] {
        return map{BoxItem(view: $0, layout: layout)}
    }
    
    // Creates BoxItems array from array of views using same "zero" layout (zero constant constraints to all four edges) for all views.
    public var boxZero: [BoxItem] {
        return map{BoxItem(view: $0, layout: .zero)}
    }
    
    
    public func inBoxView(axis: BoxLayout.Axis = .y, spacing: CGFloat = 0.0, insets: UIEdgeInsets = .zero) -> BoxView {
        let boxView = BoxView(axis: axis, spacing: spacing, insets: insets)
        boxView.items = self.boxZero
        return boxView
    }
    
}
