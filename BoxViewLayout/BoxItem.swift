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
        return BoxItem(view: self, layout: .hv(.pins(leftPin, nil), .pins(nil, nil)))
    }
    
    public func pinLeftRight(_ leftPin: BoxLayout.Pin?, _ rightPin: BoxLayout.Pin?) -> BoxItem {
        return BoxItem(view: self, layout: .hv(.pins(leftPin, rightPin), .pins(nil, nil)))
    }

    public func withInsets(_ insets: UIEdgeInsets?) -> BoxItem {
        return BoxItem(view: self, layout: .hv(.lr(insets?.left, insets?.right), .tb(insets?.top, insets?.bottom)))
    }

}
