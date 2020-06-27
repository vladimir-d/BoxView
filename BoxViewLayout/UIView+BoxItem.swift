//
//  BoxItem+UIView.swift
//  BoxViewExample
//
//  Created by Vlad on 6/24/20.
//  Copyright © 2020 Vlad. All rights reserved.
//

import UIKit

extension UIView {
    
    // Creates BoxItem with view and zero constant constraints to all four edges.
    public var boxed: BoxItem {
        return BoxItem(view: self, layout: .zero)
    }
    
    // Creates BoxItem from view using specified layout
    public func boxed(layout: BoxLayout) -> BoxItem {
        return BoxItem(view: self, layout: layout)
    }

    // adding item view as subview with layuot specified by item
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
    
    // adding items views as subviews with layuot specified by items
    // it allows to add BoxItems to any view in same manner as setting boxView.items
    // this method is used to layout subviews in some specific view (e.g UIScrollView or view of controller) which can't be BoxView.
    // all constraints created in this method are returned as result
    // and can be stored somewhere to manage them later.
    @discardableResult
    public func addBoxItems(_ items: [BoxItem], axis: BoxLayout.Axis = .y, spacing: CGFloat = 0.0) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        items.forEach{
            if let view = $0.view {
                self.addSubview(view)
                view.translatesAutoresizingMaskIntoConstraints = false
            }
        }
        createChainConstraints(boxItems: items, axis: axis, spacing: spacing, constraints: &constraints)
        createDimentions(boxItems: items, constraints: &constraints)
        createRelativeDimensions(boxItems: items, constraints: &constraints)
        createFlexDimentions(boxItems: items, axis: axis, constraints: &constraints)
        NSLayoutConstraint.activate(constraints)
        return constraints
    }


}

extension Array where Element: UIView {
    
    // Creates BoxItems array from array of views using specified layout for all views.
    public func boxed(layout: BoxLayout) -> [BoxItem] {
        return map{BoxItem(view: $0, layout: layout)}
    }
    
    // Creates BoxItems array from array of views using same "zero" layout (zero constant constraints to all four edges) for all views.
    public var boxed: [BoxItem] {
        return map{BoxItem(view: $0, layout: .zero)}
    }
    
    
    public func inBoxView(axis: BoxLayout.Axis = .y, spacing: CGFloat = 0.0, insets: UIEdgeInsets = .zero) -> BoxView {
        let boxView = BoxView(axis: axis, spacing: spacing, insets: insets)
        boxView.items = self.boxed
        return boxView
    }
    
}
