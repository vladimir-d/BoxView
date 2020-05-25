//
//  BoxLayput+XY.swift
//  BoxView
//
//  Created by Vlad on 5/11/20.
//  Copyright © 2020 Vladimir Dudkin. All rights reserved.
//

import UIKit

extension BoxLayout {
    
    public struct X {
        
        public var left: Pin?
        
        public var right: Pin?
        
        public var center: Pin?

        public static let zero = X(left: .zero, right: .zero, center: nil)
        
        public static func align(offset: CGFloat = 0.0, padding: CGFloat? = nil) -> X {
            if let padding = padding {
                let pin = >=padding
                return X(left: pin, right: pin, center: ==offset)
            }
            else {
                return X(left: nil, right: nil, center: ==offset)
            }
            
        }
        
        public static func leftRight(_ left: CGFloat?, _ right: CGFloat?) -> X {
            return X(left: ==left, right: ==right, center: nil)
        }
        
        public static let lr = leftRight
        
        public static func leftRightPins(_ left: Pin?, _ right: Pin?) -> X {
            return X(left: left, right: right, center: nil)
        }
        
        public static let xPins = leftRightPins

    }
    
    public struct Y {
        
        public var top: Pin?
        
        public var bottom: Pin?
        
        public var center: Pin?
        
        public static let zero = Y(top: .zero, bottom: .zero, center: nil)
        
        public static func align(offset: CGFloat = 0.0, padding: CGFloat? = nil) -> Y {
            if let padding = padding {
                let pin = >=padding
                return Y(top: pin, bottom: pin, center: ==offset)
            }
            else {
                return Y(top: nil, bottom: nil, center: ==offset)
            }
            
        }
        
        public static func topBottom(_ top: CGFloat?, _ bottom: CGFloat?) -> Y {
            return Y(top: ==top, bottom: ==bottom, center: nil)
        }
        
        public static func topBottomPins(_ top: Pin?, _ bottom: Pin?) -> Y {
            return Y(top: top, bottom: bottom, center: nil)
        }
        
        public static let tb = topBottom
        
        public static let yPins = topBottomPins
    }
}
