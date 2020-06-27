//
//  BoxItem+Ccreate.swift
//  BoxViewExample
//
//  Created by Vlad on 6/24/20.
//  Copyright © 2020 Vlad. All rights reserved.
//

import UIKit

extension BoxItem {
    
    // Creates new BoxItem from existing, by setting exact left padding.
    public func left(_ left: CGFloat) -> BoxItem {
        return BoxItem(alObj: alObj, layout: layout.with(.left, ==left))
    }
    
    // Creates new BoxItem from existing, by setting left pin
    public func left(_ leftPin: BoxLayout.Pin?) -> BoxItem {
        return BoxItem(alObj: alObj, layout: layout.with(.left, leftPin))
    }

    // creates new BoxItem from existing, by setting right pin
    public func right(_ rightPin: BoxLayout.Pin?) -> BoxItem {
        return BoxItem(alObj: alObj, layout: layout.with(.right, rightPin))
    }

    // creates new BoxItem from existing, by setting exact right padding
    public func right(_ right: CGFloat) -> BoxItem {
        return BoxItem(alObj: alObj, layout: layout.with(.right, ==right))
    }
    
    // creates new BoxItem from existing, by setting top pin
    public func top(_ topPin: BoxLayout.Pin?) -> BoxItem {
        return BoxItem(alObj: alObj, layout: layout.with(.top, topPin))
    }
    
    // creates new BoxItem from existing, by setting exact top padding
    public func top(_ top: CGFloat) -> BoxItem {
        return BoxItem(alObj: alObj, layout: layout.with(.top, ==top))
    }
    
    // creates new BoxItem from existing, by setting bottom pin
    public func bottom(_ bottomPin: BoxLayout.Pin?) -> BoxItem {
        return BoxItem(alObj: alObj, layout: layout.with(.bottom, bottomPin))
    }
    
    // creates new BoxItem from existing, by setting exact bottom padding
    public func bottom(_ bottom: CGFloat) -> BoxItem {
        return BoxItem(alObj: alObj, layout: layout.with(.bottom, ==bottom))
    }
    
    // creates new BoxItem from existing, by setting all paddings to same value
    public func all(_ value: CGFloat) -> BoxItem {
        let pin = ==value
        return BoxItem(alObj: alObj, layout: layout.withPins(top: pin, left: pin, bottom: pin, right: pin))
    }
    
    // creates new BoxItem from existing, by setting left and right paddings to same value
    public func allX(_ value: CGFloat) -> BoxItem {
        let pin = ==value
        var newLayout = layout
        newLayout.left = pin
        newLayout.right = pin
        return BoxItem(alObj: alObj, layout: newLayout)
    }
    
    // creates new BoxItem from existing, by setting top and bottom paddings to same value
    public func allY(_ value: CGFloat) -> BoxItem {
        let pin = ==value
        var newLayout = layout
        newLayout.top = pin
        newLayout.bottom = pin
        return BoxItem(alObj: alObj, layout: newLayout)
    }
    
    // creates new BoxItem from existing, by setting 4 edge values from insets
    public func insets(_ insets: UIEdgeInsets) -> BoxItem {
        return BoxItem(alObj: alObj, layout: layout.withPins(top: ==insets.top, left: ==insets.left, bottom: ==insets.bottom, right: ==insets.right))
    }

    // creates new BoxItem from existing, by adding alignment along X-axis
    public func centerX(offset: CGFloat = 0.0, padding: CGFloat? = 0.0) -> BoxItem {
        let alignedItem =  BoxItem(alObj: alObj, layout: layout.with(.centerX, ==offset))
        if let padding = padding {
            let paddingPin = >=padding
            return alignedItem.left(paddingPin).right(paddingPin)
        }
        else {
            return alignedItem
        }
    }
    
    // creates new BoxItem from existing, by adding alignment along Y-axis
    public func centerY(offset: CGFloat = 0.0, padding: CGFloat? = 0.0) -> BoxItem {
        let alignedItem =  BoxItem(alObj: alObj, layout: layout.with(.centerY, ==offset))
        if let padding = padding {
            let paddingPin = >=padding
            return alignedItem.top(paddingPin).bottom(paddingPin)
        }
        else {
            return alignedItem
        }
    }
    
    // returns nil from existing item if condition is false
    public func useIf(_ condition: Bool) -> BoxItem? {
        return condition ? self : nil
    }
    
