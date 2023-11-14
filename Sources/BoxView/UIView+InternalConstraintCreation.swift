//
//  UIView+boxConstraints.swift
//  BoxViewExample
//
//  Created by Vlad on 6/26/20.
//  Copyright © 2020 Vlad. All rights reserved.
//

import UIKit

// MARK: - Internal -

extension BoxAnchorable {

    func xBeginAnchor(sca: UISemanticContentAttribute) -> BoxAnchorPinnable {
        switch sca {
            case .unspecified: return leadingAnchor
            case .forceRightToLeft: return rightAnchor
            default: return leftAnchor
        }
    }
    
    func xEndAnchor(sca: UISemanticContentAttribute) -> BoxAnchorPinnable {
        switch sca {
            case .unspecified: return trailingAnchor
            case .forceRightToLeft: return leftAnchor
            default: return rightAnchor
        }
    }
    
    func beginAnchor(axis: BoxLayout.Axis) -> BoxAnchorPinnable {
        return (axis == .y) ? topAnchor : xBeginAnchor(sca: semanticContentAttribute)
    }
    
    func endAnchor(axis: BoxLayout.Axis) -> BoxAnchorPinnable {
        return (axis == .y) ? self.bottomAnchor : xEndAnchor(sca: semanticContentAttribute)
    }
    
    func centerAnchor(axis: BoxLayout.Axis) -> BoxAnchorPinnable {
        return (axis == .y) ? centerYAnchor : centerXAnchor
    }
    
    func beginForAxis(_ anAxis: BoxLayout.Axis, insets: UIEdgeInsets) -> CGFloat {
        return (anAxis == .y) ? insets.top : insets.left
    }
    
    func endForAxis(_ anAxis: BoxLayout.Axis, insets: UIEdgeInsets) -> CGFloat {
        return (anAxis == .y) ? insets.bottom : insets.right
    }

    func centerOffsetForAxis(_ anAxis: BoxLayout.Axis, insets: UIEdgeInsets) -> CGFloat {
        return 0.5 * ((anAxis == .y) ? insets.top - insets.bottom : (insets.left - insets.right))
    }
    
    func languageDirectionFactorForAxis(_ anAxis: BoxLayout.Axis) -> CGFloat {
        // It is just text direction factor,
        // so it is always negative for RTL either forced or defined by language
        let langDir = UIView.userInterfaceLayoutDirection(for: semanticContentAttribute)
        return (anAxis == .y || langDir == .leftToRight) ? 1.0 : -1.0
    }
    
    func layoutDirectionFactorForAxis(_ anAxis: BoxLayout.Axis) -> CGFloat {
        // It is negative only for .forceRightToLeft case.
        // For .unspecified it is positive as direction is handled by leading/trailing anchors.
        return (anAxis == .y || semanticContentAttribute != .forceRightToLeft) ? 1.0 : -1.0
    }
    
    func createChainConstraints(boxItems: [BoxItem], axis: BoxLayout.Axis, spacing: CGFloat, insets: UIEdgeInsets?, constraints: inout [NSLayoutConstraint]) {
        let insets = insets ?? .zero
        var prevItem: BoxItem? = nil
        guard boxItems.count > 0 else { return }
        let factor = layoutDirectionFactorForAxis(axis)
        let sca = semanticContentAttribute
        for item in boxItems {
            let layout = item.layout
            if let itemBeginPin = layout.begin(axis),
               let itemBeginAnchor = item.beginAnchor(axis: axis, sca: sca) {
                if let prevItem = prevItem {
                    if let prevEndAnchor = prevItem.endAnchor(axis: axis, sca: sca),
                        let prevEndPin = prevItem.layout.pinForAxis(axis, position: .end) {
                        guard let sumPin = (itemBeginPin + prevEndPin)?.withInset(spacing, factor: factor) else {
                            BoxLayout.Pin.sumPinWarning(); return
                        }
                        let toPrev = itemBeginAnchor.pin(sumPin, to: prevEndAnchor)
                        constraints.append(toPrev)
                    }
                }
                else{
                    let firstPin = itemBeginPin.withInset(beginForAxis(axis, insets: insets), factor: factor)
                    let toBegin = itemBeginAnchor.pin(firstPin, to: beginAnchor(axis: axis))
                    constraints.append(toBegin)
                }
            }
            if let itemCenterPin = layout.center(axis) {
                let factor = languageDirectionFactorForAxis(axis)
                let insetPin = itemCenterPin.withInset(insetForAxis(axis, position: .center, insets: insets), factor : factor)
                let edge = axis.edgeForPosition(.center)
                let constr = item.alObj.pin(edge, of: self, pin: insetPin, sca: sca)
                constraints.append(constr)
            }
            pinAccross(boxItem: item, axis: axis, insets: insets, constraints: &constraints)
            prevItem = item
        }
        if let itemEndPin = prevItem?.layout.end(axis),
           let prevEndAnchor = prevItem?.endAnchor(axis: axis, sca: sca) {
            let lastPin = itemEndPin.withInset(endForAxis(axis, insets: insets), factor: factor)
            let toEnd = endAnchor(axis: axis).pin(lastPin, to: prevEndAnchor)
            constraints.append(toEnd)
        }

    }

}

