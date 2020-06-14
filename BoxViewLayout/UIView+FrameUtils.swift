//
//  UIView+BoxRelated.swift
//  BoxViewExample
//
//  Created by Vlad on 6/12/20.
//  Copyright © 2020 Vlad. All rights reserved.
//

import UIKit

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
    
}
