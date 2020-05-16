//
//  BoxLayput+HV.swift
//  BoxView
//
//  Created by Vlad on 5/11/20.
//  Copyright © 2020 Vladimir Dudkin. All rights reserved.
//

import UIKit

extension BoxLayout {
    
    public struct H {
        
        var left: Pin?
        
        var right: Pin?
        
        var center: Pin?
        
        var semanticDirection: SemanticDirection = .system

        public static let zero = H(left: .zero, right: .zero, center: nil)
        
        public static func align(offset: CGFloat = 0.0, padding: CGFloat? = nil) -> H {
            if let padding = padding {
                let pin = >=padding
                return H(left: pin, right: pin, center: ==offset)
            }
            else {
                return H(left: nil, right: nil, center: ==offset)
            }
            
        }
        
        public static func leftRight(_ left: CGFloat?, _ right: CGFloat?) -> H {
            return H(left: Pin.eq(left), right: Pin.eq(right), center: nil)
        }
        
        public static let lr = leftRight
        
        public static func pins(_ left: Pin?, _ right: Pin?) -> H {
            return H(left: left, right: right, center: nil)
        }

    }
    
    public struct V {
        
        var top: Pin?
        
        var bottom: Pin?
        
        var center: Pin?
        
        public static let zero = V(top: .zero, bottom: .zero, center: nil)
        
        public static func align(offset: CGFloat = 0.0, padding: CGFloat? = nil) -> V {
            if let padding = padding {
                let pin = >=padding
                return V(top: pin, bottom: pin, center: ==offset)
            }
            else {
                return V(top: nil, bottom: nil, center: ==offset)
            }
            
        }
        
        public static func topBottom(_ top: CGFloat?, _ bottom: CGFloat?) -> V {
            return V(top: Pin.eq(top), bottom: Pin.eq(bottom), center: nil)
        }
        
        public static let tb = topBottom
        
        public static func pins(_ top: Pin?, _ bottom: Pin?) -> V {
            return V(top: top, bottom: bottom, center: nil)
        }
    }
}
