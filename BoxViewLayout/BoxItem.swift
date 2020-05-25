//
//  BoxItem.swift
//  BoxViewExample
//
//  Created by Vlad on 5/17/20.
//  Copyright © 2020 Vlad. All rights reserved.
//

import UIKit

public struct BoxItem {
    public var view: UIView
    public var layout: BoxLayout
    
    public init(view: UIView, layout: BoxLayout = .zero) {
        self.view = view
        self.layout = layout
    }
    
    public func boxLeft(_ leftPin: BoxLayout.Pin?) -> Self {
        return Self.init(view: view, layout: layout.with(.left, leftPin))
    }
    
    public func boxRight(_ rightPin: BoxLayout.Pin?) -> Self {
        return Self.init(view: view, layout: layout.with(.right, rightPin))
    }
    
    public func boxTop(_ topPin: BoxLayout.Pin?) -> Self {
        return Self.init(view: view, layout: layout.with(.top, topPin))
    }
    
    public func boxBottom(_ bottomPin: BoxLayout.Pin?) -> Self {
        return Self.init(view: view, layout: layout.with(.bottom, bottomPin))
    }
    
    public func boxLeftRight(_ leftPin: BoxLayout.Pin?, _ rightPin: BoxLayout.Pin?) -> BoxItem {
        return Self.init(view: view, layout: layout.with(.left, leftPin).with(.right, rightPin))
    }
    
    public func boxTopBottom(_ topPin: BoxLayout.Pin?, _ bottomPin: BoxLayout.Pin?) -> BoxItem {
        return Self.init(view: view, layout: layout.with(.top, topPin).with(.bottom, bottomPin))
    }
}


extension UIView {
    
    // Creates BoxItem with view and specified box layouts for X and Y ases.
    public func boxXY(_ x: BoxLayout.X, _ y: BoxLayout.Y) -> BoxItem {
        return BoxItem(view: self, layout: .boxXY(x, y))
    }
    
    // Creates BoxItem with view and specified box layout
    public func boxLayout(_ layout: BoxLayout) -> BoxItem {
        return BoxItem(view: self, layout: layout)
    }
    
    // Creates BoxItem with view and zero constant constraints to all four edges.
    public var boxZero: BoxItem {
        return BoxItem(view: self, layout: .zero)
    }
    
    public func boxEdgePins(_ pins: BoxLayout.EdgePins) -> BoxItem {
        return BoxItem(view: self, layout: .boxEdgePins(pins))
    }
    
    public func boxLeft(_ leftPin: BoxLayout.Pin?) -> BoxItem {
        return BoxItem(view: self, layout: .boxXY(.xPins(leftPin, 0.0), .zero))
    }
    
    public func boxRight(_ rightPin: BoxLayout.Pin?) -> BoxItem {
        return BoxItem(view: self, layout: .boxXY(.xPins(0.0,rightPin), .zero))
    }
    
    public func boxLeftRight(_ leftPin: BoxLayout.Pin?, _ rightPin: BoxLayout.Pin?) -> BoxItem {
        return BoxItem(view: self, layout: .boxXY(.xPins(leftPin, rightPin), .zero))
    }
    
    public func boxTop(_ topPin: BoxLayout.Pin?) -> BoxItem {
        return BoxItem(view: self, layout: .boxXY(.zero, .yPins(topPin, 0.0)))
    }
    
    public func boxBottom(_ bottomPin: BoxLayout.Pin?) -> BoxItem {
        return BoxItem(view: self, layout: .boxXY(.zero, .yPins(0.0, bottomPin)))
    }
    
    public func boxTopBottom(_ topPin: BoxLayout.Pin?, _ bottomPin: BoxLayout.Pin?) -> BoxItem {
        return BoxItem(view: self, layout: .boxXY(.zero, .yPins(topPin, bottomPin)))
    }
    
    public func xAligned(offset: CGFloat = 0.0, padding: CGFloat? = 0.0) -> BoxItem {
        return BoxItem(view: self, layout: .boxXY(.align(offset: offset, padding: padding), .zero))
    }
    
    public func yAligned(offset: CGFloat = 0.0, padding: CGFloat? = 0.0) -> BoxItem {
        return BoxItem(view: self, layout: .boxXY(.zero, .align(offset: offset, padding: padding)))
    }


    public func boxInsets(_ insets: UIEdgeInsets?) -> BoxItem {
        return BoxItem(view: self, layout: .boxXY(.lr(insets?.left, insets?.right), .tb(insets?.top, insets?.bottom)))
    }

}

extension Array where Element: UIView {
    
    public func boxXY(_ x: BoxLayout.X, _ y: BoxLayout.Y) -> [BoxItem] {
        let layuot = BoxLayout.boxXY(x, y)
        return self.map{BoxItem(view: $0, layout: layuot)}
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
