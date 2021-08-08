//
//  BoxLayout+Enums.swift
//  BoxView
//
//  Created by Vlad on 5/11/20.
//  Copyright © 2020 Vladimir Dudkin. All rights reserved.
//

import UIKit


// MARK: - Public -

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
    
    public enum ZPosition {
        case back
        case front
        case below(_ view: UIView?)
        case above(_ view: UIView?)
    }
}


// BoxEdge duplicates subset of NSLayoutConstraint Attributes
public enum BoxEdge: CaseIterable {
    
    case top, left, right, bottom, centerX, centerY

    public typealias Values = [BoxEdge: CGFloat]

    public typealias Constraints = [BoxEdge: NSLayoutConstraint]
    
    public enum Position {
        case begin, center, end
    }
    
    public var str: String {
        switch self {
            case .left: return  "left"
            case .right: return "right"
            case .top: return "top"
            case .bottom: return "bottom"
            case .centerX: return "centerX"
            case .centerY: return "centerY"
        }
    }


// MARK: - Internal -

    func attribute(rtlDependent: Bool = true) -> NSLayoutConstraint.Attribute {
        switch self {
            case .left: return  (rtlDependent) ? .leading : .left
            case .right: return (rtlDependent) ? .trailing : .right
            case .top: return .top
            case .bottom: return .bottom
            case .centerX: return .centerX
            case .centerY: return .centerY
        }
    }
    
    var position: Position {
        switch self {
            case .left: return  .begin
            case .right: return .end
            case .top: return .begin
            case .bottom: return .end
            case .centerX: return .center
            case .centerY: return .center
        }
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


