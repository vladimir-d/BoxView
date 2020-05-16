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
    
//    var attr: NSLayoutConstraint.Attribute {
//        switch self {
//            case .left: return .left
//            case .right: return .right
//            case .top: return .top
//            case .bottom: return .bottom
//            case .centerX: return .centerX
//            case .centerY: return .centerY
//        }
//    }
    
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
    

//    public enum Edge  {
//        case top, left, right, bottom, centerX, centerY
//        
//        public typealias Values = [Edge: CGFloat]
//        
//        public typealias Constraints = [Edge: NSLayoutConstraint]
//    }
    
    public enum SemanticDirection {
        case system, fixedLTR, fixedRTL
    }
        
    public enum Axis {
        
        case horizontal
        
        case vertical
        
        var other: Axis {
            return (self == .vertical) ? .horizontal : .vertical
        }
        
        var beginEdge: BoxEdge {
            return (self == .vertical) ? .top : .left
        }
        
        var endEdge: BoxEdge {
            return (self == .vertical) ? .bottom : .right
        }
        
        var centerEdge: BoxEdge {
            return (self == .vertical) ? .centerY : .centerX
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
