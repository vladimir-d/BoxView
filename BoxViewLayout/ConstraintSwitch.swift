//
//  ConstraintSwitch.swift
//  BoxViewExample
//
//  Created by Vlad on 6/27/20.
//  Copyright © 2020 Vlad. All rights reserved.
//

import UIKit

// MARK: - Public -

open class ConstraintSwitch {
    
    public typealias Handler = () -> Void
    
    public var state: Bool {
        didSet {
            if self.state {
                NSLayoutConstraint.deactivate(Array(offSet))
                NSLayoutConstraint.activate(Array(onSet))
            }
            else{
                NSLayoutConstraint.deactivate(Array(onSet))
                NSLayoutConstraint.activate(Array(offSet))
            }
            stateChangeHandler?()
        }
    }
    
    public var onSet = Set<NSLayoutConstraint>() {
        didSet {
            if self.state {
                NSLayoutConstraint.activate(Array(onSet))
            }
            else{
                NSLayoutConstraint.deactivate(Array(onSet))
            }
        }
    }
    
    public var offSet = Set<NSLayoutConstraint>() {
        didSet {
            if self.state {
                NSLayoutConstraint.deactivate(Array(offSet))
            }
            else{
                NSLayoutConstraint.activate(Array(offSet))
            }
        }
    }
    
    public var stateChangeHandler: Handler?

    public init() {
        state = false
    }
    
    public init(state:Bool = false, onSet: [NSLayoutConstraint?] = [], offSet: [NSLayoutConstraint?] = []) {
        self.onSet = Set(onSet.compactMap { $0 })
        self.offSet = Set(offSet.compactMap { $0 })
        self.state = state
    }
}


