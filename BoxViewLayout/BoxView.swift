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
        translatesAutoresizingMaskIntoConstraints = false
        setup()
    }
    
    public required override init(frame: CGRect) {
        super.init(frame: frame)
        insets = .zero
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
//    @IBInspectable
//    public var isRTLDependent: Bool = true {
//        didSet {
//            setNeedsUpdateConstraints()
//        }
//    }
    
    override open var semanticContentAttribute: UISemanticContentAttribute {
        didSet {
            setNeedsUpdateConstraints()
        }
    }
    
    // MARK: -- readonly vars
    
    // array of all automatically created by BoxView constraints
    public private(set) var managedConstraints = [NSLayoutConstraint]()
    
    // array of views of items.
    // it is a subset of boxView.subviews
    public private(set) var managedViews = [UIView]()
    
    // array of guides of items.
    public private(set) var managedGuides = [UILayoutGuide]()
    
    
    // MARK: -- setting items and layouts
    
    public var items:[BoxItem] = [] {
        didSet {
            updateItems()
        }
    }
    
    // to set items from array containing optionals
    public var optItems:[BoxItem?] {
        get {return []}
        set { items = newValue.compactMap{$0} }
    }

    public func withItems(_ items:[BoxItem]) -> Self {
        self.items = items
        return self
    }
    
    // setting items from array of views using same layout
    public func setViews(_ views: [UIView], layout: BoxLayout = .zero) {
        items = [BoxItem]()
        for view in views {
            items.append(view.boxed(layout: layout))
        }
    }
    
    // appending item
    public func addItem(_ item: BoxItem) {
        items.append(item)
    }
    
    // inserting item after item with given view, if view is nil, then item inserted at index 0
    public func insertItem(_ item: BoxItem, after view: UIView?, z: BoxLayout.ZPosition? = nil) {
        isUpdatingItems = true
        if let itemView = item.view {
            if managedViews.contains(itemView) {
                if let ind = itemIndexForObject(itemView) {
                    items.remove(at: ind)
                }
                itemView.removeFromSuperview()
            }
        }
        if let index = items.firstIndex(where: {$0.view == view}) {
            items.insert(item, at: index + 1)
        }
        else {
            items.insert(item, at: 0)
        }
        if let itemView = item.view {
            itemView.translatesAutoresizingMaskIntoConstraints = false
            if let ind = managedViews.firstIndex(where: {$0 == view}) {
                managedViews.insert(itemView, at: ind + 1)
            }
            else {
                managedViews.insert(itemView, at: 0)
            }
            insertSubview(itemView, z: z ?? .above(view))
        }
        isUpdatingItems = false
        setNeedsUpdateConstraints()
    }
    
    // inserting item before item with given view, if view is nil, then item inserted at the end
    public func insertItem(_ item: BoxItem, before view: UIView?, z: BoxLayout.ZPosition? = nil) {
        isUpdatingItems = true
        if let itemView = item.view {
            if managedViews.contains(itemView) {
                if let ind = itemIndexForObject(itemView) {
                    items.remove(at: ind)
                }
                itemView.removeFromSuperview()
            }
        }
        if let index = items.firstIndex(where: {$0.view == view}) {
            items.insert(item, at: index)
        }
        else {
            items.append(item)
        }
        if let itemView = item.view {
            itemView.translatesAutoresizingMaskIntoConstraints = false
            if let ind = managedViews.firstIndex(where: {$0 == view}) {
                managedViews.insert(itemView, at: ind)
            }
            else {
                managedViews.append(itemView)
            }
            insertSubview(itemView, z: z ?? .below(view))
        }
        isUpdatingItems = false
        
        setNeedsUpdateConstraints()
    }
    
    // changing layout of existing item with specified object (view or guide)
    public func setLayout(_ layout: BoxLayout, for obj: BoxAnchorable?) {
        if let index = items.firstIndex(where: { $0.alObj === obj}) {
            items[index].layout = layout
            setNeedsUpdateConstraints()
        }
    }
    
    // getting existing item with specified object (view or guide)
    public func itemForObject(_ obj: BoxAnchorable) -> BoxItem? {
        return items.first(where: {$0.alObj === obj})
    }
    
    // getting index of existing item with specified object (view or guide)
    public func itemIndexForObject(_ obj: BoxAnchorable) -> Int? {
        return items.firstIndex(where: {$0.alObj === obj})
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
    
    var itemsDescription: String {
        return (0..<items.count).compactMap { (i) -> String in
            return "\n[\(i)] \(items[i].description)"
        }.joined(separator: ",")
    }
    
    
    // MARK: - Private
    
    private func updateItems() {
        if isUpdatingItems { return }
        isUpdatingItems = true
        let itemViews = items.compactMap{ $0.view }
        var viewsToRemove = [Int]()
        for (index, managedView) in managedViews.enumerated() {
            if !itemViews.contains(managedView) {
                viewsToRemove.append(index)
                managedView.removeFromSuperview()
            }
        }
        for index in viewsToRemove.reversed() {
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
        let itemGuides = items.compactMap{ $0.guide }
        var guidesToRemove = [Int]()
        for (index, managedGuide) in managedGuides.enumerated() {
            if !itemGuides.contains(managedGuide) {
                guidesToRemove.append(index)
                removeLayoutGuide(managedGuide)
            }
        }
        for index in guidesToRemove.reversed() {
            managedGuides.remove(at: index)
        }
        for guide in itemGuides {
            if !managedGuides.contains(guide) {
                managedGuides.append(guide)
                addLayoutGuide(guide)
            }
        }
        isUpdatingItems = false
        setNeedsUpdateConstraints()
    }
    
    private func addItemsConstraints() {
        self.removeConstraints(managedConstraints)
        createChainConstraints(boxItems: items, axis: axis, spacing: spacing, constraints: &managedConstraints)
        createDimentions(boxItems: items, constraints: &managedConstraints)
        createRelativeDimensions(boxItems: items, constraints: &managedConstraints)
        createFlexDimentions(boxItems: items, axis: axis, constraints: &managedConstraints)
        NSLayoutConstraint.activate(managedConstraints)
    }
    

    private var isUpdatingItems: Bool  = false
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
