//
//  BoxLayout+Enums.swift
//  BoxView
//
//  Created by Vlad on 5/11/20.
//  Copyright © 2020 Vladimir Dudkin. All rights reserved.
//

import UIKit


// MARK: - Public
// BoxEdge duplicates subset of NSLayoutConstraint Attributes
public enum BoxEdge: CaseIterable {
    
    case top, left, right, bottom, centerX, centerY

    public typealias Values = [BoxEdge: CGFloat]

    public typealias Constraints = [BoxEdge: NSLayoutConstraint]
    
    public enum Position {
        case begin, center, end
    }
    
    func attribute(semanticDependent: Bool = true) -> NSLayoutConstraint.Attribute {
        switch self {
            case .left: return  (semanticDependent) ? .leading : .left
            case .right: return (semanticDependent) ? .trailing : .right
            case .top: return .top
            case .bottom: return .bottom
            case .centerX: return .centerX
            case .centerY: return .centerY
        }
    }
    
}


// MARK: - Internal

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
        
        case x, y
        
        public var other: Axis {
            return (self == .y) ? .x : .y
        }
        
        func edgeForPosition(_ position: BoxEdge.Position) -> BoxEdge {
            switch position {
                case .begin: return (self == .y) ? .top : .left
                case .center: return (self == .y) ? .centerY : .centerX
                case .end: return (self == .y) ? .bottom : .right
            }
        }
        
    }
        
}

extension UIEdgeInsets {
    
    func begin(_ axis: BoxLayout.Axis) -> CGFloat {
        return (axis == .y) ? self.top : self.left
    }
    
    func end(_ axis: BoxLayout.Axis)  -> CGFloat {
        return (axis == .y) ? self.bottom : self.right
    }
    
    func insetForAxis(_ axis: BoxLayout.Axis, position: BoxEdge.Position)  -> CGFloat {
        switch position {
            case .begin: return (axis == .y) ? self.top : self.left
            case .center: return 0.0
            case .end: return (axis == .y) ? self.bottom : self.right
        }
    }
}
