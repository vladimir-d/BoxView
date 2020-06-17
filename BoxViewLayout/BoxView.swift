//
//  BoxView.swift
//  BoxView
//
//  Created by Vlad on 4/2/20.
//  Copyright © 2020 Vladimir Dudkin. All rights reserved.
//

import UIKit

@IBDesignable
open class BoxView: UIView {
    
    // MARK: - Public
    
    public init(axis: BoxLayout.Axis = .y, spacing: CGFloat = 0.0, insets: UIEdgeInsets = .zero) {
        self.axis = axis
        self.spacing = spacing
        self.insets = insets
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setup()
    }
    
    public required override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open func setup() {
        // to override in subclasses
    }
    
    // array of all automatically created by BoxView constraints
    public private(set) var managedConstraints = [NSLayoutConstraint]()
    
    // array of automatically created by BoxView constraints groupped in dictionary for each item
    public private(set) var itemsEdgeConstraints = [BoxEdge.Constraints]()
    
    // array of views of all items.
    // it is a subset of boxView.subviews
    public private(set) var managedViews = [UIView]()
    
    public var items:[BoxItem] = [] {
        didSet {
            updateItems()
        }
    }
    
    // main axis along which item views are stacked.
    // X is horizontal and Y is vertical.
    public var axis: BoxLayout.Axis = .y {
        didSet {
            setNeedsUpdateConstraints()
        }
    }
    
    // Additional isets from boxView edges. They are added to corresponding view constraints.
    @IBInspectable
    public var insets = UIEdgeInsets.zero {
        didSet {
            setNeedsUpdateConstraints()
        }
    }
    
    // Default spacing between item views. Actual spacing between every two items is:
    // end pin of first view + spacing + begin pin of second view
    @IBInspectable
    public var spacing: CGFloat = 0.0 {
        didSet {
            setNeedsUpdateConstraints()
        }
    }
    
    // setting items from array of views using same layout
    public func setViews(_ views: [UIView], layout: BoxLayout = .zero) {
        items = [BoxItem]()
        for view in views {
            items.append(view.boxLayout(layout))
        }
    }
    
    // appending item
    public func addItem(_ item: BoxItem) {
        items.append(item)
    }
    
    // inserting item after item with given view, if view is nil, then item inserted at index 0
    public func insertItem(_ item: BoxItem, after view: UIView?) {
        if managedViews.contains(item.view) {
            item.view.removeFromSuperview()
        }
        if view == nil {
            items.insert(item, at: 0)
        }
        else if let index = items.firstIndex(where: {$0.view == view}) {
            items.insert(item, at: index + 1)
        }
    }
    
    // changing layout of existing item with specified view
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

    // When items are assigned or parameters affecting layout are changed,
    // constraints are not changed immediatly. Only setNeedsUpdateConstraints() called.
    // Then updateConstraints() method is called automatically when boxView laying out own subviews.
    // You can call this method to force create constraints immediatly.
    override public func updateConstraints() {
        self.removeConstraints(managedConstraints)
        managedConstraints = []
        itemsEdgeConstraints = []
        addItemsConstraints()
        super.updateConstraints()
    }
    
    override public func willRemoveSubview(_ subview: UIView) {
        superview?.willRemoveSubview(subview)
        if !isUpdatingItems {
            if managedViews.contains(subview) {
                if let index = items.firstIndex(where: { $0.view == subview}) {
                    items.remove(at: index)
                }
            }
        }
    }
    
    
    // MARK: - Private
    
    private func updateItems() {
        isUpdatingItems = true
        let itemViews = items.map { $0.view }
        var toRemove = [Int]()
        for (index, managedView) in managedViews.enumerated() {
            if !itemViews.contains(managedView) {
                toRemove.append(index)
                managedView.removeFromSuperview()
            }
        }
        for index in toRemove.reversed() {
            managedViews.remove(at: index)
        }
        for view in itemViews {
            if !managedViews.contains(view) {
                view.translatesAutoresizingMaskIntoConstraints = false
                managedViews.append(view)
                addSubview(view)
            }
            else {
                bringSubviewToFront(view)
            }
        }
        isUpdatingItems = false
        
        setNeedsUpdateConstraints()
    }
    
