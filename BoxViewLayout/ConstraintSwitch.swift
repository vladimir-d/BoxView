//
//  ConstraintSwitch.swift
//  BoxViewExample
//
//  Created by Vlad on 6/27/20.
//  Copyright © 2020 Vlad. All rights reserved.
//

import UIKit

open class ConstraintSwitch {
    
    typealias Handler = () -> Void
    
    var state: Bool {
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
    
    var stateChangeHandler: Handler?

    init() {
        state = false
    }
    
    init(state:Bool = false, onSet: [NSLayoutConstraint?] = [], offSet: [NSLayoutConstraint?] = []) {
        self.onSet = Set(onSet.compactMap { $0 })
        self.offSet = Set(offSet.compactMap { $0 })
        self.state = state
    }
}


