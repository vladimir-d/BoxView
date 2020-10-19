//
//  UIView+BoxRelated.swift
//  BoxViewExample
//
//  Created by Vlad on 6/12/20.
//  Copyright © 2020 Vlad. All rights reserved.
//

import UIKit

// MARK: - Public -

extension UIView {
    
    public func insertionFrameBelow(view: UIView) -> CGRect {
        var frame = view.convert(view.bounds, to: self)
        frame.origin.y += frame.size.height
        frame.size.height = 0.0
        return frame
    }
    
    public func insertionFrameOnRight(view: UIView) -> CGRect {
        var frame = view.convert(view.bounds, to: self)
        frame.origin.x += frame.size.width
        frame.size.width = 0.0
        return frame
    }
    
    public func insertSubview(_ subview: UIView, z: BoxLayout.ZPosition? = nil) {
        switch z {
            case .back: insertSubview(subview, at: 0)
            case let .above(view):
                if let view = view {
                    self.insertSubview(subview, aboveSubview: view)
                }
                else {
                    insertSubview(subview, at: 0)
                }
            case let .below(view):
                if let view = view {
                    self.insertSubview(subview, belowSubview: view)
                }
                else {
                    addSubview(subview)
                }
            default: addSubview(subview)
        }
    }
}
