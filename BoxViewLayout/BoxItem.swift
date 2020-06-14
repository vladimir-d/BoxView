//
//  BoxItem.swift
//  BoxViewExample
//
//  Created by Vlad on 5/17/20.
//  Copyright © 2020 Vlad. All rights reserved.
//

import UIKit

// MARK: - Public

public struct BoxItem {
    public var view: UIView
    public var layout: BoxLayout
    
    public init(view: UIView, layout: BoxLayout = .zero) {
        self.view = view
        self.layout = layout
    }
    
    // creates new BoxItem from existing, by adding left pin
    public func boxLeft(_ leftPin: BoxLayout.Pin?) -> Self {
        return Self.init(view: view, layout: layout.with(.left, leftPin))
    }
    
    // creates new BoxItem from existing, by adding right pin
    public func boxRight(_ rightPin: BoxLayout.Pin?) -> Self {
        return Self.init(view: view, layout: layout.with(.right, rightPin))
    }
    
    // creates new BoxItem from existing, by adding top pin
    public func boxTop(_ topPin: BoxLayout.Pin?) -> Self {
        return Self.init(view: view, layout: layout.with(.top, topPin))
    }
    
    // creates new BoxItem from existing, by adding bottom pin
    public func boxBottom(_ bottomPin: BoxLayout.Pin?) -> Self {
        return Self.init(view: view, layout: layout.with(.bottom, bottomPin))
    }
    
    // creates new BoxItem from existing, by adding left and right pins
    public func boxLeftRight(_ leftPin: BoxLayout.Pin?, _ rightPin: BoxLayout.Pin?) -> BoxItem {
        return Self.init(view: view, layout: layout.with(.left, leftPin).with(.right, rightPin))
    }
    
    // creates new BoxItem from existing, by adding top and bottom pins
    public func boxTopBottom(_ topPin: BoxLayout.Pin?, _ bottomPin: BoxLayout.Pin?) -> BoxItem {
        return Self.init(view: view, layout: layout.with(.top, topPin).with(.bottom, bottomPin))
    }
    
    // creates new BoxItem from existing, by adding alignment along X-axis
    public func xAligned(offset: CGFloat = 0.0, padding: CGFloat? = 0.0) -> BoxItem {
        let alignedItem =  Self.init(view: view, layout: layout.with(.centerX, ==offset))
        if let padding = padding {
            let paddingPin = >=padding
            return alignedItem.boxLeftRight(paddingPin, paddingPin)
        }
        else {
            return alignedItem
        }
    }
    
    // creates new BoxItem from existing, by adding alignment along Y-axis
    public func yAligned(offset: CGFloat = 0.0, padding: CGFloat? = 0.0) -> BoxItem {
        let alignedItem =  Self.init(view: view, layout: layout.with(.centerY, ==offset))
        if let padding = padding {
            let paddingPin = >=padding
            return alignedItem.boxTopBottom(paddingPin, paddingPin)
        }
        else {
            return alignedItem
        }
    }
 
}


extension UIView {
    
    // Creates BoxItem with view and specified box layouts for X and Y ases.
    public func boxXY(_ x: BoxLayout.Pin.Pair, _ y: BoxLayout.Pin.Pair) -> BoxItem {
        return BoxItem(view: self, layout: .pairs(x: x, y: y))
    }
    
    // Creates BoxItem with view and specified box layout
    public func boxLayout(_ layout: BoxLayout) -> BoxItem {
        return BoxItem(view: self, layout: layout)
    }
    
    // Creates BoxItem with view and zero constant constraints to all four edges.
    public var boxZero: BoxItem {
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
    
    // Creates BoxItem with view and layout with right pin.
    public func boxRight(_ rightPin: BoxLayout.Pin?) -> BoxItem {
        return BoxItem(view: self, layout: .withPins(right: rightPin))
    }
    
    // Creates BoxItem with view and layout with left and right pins.
    public func boxLeftRight(_ leftPin: BoxLayout.Pin?, _ rightPin: BoxLayout.Pin?) -> BoxItem {
        return BoxItem(view: self, layout: .withPins(left: leftPin, right: rightPin))
    }
    
    // Creates BoxItem with view and layout with top pin.
    public func boxTop(_ topPin: BoxLayout.Pin?) -> BoxItem {
        return BoxItem(view: self, layout: .withPins(top: topPin))
    }
    
    // Creates BoxItem with view and layout with bottom pin.
    public func boxBottom(_ bottomPin: BoxLayout.Pin?) -> BoxItem {
        return BoxItem(view: self, layout: .withPins(bottom: bottomPin))
    }
    
    // Creates BoxItem with view and layout with top and bottom pins.
    public func boxTopBottom(_ topPin: BoxLayout.Pin?, _ bottomPin: BoxLayout.Pin?) -> BoxItem {
        return BoxItem(view: self, layout: .withPins(top: topPin, bottom: bottomPin))
    }
    
    // Creates BoxItem with view and layout is center alignment along X-Axis.
    // Offset from center and same minimal padding from both sides can be specified (default 0.0)
    public func xAligned(offset: CGFloat = 0.0, padding: CGFloat? = 0.0) -> BoxItem {
        return BoxItem(view: self, layout: .xAligned(offset: offset, padding: padding))
    }
    
    // Creates BoxItem with view and layout is center alignment along Y-Axis.
    // Offset from center and same minimal padding from both sides can be specified (default 0.0)
    public func yAligned(offset: CGFloat = 0.0, padding: CGFloat? = 0.0) -> BoxItem {
        return BoxItem(view: self, layout: .yAligned(offset: offset, padding: padding))
    }

    // Creates BoxItem with view and layout where top, left, bootom and right insets are taken from UIEdgeInsets.
    public func boxInsets(_ insets: UIEdgeInsets?) -> BoxItem {
        return BoxItem(view: self, layout: .withPins(top: ==(insets?.top), left: ==(insets?.left), bottom: ==(insets?.bottom), right: ==(insets?.right)))
    }
    
    public func boxAll(_ padding: CGFloat) -> BoxItem {
        return boxInsets(.all(padding))
    }
    
    @discardableResult
    public func addBoxItem(_ item: BoxItem, semanticDependent: Bool = true) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        addSubview(item.view)
        for edge in BoxEdge.allCases {
            if let pin = item.layout.pinForEdge(edge) {
                let attr = edge.attribute(semanticDependent: semanticDependent)
                constraints.append(item.view.alPin(attr, to: attr, of: self, pin: pin))
            }
        }
        return constraints
    }

}

extension Array where Element: UIView {
    
    public func boxXY(_ x: BoxLayout.Pin.Pair, _ y: BoxLayout.Pin.Pair) -> [BoxItem] {
        let layout = BoxLayout.pairs(x: x, y: y)
        return self.map{BoxItem(view: $0, layout: layout)}
    }
    
    // Creates BoxItems array from array of views using specified layout for all views.
    public func boxLayout(_ layout: BoxLayout) -> [BoxItem] {
        return self.map{BoxItem(view: $0, layout: layout)}
    }
    
    // Creates BoxItems array from array of views using same "zero" layout (zero constant constraints to all four edges) for all views.
    public var boxZero: [BoxItem] {
        return self.map{BoxItem(view: $0, layout: .zero)}
    }
    
    
    public func inBoxView(axis: BoxLayout.Axis = .y, spacing: CGFloat = 0.0, insets: UIEdgeInsets = .zero) -> BoxView {
        let boxView = BoxView(axis: axis, spacing: spacing, insets: insets)
        boxView.items = self.boxZero
        return boxView
    }
    
}
