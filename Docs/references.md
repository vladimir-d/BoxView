
## BoxView: advanced

#### Subviews, Items and Managed Constraints

When **items** variable of BoxView is set or changed (actually it is same, because items is Array), all items views are to BoxView as subviews. All these views are accessible as:
```swift 
var managedViews: [UIView]
```
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

```

#### RTL languages
There are no leading and trailing edges in BoxLayout. RTL behavior is defined by semanticContentAttribute for whole boxView.
```swift
// subviews managed by BoxView are flipped from for RTL languages
boxView.semanticContentAttribute = .unspecified

// subviews managed by BoxView are in left to right order for all languages
boxView.semanticContentAttribute = .forceLeftToRight
```

#### Using BoxItems with regular UIViews
BoxItems also can be added to any UIView with method:
```swift
addBoxItems(_ items: [BoxItem], axis: BoxLayout.Axis = .y, spacing: CGFloat = 0.0) -> [NSLayoutConstraint] 
```
This method can be used, for example, for adding items to some specific view, like UIViewController view, or UIScrollview, or UITableViewCell contentView. 

#### Not managed views
It is also possible to add subview to BoxView with regular **addSubview()** method, in this case subview is **not** managed, and its layout is not controlled by BoxView. It is nothing bad in using not managed views, for example, we can use BoxView with stack of some managed views, and then add another view to show it above managed view. But constraints for this view have to be added manually. 

```swift
boxView.items = [
    label1.boxed,
    label2.boxed
]

boxView.addBoxItems(label3.boxed.centerX().centerY()) 
```

#### Guide items, dimension constraints and flex items
BoxItems can be created not only with views, but also with UILayoutGuides:
```swift
boxView.items = [
    // this item has no view, it is used only to take 50% of superview height
    .guide.relativeHeight(0.5),
    someLabel.boxed.bottom(>=0.0)
]
```
in this case label has offset 50% of height from top because of previous invisible item.

Both view and guide items can have absolute and relative width and height constraints:

```swift
boxView.items = [
    // invisible item with height 40 pt or more
    .guide.height(>=40.0),
    // widt of label is 20 pt + 30% of boxView width or more
    someLabel.boxed.bottom(>=0.0).relativeWidth(>=20.0*0.3)
]
```
Also it is possible to use flex layouting for views and guides:
```swift
boxView.items = [
    label1.boxed.flex(1.0)
    .guide.flex(1.0),
    label2.boxed.flex(3.0)
    // height of label1 is same as spacing between labels and height of label2 is 3 times more.
]
```

#### Priorities
It is possible to specify priority for any constraint created by BoxView. Priority should be added to corresponding pin with method **withPriority()**
```swift
boxView.items = [
    label1.boxed,
    label2.boxed.height((==30.0).withPriority(.defaultLow))
]
```

