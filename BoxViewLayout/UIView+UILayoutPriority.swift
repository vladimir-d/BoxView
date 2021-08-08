//
//  UIView+UILayoutPriority.swift
//  BoxViewExample
//
//  Created by Vlad on 06.08.2021.
//  Copyright © 2021 Vlad. All rights reserved.
//

import UIKit

extension UIView {
    
    public var huggingX: UILayoutPriority {
        get { contentHuggingPriority(for: .horizontal)}
        set { setContentHuggingPriority(newValue, for: .horizontal) }
    }
    
    public var huggingY: UILayoutPriority {
        get { contentHuggingPriority(for: .vertical)}
        set { setContentHuggingPriority(newValue, for: .vertical) }
    }
    
    public var resistanceX: UILayoutPriority {
        get { contentCompressionResistancePriority(for: .horizontal)}
        set { setContentCompressionResistancePriority(newValue, for: .horizontal) }
    }
    
    public var resistanceY: UILayoutPriority {
        get { contentCompressionResistancePriority(for: .vertical)}
        set { setContentCompressionResistancePriority(newValue, for: .vertical) }
    }
}



