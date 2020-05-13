//
//  BoxView.swift
//  BoxView
//
//  Created by Vlad on 4/2/20.
//  Copyright © 2020 Vladimir Dudkin. All rights reserved.
//

import UIKit

class BoxView: UIView {
    
    init(axis: BoxLayout.Axis = .vertical) {
        self.axis = axis
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var items:[BoxItem] = [] {
        didSet {
            updateItems()
        }
    }
    
    var axis: BoxLayout.Axis = .vertical {
        didSet {
            setNeedsUpdateConstraints()
        }
    }
    
    var insets = UIEdgeInsets.zero {
        didSet {
            setNeedsUpdateConstraints()
        }
    }
    
    var spacing: CGFloat = 0.0 {
        didSet {
            setNeedsUpdateConstraints()
        }
    }
    
    func setViews(_ views: [UIView], layout: BoxLayout = .zero) {
        items = [BoxItem]()
        for view in views {
            items.append(view.withLayout(layout))
        }
    }
    
    func setLayout(_ layout: BoxLayout, for view: UIView?) {
        if let index = items.firstIndex(where: { $0.view == view}) {
            items[index].layout = layout
            setNeedsUpdateConstraints()
        }
    }
    
    func animateChangesWithDurations(_ duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.superview?.layoutIfNeeded()
        }
    }

    override func updateConstraints() {
        removeSubviewsConstraints()
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
        for item in items {
            let view = item.view
            let layout = item.layout
            if beginAttr == nil {
                beginAttr = layout.beginAttributeForAxis(axis)
                endAttr = layout.endAttributeForAxis(axis)
            }
            if let prevItem = prevItem {
                guard let itemBegin = layout.begin(axis), let itemEnd = prevItem.layout.end(axis) else {
                    axisWarning(); return
                }
                guard let sumPin = itemBegin + itemEnd else {
                    sumPinWarning(); return
                }
                view.alPin(beginAttr, to: endAttr, of: prevItem.view, constant: sumPin.value + spacing, relation: sumPin.relation)
            }
            else{
                guard let itemBegin = layout.begin(axis) else {
                    axisWarning(); return
                }
                view.alPin(beginAttr, to: beginAttr, of: self, constant: itemBegin.value + begin, relation: itemBegin.relation)
            }
            pinAccross(view: view, layout: layout)
            prevItem = item
        }
        guard let itemEnd = prevItem?.layout.end(axis) else {
            axisWarning(); return
        }
        self.alPin(endAttr, to: endAttr, of: prevItem!.view, constant: itemEnd.value + end, relation: itemEnd.relation)
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
    
    private func pinAccross(view: UIView, layout: BoxLayout) {
        if (axis == .vertical) {
            let beginAttr = layout.beginAttributeForAxis(.horizontal)
            let endAttr = layout.endAttributeForAxis(.horizontal)
            if let left = layout.h.left {
                view.alPin(beginAttr, to: beginAttr, of: self, constant: left.value + insets.left, relation: left.relation)
            }
            if let right = layout.h.right {
                self.alPin(endAttr, to: endAttr, of: view, constant: right.value + insets.right, relation: right.relation)
            }
            if let center = layout.h.center {
                view.alPin(.centerX, to: .centerX, of: self, constant: center, relation: .equal)
            }
        }
        else {
            if let top = layout.v.top {
                view.alPin(.top, to: .top, of: self, constant: top.value + insets.top, relation: top.relation)
            }
            if let bottom = layout.v.bottom {
                view.alPin(.bottom, to: .bottom, of: self, constant: -(bottom.value + insets.bottom), relation: bottom.relation)
            }
            if let center = layout.v.center {
                view.alPin(.centerY, to: .centerY, of: self, constant: center, relation: .equal)
            }
        }
    }
}









