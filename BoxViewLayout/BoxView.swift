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
    
    // MARK: -- Inits
    
    public init(axis: BoxLayout.Axis = .y, spacing: CGFloat = 0.0, insets: UIEdgeInsets = .zero) {
        self.axis = axis
        self.spacing = spacing
        super.init(frame: .zero)
        self.insets = insets
        langDir = UIView.userInterfaceLayoutDirection(for: semanticContentAttribute)
        translatesAutoresizingMaskIntoConstraints = false
        setup()
    }
    
    public required override init(frame: CGRect) {
        super.init(frame: frame)
        insets = .zero
        langDir = UIView.userInterfaceLayoutDirection(for: semanticContentAttribute)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open func setup() {
        // to override in subclasses
    }
    
    // MARK: -- vars
    
    // main axis along which item views are stacked.
    // X is horizontal and Y is vertical.
    public var axis: BoxLayout.Axis = .y {
        didSet {
            setNeedsUpdateConstraints()
        }
    }
    
    // sinchronized with layoutMargins
    public var insets: UIEdgeInsets {
        get {
            return layoutMargins
        }
        set (v) {
            layoutMargins = v
            if #available(iOS 11.0, *) {
                directionalLayoutMargins = NSDirectionalEdgeInsets(top: v.top,
                                                                   leading: v.left,
                                                                   bottom: v.bottom,
                                                                   trailing: v.right)
            }
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
    
    // Define which attributes used for left/right edges:
    // if true: leading/trailing, if false: left/right
    @IBInspectable
    public var isRTLDependent: Bool = true {
        didSet {
            setNeedsUpdateConstraints()
        }
    }
    
    // MARK: -- readonly vars
    
    // array of all automatically created by BoxView constraints
    public private(set) var managedConstraints = [NSLayoutConstraint]()
    
    // array of automatically created by BoxView constraints groupped in dictionary for each item
    public private(set) var itemsEdgeConstraints = [BoxEdge.Constraints]()
    
    // array of views of all items.
    // it is a subset of boxView.subviews
    public private(set) var managedViews = [UIView]()
    
    // MARK: -- setting items and layouts
    
    public var items:[BoxItem] = [] {
        didSet {
            updateItems()
        }
    }

    public func withItems(_ items:[BoxItem]) -> Self {
        self.items = items
        return self
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
    
    // MARK: -- animation
    
    public func animateChangesWithDurations(_ duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.superview?.layoutIfNeeded()
        }
    }

    // MARK: -- overriden UIView functions and vars
    
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
    
    override public var semanticContentAttribute: UISemanticContentAttribute {
        didSet {
            langDir = UIView.userInterfaceLayoutDirection(for: semanticContentAttribute)
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
                    let toBegin = view.alPin(beginAttr, to: beginAttr, of: self, constant: itemBegin.value + beginForAxis(axis), relation: itemBegin.relation, activate: false)
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
            let toEnd = self.alPin(endAttr, to: endAttr, of: prevItem!.view, constant: itemEnd.value + endForAxis(axis), relation: itemEnd.relation, activate: false)
            managedConstraints.append(toEnd)
            edgeConstraints[endEdge] = toEnd
        }
        itemsEdgeConstraints.append(edgeConstraints)
        NSLayoutConstraint.activate(managedConstraints)
    }
    
    private var isUpdatingItems: Bool  = false
    
    private var langDir: UIUserInterfaceLayoutDirection = .leftToRight
    
    private func beginForAxis(_ anAxis: BoxLayout.Axis) -> CGFloat {
        return (anAxis == .y) ? insets.top : insets.left
    }
    
    private func endForAxis(_ anAxis: BoxLayout.Axis) -> CGFloat {
        return (anAxis == .y) ? insets.bottom : insets.right
    }

    private func centerOffsetForAxis(_ anAxis: BoxLayout.Axis) -> CGFloat {
        return 0.5 * ((anAxis == .y) ? insets.top - insets.bottom : (insets.left - insets.right) * offsetFactorForAxis(anAxis))
    }
    
    private func offsetFactorForAxis(_ anAxis: BoxLayout.Axis) -> CGFloat {
        return (anAxis == .y || langDir == .leftToRight || !isRTLDependent) ? 1.0 : -1.0
    }
    
    func insetForAxis(_ anAxis: BoxLayout.Axis, position: BoxEdge.Position)  -> CGFloat {
        switch position {
            case .begin: return beginForAxis(anAxis)
            case .center: return centerOffsetForAxis(anAxis)
            case .end: return endForAxis(anAxis)
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
                    constr = self.alPin(attr, to: attr, of: view, constant: pin.value + insetForAxis(otherAxis, position: pos), relation: pin.relation, activate: false)
                }
                else {
                    var factor: CGFloat = 1.0
                    if pos == .center {
                        factor = offsetFactorForAxis(otherAxis)
                    }
                    constr = view.alPin(attr, to: attr, of: self, constant: factor * pin.value + insetForAxis(otherAxis, position: pos), relation: pin.relation, activate: false)
                }
                print("insetForAxis(\(otherAxis), position: \(pos)): \(insetForAxis(otherAxis, position: pos))")
                
                
                managedConstraints.append(constr)
                edgeConstraints[edge] = constr
            }
        }
    }
    
    private func attributeForEdge(_ edge: BoxEdge) -> NSLayoutConstraint.Attribute {
            switch edge {
                case .left: return (isRTLDependent) ? .leading : .left
                case .right: return (isRTLDependent) ? .trailing : .right
                case .top: return .top
                case .bottom: return .bottom
                case .centerX: return .centerX
                case .centerY: return .centerY
            }
        }
}

@available(iOS 11.0, *)
extension BoxView {
    // BoxView doesn't use directionalLayoutMargins - insets for RTL languages are automatically handled while layouting managed views.
    //  But they used for layouting non-managed subviews.
    public override var directionalLayoutMargins: NSDirectionalEdgeInsets {
        didSet {
            layoutMargins = UIEdgeInsets(top: directionalLayoutMargins.top,
                                         left: directionalLayoutMargins.leading,
                                         bottom: directionalLayoutMargins.bottom,
                                         right: directionalLayoutMargins.trailing)
            
        }

    }
}
