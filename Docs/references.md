
## BoxView: advanced

#### Subviews, Items and Managed Constraints

When **items** variable of subview is set, the BoxView adds views from items to self as subviews. All these view are accessible as:
```swift
var managedViews: [UIView]
```
It is also possible to add subview to BoxView with regular **addSubview()** method, in this case subview is **not** managed, and its layout is not controlled by BoxView. 
When managed subview is removed from superview, corresponding item is also removed, and vice verse: when item removed its view is also removed from subviews, so items and managed subviews always sinchronized. 
Followin methods can be used to add items:
```swift

public var items:[BoxItem] = [] {
    didSet {
        updateItems()
    }
}

// setting items and returning self, it method can be used to add nested boxViews and their items in same code block. 
public func withItems(_ items:[BoxItem]) -> Self {

// setting items from array of views using same layout
public func setViews(_ views: [UIView], layout: BoxLayout = .zero) {

// appending item
public func addItem(_ item: BoxItem)

// inserting item after item with given view, if view is nil, then item inserted at index 0
public func insertItem(_ item: BoxItem, after view: UIView?) 
```
When items or managed views added to the BoxView they are added to superview immediately, but constraints are not created at this stage. Constraints creation occurs when **updateConstraints** method of the BoxView is called in standard layouting  cycle. Yet it is possible to call this method explicitly to force BoxView create constraints.\
Created constraints can be accessed as: 
```swift
// array of all automatically created by BoxView constraints
public private(set) var managedConstraints: [NSLayoutConstraint]

// array of automatically created by BoxView constraints grouped in dictionaries for each item
public private(set) var itemsEdgeConstraints: [BoxEdge: NSLayoutConstraint]
```

#### RTL languages
There are no leading and trailing edges in BoxLayout. RTL behavior can be changed for all managed subviews using BoxView property:
```swift
// if true, subviews managed by BoxView are flipped from left to right for RTL languages
public var isRTLDependent: Bool = true
```

#### Using BoxItems with regular UIViews
Single BoxItem can be added to any UIView with method:
```swift
public func addBoxItem(_ item: BoxItem, rtlDependent: Bool = true) -> [NSLayoutConstraint]
```
This method can be used, for example, for adding BoxView itself to some specific view, like UIViewController view, or UIScrollview, or UITableViewCell contentView.


