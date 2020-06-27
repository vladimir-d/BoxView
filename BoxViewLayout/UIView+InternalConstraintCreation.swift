//
//  UIView+boxConstraints.swift
//  BoxViewExample
//
//  Created by Vlad on 6/26/20.
//  Copyright © 2020 Vlad. All rights reserved.
//

import UIKit


extension UIView {

    var isRTLDependent: Bool {
        return semanticContentAttribute == .unspecified
    }
    
    func beginAnchor(axis: BoxLayout.Axis) -> BoxAnchorPinnable {
        return (axis == .y) ? topAnchor : ((isRTLDependent) ? leadingAnchor : leftAnchor)
    }
    
    func endAnchor(axis: BoxLayout.Axis) -> BoxAnchorPinnable {
        return (axis == .y) ? self.bottomAnchor : ((isRTLDependent) ? trailingAnchor : rightAnchor)
    }
    
    func centerAnchor(axis: BoxLayout.Axis) -> BoxAnchorPinnable {
        return (axis == .y) ? centerYAnchor : centerXAnchor
    }
    
    func beginForAxis(_ anAxis: BoxLayout.Axis) -> CGFloat {
        return (anAxis == .y) ? layoutMargins.top : layoutMargins.left
    }
    
    func endForAxis(_ anAxis: BoxLayout.Axis) -> CGFloat {
        return (anAxis == .y) ? layoutMargins.bottom : layoutMargins.right
    }

    func centerOffsetForAxis(_ anAxis: BoxLayout.Axis) -> CGFloat {
        return 0.5 * ((anAxis == .y) ? layoutMargins.top - layoutMargins.bottom : (layoutMargins.left - layoutMargins.right) * offsetFactorForAxis(anAxis))
    }
    
    func offsetFactorForAxis(_ anAxis: BoxLayout.Axis) -> CGFloat {
        let langDir = UIView.userInterfaceLayoutDirection(for: semanticContentAttribute)
        return (anAxis == .y || langDir == .leftToRight || !isRTLDependent) ? 1.0 : -1.0
    }
    
    func insetForAxis(_ anAxis: BoxLayout.Axis, position: BoxEdge.Position)  -> CGFloat {
        switch position {
            case .begin: return beginForAxis(anAxis)
            case .center: return centerOffsetForAxis(anAxis)
            case .end: return endForAxis(anAxis)
        }
    }
    
    func attributeForEdge(_ edge: BoxEdge) -> NSLayoutConstraint.Attribute {
        switch edge {
            case .left: return (isRTLDependent) ? .leading : .left
            case .right: return (isRTLDependent) ? .trailing : .right
            case .top: return .top
            case .bottom: return .bottom
            case .centerX: return .centerX
            case .centerY: return .centerY
        }
    }
    
    func createChainConstraints(boxItems: [BoxItem], axis: BoxLayout.Axis, spacing: CGFloat, constraints: inout [NSLayoutConstraint]) {
        var prevItem: BoxItem? = nil
        guard boxItems.count > 0 else { return }
        for item in boxItems {
            let layout = item.layout
            if let itemBeginPin = layout.begin(axis),
               let itemBeginAnchor = item.beginAnchor(axis: axis, isRTLDependent: isRTLDependent) {
                if let prevItem = prevItem {
                    if let prevEndAnchor = prevItem.endAnchor(axis: axis, isRTLDependent: isRTLDependent),
                        let prevEndPin = prevItem.layout.pinForAxis(axis, position: .end) {
                        guard let sumPin = itemBeginPin + prevEndPin + spacing else {
                            BoxLayout.Pin.sumPinWarning(); return
                        }
                        let toPrev = itemBeginAnchor.pin(sumPin, to: prevEndAnchor)
                        constraints.append(toPrev)
                    }
                }
                else{
                    let firstPin = itemBeginPin + beginForAxis(axis)
                    let toBegin = itemBeginAnchor.pin(firstPin, to: beginAnchor(axis: axis))
                    constraints.append(toBegin)
                }
            }
            if let itemCenterPin = layout.center(axis),
                let itemCenterAnchor = item.centerAnchor(axis: axis)
                {
                let toCenter = itemCenterAnchor.pin(itemCenterPin, to: centerAnchor(axis: axis))
                constraints.append(toCenter)
            }
            pinAccross(boxItem: item, axis: axis, constraints: &constraints)
            prevItem = item
        }
        if let itemEndPin = prevItem?.layout.end(axis),
            let prevEndAnchor = prevItem?.endAnchor(axis: axis, isRTLDependent: isRTLDependent) {
            let lastPin = itemEndPin + endForAxis(axis)
            let toEnd = endAnchor(axis: axis).pin(lastPin, to: prevEndAnchor)
            constraints.append(toEnd)
        }

    }
    
    func pinAccross(boxItem: BoxItem, axis: BoxLayout.Axis, constraints: inout [NSLayoutConstraint]) {
        guard let view = boxItem.view else { return }
        let otherAxis = axis.other
        let layout = boxItem.layout
        for pos: BoxEdge.Position in [.begin, .center, .end] {
            if let pin = layout.pinForAxis(otherAxis, position: pos) {
                let edge = otherAxis.edgeForPosition(pos)
                let attr = attributeForEdge(edge)
                let constr: NSLayoutConstraint
                if (pos == .end) {
                    let insetPin = pin + insetForAxis(otherAxis, position: pos)
                    constr = self.bxPin(attr, to: attr, of: view, pin: insetPin, activate: false)
                }
                else {
                    var factor: CGFloat = 1.0
                    if pos == .center {
                        factor = offsetFactorForAxis(otherAxis)
                    }
                    var insetPin = pin
                    insetPin.constant = insetPin.constant * factor + insetForAxis(otherAxis, position: pos)
                    constr = view.bxPin(attr, to: attr, of: self, pin: insetPin, activate: false)
                }
                constraints.append(constr)
            }
        }
    }
    
    func createFlexDimentions(boxItems: [BoxItem], axis: BoxLayout.Axis, constraints: inout [NSLayoutConstraint]) {
            var firstFlexAnchor: NSLayoutDimension?
            var firstFlex: CGFloat = 0.0
            for item in boxItems {
                if let flex = item.layout.flex, flex > 0.0 {
                    let itemAnchor = (axis == .y) ? item.alObj.heightAnchor : item.alObj.widthAnchor
                    if let firstAnchor = firstFlexAnchor {
                        constraints.append(itemAnchor.constraint(equalTo: firstAnchor, multiplier: flex / firstFlex))
                    }
                    else {
                        firstFlexAnchor = itemAnchor
                        firstFlex = flex
                    }
                }
            }
        }
    
    func createRelativeDimensions(boxItems: [BoxItem], constraints: inout [NSLayoutConstraint]) {
        let ownHeightAnchor = self.heightAnchor
        let ownWidthAnchor = self.widthAnchor
        for item in boxItems {
            if let heightPin = item.layout.relativeHeight {
                constraints.append(item.alObj.heightAnchor.pin(heightPin, to: ownHeightAnchor))
            }
            if let widthPin = item.layout.relativeWidth {
                constraints.append(item.alObj.widthAnchor.pin(widthPin, to: ownWidthAnchor))
            }
        }
    }
    
    
    func createDimentions(boxItems: [BoxItem], constraints: inout [NSLayoutConstraint]) {
        for item in boxItems {
            if let heightPin = item.layout.height {
                constraints.append(item.alObj.heightAnchor.pin(heightPin))
            }
            if let widthPin = item.layout.width {
                constraints.append(item.alObj.widthAnchor.pin(widthPin))
            }
        }
    }
    
}