    // returns new guide item
    public static func guide() -> BoxItem {
        return BoxItem(alObj: UILayoutGuide())
    }
    
    // returns new guide item with specified width pin
    public static func width(_ widthPin: BoxLayout.Pin) -> BoxItem {
        BoxItem(alObj: UILayoutGuide(), layout: BoxLayout().withWidth(widthPin))
    }
    
    // returns new guide item with specified width
    public static func width(_ value: CGFloat) -> BoxItem {
        BoxItem(alObj: UILayoutGuide(), layout: BoxLayout().withWidth(==value))
    }
    
    // creates new BoxItem from existing, by setting specified width pin
    public func width(_ widthPin: BoxLayout.Pin) -> BoxItem {
        BoxItem(alObj: alObj, layout: layout.withWidth(widthPin))
    }
    
    // creates new BoxItem from existing, by setting specified width
    public func width(_ value: CGFloat) -> BoxItem {
        BoxItem(alObj: self.alObj, layout: layout.withWidth(==value))
    }
    
    // creates new guide item with specified width relative to own width
    public static func relativeWidth(_ value: CGFloat) -> BoxItem {
        BoxItem(alObj: UILayoutGuide(), layout: BoxLayout().withRelativeWidth(*value))
    }
    
    // creates new guide item with specified width pin relative to own width
    public static func relativeWidth(_ widthPin: BoxLayout.MultiPin) -> BoxItem {
        BoxItem(alObj: UILayoutGuide(), layout: BoxLayout().withRelativeWidth(widthPin))
    }
    
    // creates new BoxItem from existing, by setting specified width relative to own width
    public func relativeWidth(_ value: CGFloat) -> BoxItem {
        BoxItem(alObj: alObj, layout: layout.withRelativeWidth(*value))
    }
    
    // creates new BoxItem from existing, by setting specified width pin relative to own width
    public func relativeWidth(_ widthPin: BoxLayout.MultiPin) -> BoxItem {
        BoxItem(alObj: alObj, layout: layout.withRelativeWidth(widthPin))
    }
    
    // returns new guide item with specified height pin
    public static func height(_ heightPin: BoxLayout.Pin) -> BoxItem {
        BoxItem(alObj: UILayoutGuide(), layout: BoxLayout().withHeight(heightPin))
    }
    
    // returns new guide item with specified height
    public static func height(_ value: CGFloat) -> BoxItem {
        BoxItem(alObj: UILayoutGuide(), layout: BoxLayout().withHeight(==value))
    }
    
    // creates new BoxItem from existing, by setting specified height pin
    public func height(_ heightPin: BoxLayout.Pin) -> BoxItem {
        BoxItem(alObj: alObj, layout: layout.withHeight(heightPin))
    }
    
    // creates new BoxItem from existing, by setting specified height
    public func height(_ value: CGFloat) -> BoxItem {
        BoxItem(alObj: self.alObj, layout: layout.withHeight(==value))
    }
    
    // creates new guide item with specified height relative to own height
    public static func relativeHeight(_ value: CGFloat) -> BoxItem {
        BoxItem(alObj: UILayoutGuide(), layout: BoxLayout().withRelativeHeight(*value))
    }
    
    // creates new guide item with specified height pin relative to own height
    public static func relativeHeight(_ heightPin: BoxLayout.MultiPin) -> BoxItem {
        BoxItem(alObj: UILayoutGuide(), layout: BoxLayout().withRelativeHeight(heightPin))
    }
    
    // creates new BoxItem from existing, by setting specified height pin relative to own height
    public func relativeHeight(_ heightPin: BoxLayout.MultiPin) -> BoxItem {
        BoxItem(alObj: alObj, layout: layout.withRelativeHeight(heightPin))
    }
    
    // creates new BoxItem from existing, by setting specified height relative to own height
    public func relativeHeight(_ value: CGFloat) -> BoxItem {
        BoxItem(alObj: alObj, layout: layout.withRelativeHeight(*value))
    }
    
    // returns new guide flex item
    public static func flex(_ value: CGFloat) -> BoxItem {
        let bl = BoxLayout.zero
        return BoxItem(alObj: UILayoutGuide(), layout: bl.withFlex(value))
    }
    
    // creates new BoxItem from existing, by setting flex value
    public func flex(_ value: CGFloat) -> BoxItem {
        BoxItem(alObj: self.alObj, layout: layout.withFlex(value))
    }
 
}