extension BoxAnchorable {
    
    func anchorForEdge(_ edge: BoxEdge, sca: UISemanticContentAttribute) -> BoxAnchorPinnable {
        switch edge {
            case .left: return xBeginAnchor(sca: sca)
            case .right: return xEndAnchor(sca: sca)
            case .centerX: return centerXAnchor
            case .top: return topAnchor
            case .bottom: return bottomAnchor
            case .centerY: return centerYAnchor
        }
    }
    
    public func pinSameEdge(_ edge: BoxEdge, to obj: BoxAnchorable, pin: BoxLayout.Pin, sca: UISemanticContentAttribute) -> NSLayoutConstraint {
        let constr: NSLayoutConstraint
        let ownAnchor = anchorForEdge(edge, sca: sca)
        let objAnchor = obj.anchorForEdge(edge, sca: sca)
        constr = ownAnchor.pin(pin, to: objAnchor)
        if pin.priority != .required {
            constr.priority = pin.priority
        }
        return constr
    }
    
    
    func insetForAxis(_ anAxis: BoxLayout.Axis, position: BoxEdge.Position, insets: UIEdgeInsets)  -> CGFloat {
        switch position {
            case .begin: return beginForAxis(anAxis, insets: insets)
            case .center: return centerOffsetForAxis(anAxis, insets: insets)
            case .end: return endForAxis(anAxis, insets: insets)
        }
    }
    
    func pinAccross(boxItem: BoxItem, axis: BoxLayout.Axis, insets: UIEdgeInsets, constraints: inout [NSLayoutConstraint]) {
        let alObj = boxItem.alObj
        let otherAxis = axis.other
        let layout = boxItem.layout
        for pos: BoxEdge.Position in [.begin, .center, .end] {
            if let pin = layout.pinForAxis(otherAxis, position: pos) {
                let edge = otherAxis.edgeForPosition(pos)
                let factor = (pos == .center) ? languageDirectionFactorForAxis(otherAxis) : layoutDirectionFactorForAxis(otherAxis)
                let insetPin = pin.withInset(insetForAxis(otherAxis, position: pos, insets: insets), factor: (pos == .end) ? -factor : factor)
                let constr = alObj.pinSameEdge(edge, to: self , pin: insetPin, sca: semanticContentAttribute)
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
    
}

extension Array where Element == BoxItem {
    
    func createDimensions(constraints: inout [NSLayoutConstraint]) {
        for item in self {
            if let heightPin = item.layout.height {
                constraints.append(item.alObj.heightAnchor.pin(heightPin))
            }
            if let widthPin = item.layout.width {
                constraints.append(item.alObj.widthAnchor.pin(widthPin))
            }
        }
    }
    
}

extension UILayoutGuide {
    
    public var semanticContentAttribute: UISemanticContentAttribute {
        owningView?.semanticContentAttribute ?? .unspecified
    }
    
}

