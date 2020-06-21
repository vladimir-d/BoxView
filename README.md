
### *Let me create autolayout constraints for you!*

# BoxView
The BoxView is a container UIView that can layout own subviews.
It is similar to the UIStackView, but uses different approach: it allows to set an individual layout for each subview, rather than automatically distribute them.
BoxView takes all constraints creation boilerplate on oneself, so the code becames much shorter and readable.
It easy to create complex dynamic layout in code based only on BoxViews, as well as use them with other autolayout methods.
BoxView doesn't change views or existing constraints, it only creates specified group of constraints, so it doesn't conflict with anything.

## Features
- Pure swift 5 library
- Short and readable code even for complex layout
- Easy layout changes, adding, removing and reordering views
- 100% compatibility with any other autolayout code
- Supports animation

## Examples

![login6 image](https://github.com/vladimir-d/BoxView/blob/master/Docs/Images/login6.png?raw=true)

We need only few lines of code to create this layout with BoxView:
```
nameBoxView.items = [nameImageView.yAligned(), nameField.boxZero]
passwordBoxView.items = [passwordImageView.yAligned(), passwordField.boxZero]
boxView.insets = .all(16.0)
boxView.spacing = 20.0
boxView.items = [
    titleLabel.xAligned(padding: 30.0).boxBottom(20.0),
    nameBoxView.boxZero,
    passwordBoxView.boxZero,
    forgotButton.boxLeft(>=0.0),
    loginButton.boxTop(30.0).boxLeftRight(50.0, 50.0)
]
```
Full examples code is available in BoxViewExample project, and also there is a [step-by-step tutorial for login example](https://github.com/vladimir-d/BoxView/blob/master/Docs/login.md) in Docs folder.

It is very easy to add/remove views, or to change any view padding without affecting other views in layout.
And these changes optionally can be animated. For example, we can add empty fields validation and show error label below empty field, leaving existing layout code unchanged!

![login1 image](https://github.com/vladimir-d/BoxView/blob/master/Docs/Images/login7.gif?raw=true)

Another example with layout created only on BoxViews. It shows axis and spacing animation, and using size constraints with BoxView. 
![album image](https://github.com/vladimir-d/BoxView/blob/master/Docs/Images/album.gif?raw=true)

## Basic usage

The BoxView uses **items** array to arrange its subviews. Each item is of type **BoxItem**, and it encapsulates the view together with the layout information. So to layout some views using BoxView we have to create BoxItem from each view and add these items to BoxView. 

####  Creating boxItems
There are some methods implemented in BoxItem and in UIView extension to create BoxItems for most common layouts. For example:

```swift
// creates a BoxItem with zero paddings from all 4 sides
view.boxZero

// creates an item with 20 pt padding from left and zero paddings from other 3 sides.
view.boxLeft(20.0)

// creates an item with 10 pt padding from top, 20 pt from bottom and zero paddings from other 2 sides.
view.boxTopBottom(10.0, 20.0) 

// creates an item aligned along X-axis, with padding >= 30 pt from left and right sides, top and bottom padding are zero
view.xAligned(padding: 30.0)
```

Note, that actual view offsets for all paddings are calculated counting boxView.insets and boxView.spacing properties as it is shown on scheme:

![BoxView layout scheme image](https://github.com/vladimir-d/BoxView/blob/master/Docs/Images/boxLayout.png?raw=true)

It may look complicated, but all these values are zero by default, so only explicitly set values are contributing in actual paddings.  

BoxItem creation methods can be chained:

```swift
// creates an item with 20 pt padding from left, 30 pt from top and zero paddings from other 2 sides. 
view.boxLeft(20.0).boxTop(30.0) 

// creates an item with 20 pt padding from left zero padding from right and aligned along Y-axis, with padding >= 0.0 from top and bottom
view.boxLeft(20.0).yAligned()
```
Each padding can be specified with relation using operator ">=" for greaterThanOrEqual relation and operator "<=" for lessThanOrEqual relation. Equal relation is default, so operator "==" is usually not used.
```swift
// creates an item with padding greater than or equal 20 pt from left,
// padding less than or equal  30 pt from top and zero paddings from other 2 sides. 
view.boxLeft(>=20.0).boxTop(<=30.0)
```

####  Managing BoxView items

Items can be added, inserted or removed at any moment:
```swift
// initialize boxView.items with two items 
boxView.items = [view1.boxZero, view2.boxLeft(10.0)]

//remove view2 (when subview is removed from boxView corresponding item is also removed)
view2.removeFromSuperview()

//add view3 
boxView.items.append(view3.xAligned())

//insert view2 between view1 and view3 
boxView.insertItem(view2.boxRight(10.0), after: view1)
```
### Advanced usage and references
 [More details about BoxView usage](https://github.com/vladimir-d/BoxView/blob/master/Docs/references.md) in Docs folder.

## Requirements

iOS 9 or later

## Installation

### CocoaPods

BoxView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
use_frameworks!

target 'YourTarget' do
  pod 'BoxView', :git => 'https://github.com/vladimir-d/BoxView.git'
end

```


## Author

Vladimir Dudkin, vlad.dudkin@gmail.com

## License

[MIT]: http://www.opensource.org/licenses/mit-license.php

BoxView is available under the [MIT license][MIT]. See the LICENSE file for more info.
