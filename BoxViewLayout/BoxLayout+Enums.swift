//
//  BoxLayout+Enums.swift
//  BoxView
//
//  Created by Vlad on 5/11/20.
//  Copyright © 2020 Vladimir Dudkin. All rights reserved.
//

import UIKit

//public typealias BoxEdge = NSLayoutConstraint.Attribute

public enum BoxEdge  {
    
    case top, left, right, bottom, centerX, centerY

    public typealias Values = [BoxEdge: CGFloat]

    public typealias Constraints = [BoxEdge: NSLayoutConstraint]
    
    public enum Position {
        case begin, center, end
    }
}

extension NSLayoutConstraint.Attribute {
    
    var edge: BoxEdge? {
        switch self {
            case .left: return .left
            case .right: return .right
            case .top: return .top
            case .bottom: return .bottom
            case .centerX: return .centerX
            case .centerY: return .centerY
            default: return nil
        }
    }
}

extension BoxLayout {
        
    public enum Axis {
        
        case horizontal, vertical
        
        public var other: Axis {
            return (self == .vertical) ? .horizontal : .vertical
        }
        
        func edgeForPosition(_ position: BoxEdge.Position) -> BoxEdge {
            switch position {
                case .begin: return (self == .vertical) ? .top : .left
                case .center: return (self == .vertical) ? .centerY : .centerX
                case .end: return (self == .vertical) ? .bottom : .right
            }
        }
        
    }
        
}

extension UIEdgeInsets {
    
    func begin(_ axis: BoxLayout.Axis) -> CGFloat {
        return (axis == .vertical) ? self.top : self.left
    }
    
    func end(_ axis: BoxLayout.Axis)  -> CGFloat {
        return (axis == .vertical) ? self.bottom : self.right
    }
    
    func insetForAxis(_ axis: BoxLayout.Axis, position: BoxEdge.Position)  -> CGFloat {
        switch position {
            case .begin: return (axis == .vertical) ? self.top : self.left
            case .center: return 0.0
            case .end: return (axis == .vertical) ? self.bottom : self.right
        }
    }
}
