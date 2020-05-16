//
//  BoxView.swift
//  BoxView
//
//  Created by Vlad on 4/2/20.
//  Copyright © 2020 Vladimir Dudkin. All rights reserved.
//

import UIKit

public class BoxView: UIView {
    
    public init(axis: BoxLayout.Axis = .vertical) {
        self.axis = axis
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public var items:[BoxItem] = [] {
        didSet {
            updateItems()
        }
    }
    
    public var axis: BoxLayout.Axis = .vertical {
        didSet {
            setNeedsUpdateConstraints()
        }
    }
    
    public var insets = UIEdgeInsets.zero {
        didSet {
            setNeedsUpdateConstraints()
        }
    }
    
    public var spacing: CGFloat = 0.0 {
        didSet {
            setNeedsUpdateConstraints()
        }
    }
    
    public private(set) var managedConstraints = [NSLayoutConstraint]()
    public private(set) var itemsEdgeConstraints = [BoxEdge.Constraints]()
    
    public func setViews(_ views: [UIView], layout: BoxLayout = .zero) {
        items = [BoxItem]()
        for view in views {
            items.append(view.withLayout(layout))
        }
    }
    
    public func setLayout(_ layout: BoxLayout, for view: UIView?) {
        if let index = items.firstIndex(where: { $0.view == view}) {
            items[index].layout = layout
            setNeedsUpdateConstraints()
        }
    }
    
    public func animateChangesWithDurations(_ duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.superview?.layoutIfNeeded()
        }
    }

    override public func updateConstraints() {
        self.removeConstraints(managedConstraints)
        managedConstraints = []
        itemsEdgeConstraints = []
        addItemsConstraints()
        super.updateConstraints()
    }

    
    // MARK: - Private
    
    private func updateItems() {
        let itemViews = items.map { $0.view }
        var toRemove = [UIView]()
        for subView in subviews {
            if !itemViews.contains(subView) {
                toRemove.append(subView)
            }
        }
        for subView in toRemove {
            subView.removeFromSuperview()
        }
        for view in itemViews {
            if !subviews.contains(view) {
                addSubview(view)
            }
        }
        setNeedsUpdateConstraints()
    }
    
    func addItemsConstraints() {
        var prevItem: BoxItem? = nil
        guard items.count > 0 else { return }
        var beginAttr: NSLayoutConstraint.Attribute!
        var endAttr: NSLayoutConstraint.Attribute!
        var edgeConstraints: BoxEdge.Constraints = [:]
        for item in items {
            let view = item.view
            let layout = item.layout
            
            if beginAttr == nil {
                beginAttr = attributeForEdge(axis.beginEdge)
                endAttr = attributeForEdge(axis.endEdge)
            }
            if let prevItem = prevItem {
                guard let itemBegin = layout.begin(axis), let itemEnd = prevItem.layout.end(axis) else {
                    axisWarning(); return
                }
                guard let sumPin = itemBegin + itemEnd else {
                    sumPinWarning(); return
                }
                let toPrev = view.alPin(beginAttr, to: endAttr, of: prevItem.view, constant: sumPin.value + spacing, relation: sumPin.relation)
                managedConstraints.append(toPrev)
                edgeConstraints[endAttr.edge!] = toPrev
                itemsEdgeConstraints.append(edgeConstraints)
                edgeConstraints = [beginAttr.edge!: toPrev]
            }
            else{
                guard let itemBegin = layout.begin(axis) else {
                    axisWarning(); return
                }
                let toBegin = view.alPin(beginAttr, to: beginAttr, of: self, constant: itemBegin.value + begin, relation: itemBegin.relation)
                managedConstraints.append(toBegin)
                edgeConstraints = [beginAttr.edge!: toBegin]
            }
            pinAccross(view: view, layout: layout, edgeConstraints: &edgeConstraints)
            prevItem = item
        }
        guard let itemEnd = prevItem?.layout.end(axis) else {
            axisWarning(); return
        }
        let toEnd = self.alPin(endAttr, to: endAttr, of: prevItem!.view, constant: itemEnd.value + end, relation: itemEnd.relation)
        managedConstraints.append(toEnd)
        edgeConstraints[endAttr.edge!] = toEnd
        itemsEdgeConstraints.append(edgeConstraints)
    }

    
    private var begin: CGFloat {
        return (axis == .vertical) ? insets.top : insets.left
    }
    
    private var end: CGFloat {
        return (axis == .vertical) ? insets.bottom : insets.right
    }
    
    private func axisWarning() {
        if axis == .vertical {
            assertionFailure("CPBoxView items for verical direction must have top and bottom insets")
        }
        else {
            assertionFailure("CPBoxView items for horizontal direction must have left and right insets")
        }
    }
    private func sumPinWarning() {
        assertionFailure("Joining constraints relations must be either same or one of them must be NSLayoutConstraint.Relation.equal")
    }
    
    private func pinAccross(view: UIView, layout: BoxLayout, edgeConstraints: inout BoxEdge.Constraints) {
        let otherAxis = axis.other
        for pos: BoxEdge.Position in [.begin, .center, .end] {
            if let pin = layout.pinForAxis(otherAxis, position: pos) {
                let edge = otherAxis.edgeForPosition(pos)
                let attr = attributeForEdge(edge)
                let constr: NSLayoutConstraint
                if (pos == .end) {
                    constr = self.alPin(attr, to: attr, of: view, constant: pin.value + insets.insetForAxis(otherAxis, position: pos), relation: pin.relation)
                }
                else {
                    constr = view.alPin(attr, to: attr, of: self, constant: pin.value + insets.insetForAxis(otherAxis, position: pos), relation: pin.relation)
                }
                managedConstraints.append(constr)
                edgeConstraints[edge] = constr
            }
        }
    }
    func attributeForEdge(_ edge: BoxEdge) -> NSLayoutConstraint.Attribute {
            switch edge {
//                case .left: {
//                        return .left
////                    switch h.semanticDirection {
//    //                case .system: return .leading
//    //                case .fixedLTR: return .left
//    //                case .fixedRTL: return .right
//    //            }
//                }
                case .left: return .left
                case .right: return .right
                case .top: return .top
                case .bottom: return .bottom
                case .centerX: return .centerX
                case .centerY: return .centerY
            }
        }
    
//    func beginEdgeForAxis(_ axis: Axis) -> NSLayoutConstraint.Attribute {
//        if axis == .vertical {
//            return .top
//        }
//        else {
//            switch h.semanticDirection {
//                case .system: return .leading
//                case .fixedLTR: return .left
//                case .fixedRTL: return .right
//            }
//        }
//    }
//
//    func endAttributeForAxis(_ axis: Axis) -> NSLayoutConstraint.Attribute {
//        if axis == .vertical {
//            return .bottom
//        }
//        else {
//            switch h.semanticDirection {
//                case .system: return .trailing
//                case .fixedLTR: return .right
//                case .fixedRTL: return .left
//            }
//        }
//    }
//
//    func centerAttributeForAxis(_ axis: Axis) -> NSLayoutConstraint.Attribute {
//        return (axis == .vertical) ? .centerY : .centerX
//    }
    
//    func centerOffsetFactorForAxis(_ axis: Axis) -> CGFloat {
//        if axis == .vertical {
//            return 1.0
//        }
//        else {
//            switch h.semanticDirection {
//                case .system: return BoxLayout.systemDirectionFactor
//                case .fixedLTR: return 1.0
//                case .fixedRTL: return 1.0
//            }
//        }
//    }
}









