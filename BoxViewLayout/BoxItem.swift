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
    
    public func pinLeft(_ leftPin: BoxLayout.Pin?) -> Self {
        return Self.init(view: view, layout: layout.with(.left, leftPin))
    }
    
    public func pinRight(_ rightPin: BoxLayout.Pin?) -> Self {
        return Self.init(view: view, layout: layout.with(.right, rightPin))
    }
    
    public func pinTop(_ topPin: BoxLayout.Pin?) -> Self {
        return Self.init(view: view, layout: layout.with(.top, topPin))
    }
    
    public func pinBottom(_ bottomPin: BoxLayout.Pin?) -> Self {
        return Self.init(view: view, layout: layout.with(.bottom, bottomPin))
    }
    
    public func pinLeftRight(_ leftPin: BoxLayout.Pin?, _ rightPin: BoxLayout.Pin?) -> BoxItem {
        return Self.init(view: view, layout: layout.with(.left, leftPin).with(.right, rightPin))
    }
    
    public func pinTopBottom(_ topPin: BoxLayout.Pin?, _ bottomPin: BoxLayout.Pin?) -> BoxItem {
        return Self.init(view: view, layout: layout.with(.top, topPin).with(.bottom, bottomPin))
    }
}


extension UIView {
    
    public func hv(_ h: BoxLayout.H, _ v: BoxLayout.V) -> BoxItem {
        return BoxItem(view: self, layout: .hv(h, v))
    }
    
    public func withLayout(_ layout: BoxLayout) -> BoxItem {
        return BoxItem(view: self, layout: layout)
    }
    
    public var withZeroLayout: BoxItem {
        return BoxItem(view: self, layout: .zero)
    }
    
    public func withEdgePins(_ pins: BoxLayout.EdgePins) -> BoxItem {
        return BoxItem(view: self, layout: .withEdgePins(pins))
    }
    
    public func pinLeft(_ leftPin: BoxLayout.Pin?) -> BoxItem {
        return BoxItem(view: self, layout: .hv(.pins(leftPin, 0.0), .zero))
    }
    
    public func pinRight(_ rightPin: BoxLayout.Pin?) -> BoxItem {
        return BoxItem(view: self, layout: .hv(.pins(0.0,rightPin), .zero))
    }
    
    public func pinLeftRight(_ leftPin: BoxLayout.Pin?, _ rightPin: BoxLayout.Pin?) -> BoxItem {
        return BoxItem(view: self, layout: .hv(.pins(leftPin, rightPin), .zero))
    }
    
    public func pinTop(_ topPin: BoxLayout.Pin?) -> BoxItem {
        return BoxItem(view: self, layout: .hv(.zero, .pins(topPin, 0.0)))
    }
    
    public func pinBottom(_ bottomPin: BoxLayout.Pin?) -> BoxItem {
        return BoxItem(view: self, layout: .hv(.zero, .pins(0.0, bottomPin)))
    }
    
    public func pinTopBottom(_ topPin: BoxLayout.Pin?, _ bottomPin: BoxLayout.Pin?) -> BoxItem {
        return BoxItem(view: self, layout: .hv(.zero, .pins(topPin, bottomPin)))
    }
    
    public func xAligned(offset: CGFloat = 0.0, padding: CGFloat? = 0.0) -> BoxItem {
        return BoxItem(view: self, layout: .hv(.align(offset: offset, padding: padding), .zero))
    }
    
    public func yAligned(offset: CGFloat = 0.0, padding: CGFloat? = 0.0) -> BoxItem {
        return BoxItem(view: self, layout: .hv(.zero, .align(offset: offset, padding: padding)))
    }


    public func withInsets(_ insets: UIEdgeInsets?) -> BoxItem {
        return BoxItem(view: self, layout: .hv(.lr(insets?.left, insets?.right), .tb(insets?.top, insets?.bottom)))
    }

}

extension Array where Element: UIView {
    
    public func hv(_ h: BoxLayout.H, _ v: BoxLayout.V) -> [BoxItem] {
        let layuot = BoxLayout.hv(h, v)
        return self.map{BoxItem(view: $0, layout: layuot)}
    }
    
    public func withLayout(_ layout: BoxLayout) -> [BoxItem] {
        return self.map{BoxItem(view: $0, layout: layout)}
    }
    
    public var withZeroLayout: [BoxItem] {
        return self.map{BoxItem(view: $0, layout: .zero)}
    }
    
    public func inBoxView(axis: BoxLayout.Axis = .y, spacing: CGFloat = 0.0, insets: UIEdgeInsets = .zero) -> BoxView {
        let boxView = BoxView(axis: axis, spacing: spacing, insets: insets)
        boxView.items = self.withZeroLayout
        return boxView
    }
    
}
