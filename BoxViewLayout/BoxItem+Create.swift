//
//  BoxItem+Ccreate.swift
//  BoxViewExample
//
//  Created by Vlad on 6/24/20.
//  Copyright © 2020 Vlad. All rights reserved.
//

import UIKit

extension BoxItem {

    // creates new BoxItem from existing, by setting left pin
    public func boxLeft(_ leftPin: BoxLayout.Pin?) -> BoxItem {
        return BoxItem(alObj: alObj, layout: layout.with(.left, leftPin))
    }
    
    // creates new BoxItem from existing, by setting left pin
    public func left(_ leftPin: BoxLayout.Pin?) -> BoxItem {
        return BoxItem(alObj: alObj, layout: layout.with(.left, leftPin))
    }
    
    // Creates new BoxItem from existing, by setting exact left padding.
    public func boxLeft(_ left: CGFloat) -> BoxItem {
        return BoxItem(alObj: alObj, layout: layout.with(.left, ==left))
    }
    
    // Creates new BoxItem from existing, by setting exact left padding.
    public func left(_ left: CGFloat) -> BoxItem {
        return BoxItem(alObj: alObj, layout: layout.with(.left, ==left))
    }
    
    // creates new BoxItem from existing, by setting right pin
    public func boxRight(_ rightPin: BoxLayout.Pin?) -> BoxItem {
        return BoxItem(alObj: alObj, layout: layout.with(.right, rightPin))
    }
    
    // creates new BoxItem from existing, by setting exact right padding
    public func boxRight(_ right: CGFloat) -> BoxItem {
        return BoxItem(alObj: alObj, layout: layout.with(.right, ==right))
    }

    // creates new BoxItem from existing, by setting right pin
    public func right(_ rightPin: BoxLayout.Pin?) -> BoxItem {
        return BoxItem(alObj: alObj, layout: layout.with(.right, rightPin))
    }

    // creates new BoxItem from existing, by setting exact right padding
    public func right(_ right: CGFloat) -> BoxItem {
        return BoxItem(alObj: alObj, layout: layout.with(.right, ==right))
    }
    
    // creates new BoxItem from existing, by setting left and right pins
    public func boxLeftRight(_ leftPin: BoxLayout.Pin?, _ rightPin: BoxLayout.Pin?) -> BoxItem {
        return BoxItem(alObj: alObj, layout: layout.with(.left, leftPin).with(.right, rightPin))
    }
    
    // creates new BoxItem from existing, by setting exact left and right paddings
    public func boxLeftRight(_ left: CGFloat, _ right: CGFloat) -> BoxItem {
        return BoxItem(alObj: alObj, layout: layout.with(.left, ==left).with(.right, ==right))
    }
    
    // creates new BoxItem from existing, by setting top pin
    public func boxTop(_ topPin: BoxLayout.Pin?) -> BoxItem {
        return BoxItem(alObj: alObj, layout: layout.with(.top, topPin))
    }
    
    // creates new BoxItem from existing, by setting exact top padding
    public func boxTop(_ top: CGFloat) -> BoxItem {
        return BoxItem(alObj: alObj, layout: layout.with(.top, ==top))
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
    public func boxBottom(_ bottomPin: BoxLayout.Pin?) -> BoxItem {
        return BoxItem(alObj: alObj, layout: layout.with(.bottom, bottomPin))
    }
    
    // creates new BoxItem from existing, by setting exact bottom padding
    public func boxBottom(_ bottom: CGFloat) -> BoxItem {
        return BoxItem(alObj: alObj, layout: layout.with(.bottom, ==bottom))
    }
    
    // creates new BoxItem from existing, by setting bottom pin
    public func bottom(_ bottomPin: BoxLayout.Pin?) -> BoxItem {
        return BoxItem(alObj: alObj, layout: layout.with(.bottom, bottomPin))
    }
    
    // creates new BoxItem from existing, by setting exact bottom padding
    public func bottom(_ bottom: CGFloat) -> BoxItem {
        return BoxItem(alObj: alObj, layout: layout.with(.bottom, ==bottom))
    }
    
    // creates new BoxItem from existing, by setting top and bottom pins
    public func boxTopBottom(_ topPin: BoxLayout.Pin?, _ bottomPin: BoxLayout.Pin?) -> BoxItem {
        return BoxItem(alObj: alObj, layout: layout.with(.top, topPin).with(.bottom, bottomPin))
    }
    
    // creates new BoxItem from existing, by setting exact top and bottom paddings
    public func boxTopBottom(_ top: CGFloat, _ bottom: CGFloat) -> BoxItem {
        return BoxItem(alObj: alObj, layout: layout.with(.top, ==top).with(.bottom, ==bottom))
    }
    
    // creates new BoxItem from existing, by adding alignment along X-axis
    public func boxCenterX(offset: CGFloat = 0.0, padding: CGFloat? = 0.0) -> BoxItem {
        let alignedItem =  BoxItem(alObj: alObj, layout: layout.with(.centerX, ==offset))
        if let padding = padding {
            let paddingPin = >=padding
            return alignedItem.boxLeftRight(paddingPin, paddingPin)
        }
        else {
            return alignedItem
        }
    }
    
    // creates new BoxItem from existing, by adding alignment along X-axis
    public func centerX(offset: CGFloat = 0.0, padding: CGFloat? = 0.0) -> BoxItem {
        let alignedItem =  BoxItem(alObj: alObj, layout: layout.with(.centerX, ==offset))
        if let padding = padding {
            let paddingPin = >=padding
            return alignedItem.boxLeftRight(paddingPin, paddingPin)
        }
        else {
            return alignedItem
        }
    }

    
    // creates new BoxItem from existing, by adding alignment along Y-axis
    public func boxCenterY(offset: CGFloat = 0.0, padding: CGFloat? = 0.0) -> BoxItem {
        let alignedItem =  BoxItem(alObj: alObj, layout: layout.with(.centerY, ==offset))
        if let padding = padding {
            let paddingPin = >=padding
            return alignedItem.boxTopBottom(paddingPin, paddingPin)
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
            return alignedItem.boxTopBottom(paddingPin, paddingPin)
        }
        else {
            return alignedItem
        }
    }
    
    func boxIf(_ value: Bool) -> BoxItem? {
        return value ? self : nil
    }
    
    static func boxGuide() -> BoxItem {
        return BoxItem(alObj: UILayoutGuide())
    }

    static func relativeWidth(_ value: CGFloat) -> BoxItem {
        BoxItem(alObj: UILayoutGuide(), layout: .withWidth(*value))
    }
    
    static func relativeHeight(_ value: CGFloat) -> BoxItem {
        BoxItem(alObj: UILayoutGuide(), layout: .withHeight(*value))
    }
    
    static func boxFlex(_ value: CGFloat) -> BoxItem {
        let bl = BoxLayout.zero
        return BoxItem(alObj: UILayoutGuide(), layout: bl.withFlex(value))
    }
    
    func boxFlex(_ value: CGFloat) -> BoxItem {
        BoxItem(alObj: self.alObj, layout: layout.withFlex(value))
    }
 
}
