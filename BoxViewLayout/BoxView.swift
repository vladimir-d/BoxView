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
    
// MARK: - Public -
    
    // MARK: -- Inits
    
    public init(axis: BoxLayout.Axis = .y, spacing: CGFloat = 0.0, insets: UIEdgeInsets = .zero) {
        self.axis = axis
        self.spacing = spacing
        self._insets = insets
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setup()
    }
    
    public required override init(frame: CGRect) {
        _insets = .zero
        super.init(frame: frame)
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
    
    // Unfotunately, layoutMargins are not always independent,
    // and may be changed by superview or viewController.
    // So better not to to use them, and use instead only own insets property.
    // Or set this flag to true, to make insets synchronized with layoutMargins.
    public var insetsAreMargins: Bool = false

    public var insets: UIEdgeInsets {
        get { return _insets }
        set (newInsets) {
            if (insetsAreMargins) {
                layoutMargins = newInsets
            }
            else {
                _insets = newInsets
            }
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
    
    // If true, items with view.isHidden = true are automatically excluded from layout
    public var excludeHiddenViews = false {
        didSet {
            if oldValue != excludeHiddenViews {
                if excludeHiddenViews {
                    managedViews.forEach { addObserverForItemView($0) }
                }
                else {
                    observers = [Int: NSKeyValueObservation]()
                }
                setNeedsUpdateConstraints()
            }
        }
    }

    public var forceSubviewsSCA = false {
        didSet {
            if oldValue != forceSubviewsSCA {
                if forceSubviewsSCA {
                    managedViews.forEach { setSCAIfNeed(for: $0) }
                }
            }
        }
    }
    
    public var allowNotManagedViews = false
    
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
        var newItems = [BoxItem]()
        for view in views {
            newItems.append(view.boxed(layout: layout))
        }
        items = newItems
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
    
    // updating existing box item for corresponding view or guide
    public func updateItemForObject(_ obj: BoxAnchorable, update: BoxItemUpdate) {
        if let ind = itemIndexForObject(obj) {
            items[ind] = update(items[ind])
        }
    }
    
    // MARK: -- description
    
    var itemsDescription: String {
        return (0..<items.count).compactMap { (i) -> String in
            return "\n[\(i)] \(items[i].description)"
        }.joined(separator: ",")
    }
    
    public override var debugDescription: String {
        return super.debugDescription + "\nitems:\(itemsDescription)"
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
    override open func updateConstraints() {
        super.updateConstraints()
        if !isUpdatingItems {
            NSLayoutConstraint.deactivate(managedConstraints)
            managedConstraints = []
            addItemsConstraints()
            super.updateConstraints()
        }
    }
    
    override open func willRemoveSubview(_ subview: UIView) {
        superview?.willRemoveSubview(subview)
        if !isUpdatingItems {
            if managedViews.contains(subview) {
                if (excludeHiddenViews) {
                    removeObserverForItemView(subview)
                }
                if let index = items.firstIndex(where: { $0.view == subview}) {
                    items.remove(at: index)
                }
            }
        }
    }
    
    override open var semanticContentAttribute: UISemanticContentAttribute {
        didSet {
            if oldValue != semanticContentAttribute {
                if forceSubviewsSCA {
                    managedViews.forEach { setSCAIfNeed(for: $0) }
                }
                setNeedsUpdateConstraints()
            }
        }
    }

    public override var layoutMargins: UIEdgeInsets {
        didSet {
            if (insetsAreMargins) {
                _insets = layoutMargins
            }
        }
    }
    
    // BoxView doesn't use directionalLayoutMargins - insets for RTL languages are automatically handled while layouting managed views.
    //  But they are used for layouting non-managed subviews.
    @available(iOS 11.0, *)
    public override var directionalLayoutMargins: NSDirectionalEdgeInsets {
        didSet {
            if (insetsAreMargins) {
                layoutMargins = UIEdgeInsets(top: directionalLayoutMargins.top,
                                         left: directionalLayoutMargins.leading,
                                         bottom: directionalLayoutMargins.bottom,
                                         right: directionalLayoutMargins.trailing)
            }
        }

    }

    
// MARK: - Internal -
    
    internal func updateItems() {
        if isUpdatingItems { return }
        isUpdatingItems = true
        let itemViews = items.compactMap{ $0.view }
        var viewsToRemove = [Int]()
        for (index, managedView) in managedViews.enumerated() {
            if !itemViews.contains(managedView) {
                viewsToRemove.append(index)
                if (excludeHiddenViews) {
                    removeObserverForItemView(managedView)
                }
                managedView.removeFromSuperview()
            }
        }
        for index in viewsToRemove.reversed() {
            managedViews.remove(at: index)
        }
        for view in itemViews {
            if !managedViews.contains(view) {
                view.translatesAutoresizingMaskIntoConstraints = false
                if forceSubviewsSCA {
                    setSCAIfNeed(for: view)
                }
                managedViews.append(view)
                addSubview(view)
                if (excludeHiddenViews) {
                    addObserverForItemView(view)
                }
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
    
    internal func addItemsConstraints() {
        let usedItems = (!excludeHiddenViews) ? items : items.compactMap { ($0.view?.isHidden ?? false) ? nil : $0 }
        createChainConstraints(boxItems: usedItems, axis: axis, spacing: spacing, insets: insets, constraints: &managedConstraints)
        items.createDimensions(constraints: &managedConstraints)
        createRelativeDimensions(boxItems: usedItems, constraints: &managedConstraints)
        createFlexDimentions(boxItems: usedItems, axis: axis, constraints: &managedConstraints)
        NSLayoutConstraint.activate(managedConstraints)
    }

    
    internal var _insets: UIEdgeInsets = .zero {
        didSet {
            setNeedsUpdateConstraints()
        }
    }

    internal var isUpdatingItems: Bool  = false
    
    internal var observers = [Int: NSKeyValueObservation]()
    
    internal func addObserverForItemView(_ view: UIView) {
        let intValue: Int = unsafeBitCast(view, to: Int.self)
        observers[intValue] = view.observe(\.isHidden) { [unowned self] (_, _) in
            self.setNeedsUpdateConstraints()
        }
    }
    
    internal func removeObserverForItemView(_ view: UIView) {
        let intValue: Int = unsafeBitCast(view, to: Int.self)
        observers[intValue] = nil
    }
    
    internal func setSCAIfNeed(for view: UIView) {
        if view.semanticContentAttribute != semanticContentAttribute {
            view.semanticContentAttribute = semanticContentAttribute
            view.setNeedsUpdateConstraints()
            view.setNeedsLayout()
            if forceSubviewsSCA {
                if let bv = view as? BoxView {
                    bv.forceSubviewsSCA = true
                }
            }
        }
    }

}


