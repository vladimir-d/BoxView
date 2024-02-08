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

    /// Main axis along which item views are stacked.
    /// X is horizontal and Y is vertical.
    public var axis: BoxLayout.Axis = .y {
        didSet {
            setNeedsUpdateAllConstraints()
        }
    }

    // Unfortunately, layoutMargins are not always independent,
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

    /// Default spacing between item views. Actual spacing between every two items is:
    /// end pin of first view + spacing + begin pin of second view
    @IBInspectable
    public var spacing: CGFloat = 0.0 {
        didSet {
            setNeedsUpdateAllConstraints()
        }
    }

    public var frontViews: [UIView]? {
        didSet {
            frontViews?.forEach { bringSubviewToFront($0) }
        }
    }

    public var backViews: [UIView]? {
        didSet {
            backViews?.forEach { sendSubviewToBack($0) }
        }
    }

    /// If true, items with view.isHidden = true are automatically excluded from layout
    public var excludeHiddenViews = false {
        didSet {
            if oldValue != excludeHiddenViews {
                if excludeHiddenViews {
                    managedViews.forEach { addObserverForItemView($0) }
                }
                else {
                    observers = [Int: NSKeyValueObservation]()
                }
                setNeedsUpdateAllConstraints()
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

    /// Array of all automatically created by BoxView constraints
    public internal(set) var managedConstraints = [NSLayoutConstraint]()

    /// Array of views of all items.
    /// It is a subset of boxView.subviews
    public internal(set) var managedViews = [UIView]()

    /// Array of guides of all items.
    public internal(set) var managedGuides = [UILayoutGuide]()

    /// The flag shows that something c
    public internal(set) var needsUpdateItems = true


    // MARK: -- setting items and layouts

    /// Array of BoxItem elements.
    /// Set items to add subvies with layout information to the boxView.
    public var items:[BoxItem] = [] {
        didSet {
            updateItemsViews()
        }
    }

    /// To set items from array containing optionals
    public var optItems:[BoxItem?] {
        get { return [] }
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

    /// Inserting item after item with given object, if view is nil, then item inserted at index 0
    public func insertItem(_ item: BoxItem, after object: BoxAnchorable?, z: BoxLayout.ZPosition? = nil) {
        isUpdatingItems = true

        if let ind = itemIndexForObject(item.alObj) {
            items.remove(at: ind)
        }
        var targetIndex = 0
        if let index = items.firstIndex(where: {$0.alObj === object}) {
            targetIndex = index + 1
        }
        items.insert(item, at: targetIndex)

        if let itemView = item.view {
            if !managedViews.contains(itemView) {
                configureManagedView(itemView)
                managedViews.append(itemView)
            }
            insertSubview(itemView, z: z ?? .above(object as? UIView))
        }
        else if let itemGuide = item.guide {
            if !managedGuides.contains(itemGuide) {
                managedGuides.append(itemGuide)
            }
            addLayoutGuide(itemGuide)
        }
        isUpdatingItems = false
        setNeedsUpdateAllConstraints()
    }

    // inserting item before item with given object, if view is nil, then item inserted at the end
    public func insertItem(_ item: BoxItem, before object: BoxAnchorable, z: BoxLayout.ZPosition? = nil) {
        isUpdatingItems = true

        if let ind = itemIndexForObject(item.alObj) {
            items.remove(at: ind)
        }
        if let index = items.firstIndex(where: {$0.alObj === object}) {
            items.insert(item, at: index)
        }
        else {
            items.append(item)
        }

        if let itemView = item.view {
            if !managedViews.contains(itemView) {
                configureManagedView(itemView)
                managedViews.append(itemView)
            }
            insertSubview(itemView, z: z ?? .below(object as? UIView))
        }
        else if let itemGuide = item.guide {
            if !managedGuides.contains(itemGuide) {
                managedGuides.append(itemGuide)
            }
            addLayoutGuide(itemGuide)
        }
        isUpdatingItems = false
        setNeedsUpdateAllConstraints()
    }

    // changing layout of existing item with specified object (view or guide)
    public func setLayout(_ layout: BoxLayout, for obj: BoxAnchorable?) {
        if let index = items.firstIndex(where: { $0.alObj === obj}) {
            items[index].layout = layout
            setNeedsUpdateAllConstraints()
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

    public func setNeedsUpdateItems() {
        needsUpdateItems = true
        setNeedsLayout()
    }

    // MARK: -- description

    var itemsDescription: String {
        return (0..<items.count).compactMap { (i) -> String in
            return "\n[\(i)] \(items[i].description)"
        }.joined(separator: ",")
    }

    public override var debugDescription: String {
        return super.debugDescription + " [\(items.count) items]"
        //"\nitems:\(itemsDescription)"
    }
    
    // MARK: -- animation
    
    public func animateChangesWithDurations(_ duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.superview?.layoutIfNeeded()
        }
    }

    // MARK: -- overriden UIView functions and vars
    
    /// When items are assigned or parameters affecting layout are changed, constraints are not changed immediatly. Only setNeedsUpdateAllConstraints() called. Later this function is called automatically when boxView laying out own subviews. So im most cases no need to call anything to update constraints.
    /// Yet it be can be called directly to force create constraints immediatly.
    override open func updateConstraints() {
        super.updateConstraints()
        if !isUpdatingItems {
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
                setNeedsUpdateAllConstraints()
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
    
    // MARK: -- Managing items --
    
    internal var isUpdatingItems: Bool  = false
    
    internal func setNeedsUpdateAllConstraints() {
        setNeedsUpdateConstraints()
    }
    
    /// This function does nothing in the base class.
    /// It is called when items have to be updated.
    /// So it the place to put items updating code in subclasses.
    /// In most cases it should not be called directly, use setNeedsUpdateItems() function instead to set needsUpdateItems flag, and this function will be called automatically on next layout cycle.
    open func updateItems() {
    }
    
    override open func layoutSubviews() {
        if needsUpdateItems {
            updateItems()
            needsUpdateItems = false
        }
        super.layoutSubviews()
    }
    
    internal func updateItemsViews() {
        if isUpdatingItems { return }
        isUpdatingItems = true
        let itemViews = items.compactMap{ $0.view }
        var viewsToRemove = [Int]()
        for (index, managedView) in managedViews.enumerated() {
            if !itemViews.contains(managedView) {
                viewsToRemove.append(index)
            }
        }
        for index in viewsToRemove.reversed() {
            removeManagedView(at: index)
        }
        for view in itemViews {
            if !managedViews.contains(view) {
                addManagedView(view)
            }
        }
        let itemGuides = items.compactMap{ $0.guide }
        var guidesToRemove = [Int]()
        for (index, managedGuide) in managedGuides.enumerated() {
            if !itemGuides.contains(managedGuide) {
                guidesToRemove.append(index)
            }
        }
        for index in guidesToRemove.reversed() {
            removeManagedGuide(at: index)
        }
        for guide in itemGuides {
            if !managedGuides.contains(guide) {
                managedGuides.append(guide)
                addLayoutGuide(guide)
            }
        }
        frontViews?.forEach { bringSubviewToFront($0) }
        backViews?.forEach { sendSubviewToBack($0) }
        isUpdatingItems = false
        setNeedsUpdateAllConstraints()
    }
    
    internal func addItemsConstraints() {
        NSLayoutConstraint.deactivate(managedConstraints)
        managedConstraints = []
        let usedItems = (!excludeHiddenViews) ? items : items.compactMap { ($0.view?.isHidden ?? false) ? nil : $0 }
        createChainConstraints(boxItems: usedItems, axis: axis, spacing: spacing, insets: insets, constraints: &managedConstraints)
        items.createDimensions(constraints: &managedConstraints)
        createRelativeDimensions(boxItems: usedItems, constraints: &managedConstraints)
        createFlexDimentions(boxItems: usedItems, axis: axis, constraints: &managedConstraints)
        NSLayoutConstraint.activate(managedConstraints)
    }
    
    // MARK: -- Adding, removing and configuring item objects --
    
    internal func addManagedView(_ view: UIView) {
        configureManagedView(view)
        addSubview(view)
        managedViews.append(view)
    }
    
    internal func removeManagedView(at ind: Int) {
        let view = managedViews[ind]
        if (excludeHiddenViews) {
            removeObserverForItemView(view)
        }
        if view.superview == self {
            view.removeFromSuperview()
        }
        managedViews.remove(at: ind)
    }
    
    internal func addManagedGuide(_ guide: UILayoutGuide) {
        managedGuides.append(guide)
        addLayoutGuide(guide)
    }
    
    internal func removeManagedGuide(at ind: Int) {
        removeLayoutGuide(managedGuides[ind])
        managedGuides.remove(at: ind)
    }
    
    internal func removeManagedGuide(_ guide: UILayoutGuide) {
        if let ind = managedGuides.firstIndex(of: guide) {
            managedGuides.remove(at: ind)
        }
        removeLayoutGuide(guide)
    }
    
    func configureManagedView(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        if forceSubviewsSCA {
            setSCAIfNeed(for: view)
        }
        if (excludeHiddenViews) {
            addObserverForItemView(view)
        }
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
    
    // MARK: -- Internal properties --

    internal var _insets: UIEdgeInsets = .zero {
        didSet {
            setNeedsUpdateAllConstraints()
        }
    }

    // MARK: -- Managing observers --
    
    internal var observers = [Int: NSKeyValueObservation]()
    
    internal func addObserverForItemView(_ view: UIView) {
        let intValue: Int = unsafeBitCast(view, to: Int.self)
        observers[intValue] = view.observe(\.isHidden) { [unowned self] (_, _) in
            self.setNeedsUpdateAllConstraints()
        }
    }
    
    internal func removeObserverForItemView(_ view: UIView) {
        let intValue: Int = unsafeBitCast(view, to: Int.self)
        observers[intValue] = nil
    }
}

