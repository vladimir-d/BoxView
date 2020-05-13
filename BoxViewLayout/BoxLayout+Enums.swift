//
//  BoxLayout+Enums.swift
//  BoxView
//
//  Created by Vlad on 5/11/20.
//  Copyright © 2020 Vladimir Dudkin. All rights reserved.
//

import UIKit

extension BoxLayout {
    
    enum Edge  {
        case top, left, right, bottom, centerX, centerY
        
        typealias Values = [Edge: CGFloat]
        
        typealias Constraints = [Edge: NSLayoutConstraint]
    }
    
    enum SemanticDirection {
        case system, fixedLTR, fixedRTL
    }
        
    enum Axis {
        
        case horizontal
        
        case vertical
        
        var other: Axis {
            return (self == .vertical) ? .horizontal : .vertical
        }
    }
        
}
