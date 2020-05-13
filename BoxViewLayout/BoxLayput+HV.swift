//
//  BoxLayput+HV.swift
//  BoxView
//
//  Created by Vlad on 5/11/20.
//  Copyright © 2020 Vladimir Dudkin. All rights reserved.
//

import UIKit

extension BoxLayout {
    
    struct H {
        
        var left: Pin?
        
        var right: Pin?
        
        var center: CGFloat?
        
        var semanticDirection: SemanticDirection = .system

        static let zero = H(left: .zero, right: .zero, center: nil)
        
        static func align(offset: CGFloat = 0.0, padding: CGFloat? = nil) -> H {
            if let padding = padding {
                let pin = >=padding
                return H(left: pin, right: pin, center: offset)
            }
            else {
                return H(left: nil, right: nil, center: offset)
            }
            
        }
        
        static func leftRight(_ left: CGFloat?, _ right: CGFloat?) -> H {
            return H(left: Pin.eq(left), right: Pin.eq(right), center: nil)
        }
        
        static let lr = leftRight
        
        static func pins(_ left: Pin?, _ right: Pin?) -> H {
            return H(left: left, right: right, center: nil)
        }
        
        static let sideMargins = H(left: Pin.eq(16.0), right: Pin.eq(16.0), center: nil)
    }
    
    struct V {
        
        var top: Pin?
        
        var bottom: Pin?
        
        var center: CGFloat?
        
        static let zero = V(top: .zero, bottom: .zero, center: nil)
        
        static func align(offset: CGFloat = 0.0) -> V {
            return V(top: nil, bottom: nil, center: offset)
        }
        
        static func topBottom(_ top: CGFloat?, _ bottom: CGFloat?) -> V {
            return V(top: Pin.eq(top), bottom: Pin.eq(bottom), center: nil)
        }
        
        static let tb = topBottom
        
        static func pins(_ top: Pin?, _ bottom: Pin?) -> V {
            return V(top: top, bottom: bottom, center: nil)
        }
    }
}
