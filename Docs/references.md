
## BoxView: advanced

#### Subviews, Items and Managed Constraints

The **items** variable is an Array of BoxItems and it is main part of the BoxView. 
```swift
public var items:[BoxItem] = [] {
    didSet {
        updateItems()
    }
}
```
When  it is assigned or changed, all items views are added to the BoxView as subviews. All these views are accessible as:
```swift 
var managedViews: [UIView]
```
When managed subview is removed from the superview, corresponding item is also removed, and vice verse: when the item is removed, its view is also removed from subviews, so items and managed subviews are always synchronized. 
Following methods also can be used to add items:
```swift

// setting items and returning self, it method can be used to add nested boxViews and their items in same code block. 
public func withItems(_ items:[BoxItem]) -> Self {

// setting items from array of views using same layout
public func setViews(_ views: [UIView], layout: BoxLayout = .zero) {

// appending item
public func addItem(_ item: BoxItem)

// inserting item after item with given view, if view is nil, then item inserted at index 0
public func insertItem(_ item: BoxItem, after view: UIView?) 
```
When items or managed views added to the BoxView they are added to superview immediately, but constraints are not created at this stage. Constraints creation occurs when **updateConstraints** method of the BoxView is called in standard layouting  cycle. Yet it is possible to call this method explicitly to force BoxView create constraints.
Created constraints can be accessed as: 
```swift
// array of all automatically created by BoxView constraints
public private(set) var managedConstraints: [NSLayoutConstraint]
```
All constraints created and managed by BoxView remain until any of layout affecting properties: **Items, insets, spacing or axix** is changed, after that all managed constraints are recreated in subsequent **updateConstraints** method call.

#### RTL languages
There are no leading and trailing edges in BoxLayout. RTL behavior is defined by semanticContentAttribute for the whole boxView.
```swift
// subviews managed by BoxView are flipped from for RTL languages
boxView.semanticContentAttribute = .unspecified

// subviews managed by BoxView are in left to right order for all languages
boxView.semanticContentAttribute = .forceLeftToRight
```

#### Using BoxItems with regular UIViews or UILayoutGuides
BoxItems also can be added to any UIView with method:
```swift
addBoxItems(_ items: [BoxItem], axis: BoxLayout.Axis = .y, spacing: CGFloat = 0.0) -> [NSLayoutConstraint] 
```
This method can be used, for example, for adding items to some specific view, like UIViewController view, or UIScrollview, or UITableViewCell contentView. 

It is also possible to add items to NSLayoutGuide (views of items should be manually added to the superview in this case). It is useful, for example, to constraint views to UIViewController's view safe area:

```swift
view.addSubview(someView)
view.safeAreaLayoutGuide.addBoxItems([someView.boxed]) 
```
#### Not managed views
If subview is added to BoxView with regular **addSubview()** method, then no constraints for it are created by BoxView and it is not added to **managedViews**. Sometimes it may be useful, for example, we can use BoxView with stack of some managed views, and then add another view to show it above managed views. But constraints for this view have to be added manually. 

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
in this case the label has offset 50% of height from the top because invisible UILayoutGuide takes 50% of heeight.

Both views and guide items can have absolute and relative width and height constraints:

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
It is possible to specify priority for any constraint created by BoxView. Priority should be specified for pin using method **withPriority()** or corresponding method for default priorities, e.g. **high()** for .defaultHigh etc.
```swift
boxView.items = [
    label1.boxed.width((==100.0).high(5.0)) // .defaultHigh + 5.0
    label2.boxed.height((==30.0).withPriority(.defaultLow))
]
```

### Other constraint creation methods

There are some additional methods to create constraints without using BoxItems. They may be helpful to add additional costraints which doesn't suit BoxView layout. They also use BoxLayout.Pin struct to provide constraint parameters.

```swift
    // to place view2 20pt below view1
    view2.pin(.top, to: .bottom, of: view1, offset: 20.0)
    
    // to make view2 100pt wider than view1
    view2.pinWidth(to: view1, offset: 100.0)
```
### Content Hugging/Compession resistance priority helpers

Following variables of type `UILayoutPriority` are added to UIView as extension:
`resistanceX, resistanceY, huggingX, huggingY`.
These variables just wrap standard prioryty funtions like `contentHuggingPriority(...)` to make they usage easier. For example, this code sets horizontal contentHuggingPriority of view to .defaultLow:
```swift
view.huggingX = .defaultLow
```