    func addItemsConstraints() {
        var prevItem: BoxItem? = nil
        guard items.count > 0 else { return }
        let beginEdge = axis.edgeForPosition(.begin)
        let endEdge = axis.edgeForPosition(.end)
        let centerEdge = axis.edgeForPosition(.center)
        let beginAttr = attributeForEdge(beginEdge)
        let endAttr = attributeForEdge(endEdge)
        let centerAttr = attributeForEdge(centerEdge)
        var edgeConstraints: BoxEdge.Constraints = [:]
        for item in items {
            let view = item.view
            let layout = item.layout
            if let itemBegin = layout.begin(axis) {
                if let prevItem = prevItem {
                    if let prevEnd = prevItem.layout.end(axis) {
                        guard let sumPin = itemBegin + prevEnd else {
                            sumPinWarning(); return
                        }
                        let toPrev = view.alPin(beginAttr, to: endAttr, of: prevItem.view, constant: sumPin.value + spacing, relation: sumPin.relation, activate: false)
                        managedConstraints.append(toPrev)
                        edgeConstraints[endEdge] = toPrev
                        itemsEdgeConstraints.append(edgeConstraints)
                        edgeConstraints = [beginEdge: toPrev]
                    }
                }
                else{
                    let toBegin = view.alPin(beginAttr, to: beginAttr, of: self, constant: itemBegin.value + begin, relation: itemBegin.relation, activate: false)
                    managedConstraints.append(toBegin)
                    edgeConstraints = [beginEdge: toBegin]
                }
            }
            if let itemCenter = layout.center(axis) {
                view.alPin(centerAttr, to: centerAttr, of: self, constant: itemCenter.value, relation: itemCenter.relation, activate: false)
            }
            pinAccross(view: view, layout: layout, edgeConstraints: &edgeConstraints)
            prevItem = item
        }
        if let itemEnd = prevItem?.layout.end(axis) {
            let toEnd = self.alPin(endAttr, to: endAttr, of: prevItem!.view, constant: itemEnd.value + end, relation: itemEnd.relation, activate: false)
            managedConstraints.append(toEnd)
            edgeConstraints[endEdge] = toEnd
        }
        itemsEdgeConstraints.append(edgeConstraints)
        NSLayoutConstraint.activate(managedConstraints)
    }
    
    private var isUpdatingItems: Bool  = false
    
    private var begin: CGFloat {
        return (axis == .y) ? insets.top : insets.left
    }
    
    private var end: CGFloat {
        return (axis == .y) ? insets.bottom : insets.right
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
                    constr = self.alPin(attr, to: attr, of: view, constant: pin.value + insets.insetForAxis(otherAxis, position: pos), relation: pin.relation, activate: false)
                }
                else {
                    constr = view.alPin(attr, to: attr, of: self, constant: pin.value + insets.insetForAxis(otherAxis, position: pos), relation: pin.relation, activate: false)
                }
                managedConstraints.append(constr)
                edgeConstraints[edge] = constr
            }
        }
    }
    
    private func attributeForEdge(_ edge: BoxEdge) -> NSLayoutConstraint.Attribute {
            switch edge {
                case .left:
                    switch semanticContentAttribute {
                        case .unspecified: return .leading
                        case .forceRightToLeft: return .right
                        default: return .left
                    }
                case .right:
                    switch semanticContentAttribute {
                        case .unspecified: return .trailing
                        case .forceRightToLeft: return .left
                        default: return .right
                    }
                case .top: return .top
                case .bottom: return .bottom
                case .centerX: return .centerX
                case .centerY: return .centerY
            }
        }

    
    func centerOffsetFactorForAxis(_ axis: BoxLayout.Axis) -> CGFloat {
        if axis == .y {
            return 1.0
        }
        else {
            let dir = UIView.userInterfaceLayoutDirection(for: semanticContentAttribute)
            switch dir {
                case .leftToRight: return 1.0
                case .rightToLeft: return -1.0
                @unknown default:
                return 1.0
            }
        }
    }
}
