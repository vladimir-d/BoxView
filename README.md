
## Let me create autolayout constraints for you!

# BoxView
BoxView is a container view that can layout own subviews.
It is similar to UIStackView, but works differently
## Features
- Pure swift code
- Effective autolayout with minimum code
- Easy layout changes, adding, removing and reordering views.
- Not conflicting with view hierarchy managment 
- 100% compatibility with any other autolayout code
- Supports animation

## Usage

### Basics
BoxView allows create complex dynamic layout in code with minimum efforts.
It takes all constraints boilerplate on oneself, so your code became much shorter and readible.
It doesn't change views or existing constraints, it only creates specified group of constraints

Let's take typical login view as an example.

#### Most simple example: No items layout.

![login1 image](https://github.com/vladimir-d/BoxView/blob/master/Docs/Images/login1.png?raw=true)

We can make this layout using the BoxView with the following code:
```
boxView.insets = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
boxView.spacing = 20.0
boxView.items = [
   nameField.boxZero,
   passwordField.boxZero,
   loginButton.boxZero
]
```
**boxView.insets** are insets of boxView content from all four sides. 
**boxView.spacing** is spacing between item views.
And **BoxView** managed subviews have no additional padding in this case.
Each **BoxView** item is of type **BoxItem**, it contains corresponding view and layout information.
The ltem with zero padding layout is created with **view.boxZero**



####  Example 2: Add padding to item.

![login1 image](https://github.com/vladimir-d/BoxView/blob/master/Docs/Images/login2.png?raw=true)

For example we need to increase the spacing between the password field and the button to 50 pixels.
We already have spacing 20 pixels between all views , so we need additional padding of 30 pixels.
Method **boxTop(30.0)** creates item with specified padding from top
```
boxView.insets = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
boxView.spacing = 20.0
boxView.items = [
    nameField.boxZero,
    passwordField.boxZero,
    loginButton.boxTop(30.0)
]
```


####  Example 3: Add more paddings to item.
![login1 image](https://github.com/vladimir-d/BoxView/blob/master/Docs/Images/login3.png?raw=true)`

Now let's add padding 50 pixels from left and right sides.
We can do it by adding **boxLeft(50.0)** and **BoxRight(50.0)**:
```
...
loginButton.boxTop(30.0).boxLeft(50.0).Right(50.0, 50.0)
```
or **boxLeftRight(50.0, 50.0)**

```
boxView.items = [
    nameField.boxZero,
    passwordField.boxZero,
    loginButton.boxTop(30.0).boxLeftRight(50.0, 50.0)
]
```


####  Example 4: Add layout with relation.

![login1 image](https://github.com/vladimir-d/BoxView/blob/master/Docs/Images/login4.png?raw=true)`

Next step is adding another view - the button with "Forgot password?" title.
If we need to place it at the right side we have to use left constraint with **greaterThenOrEqual** relation.
All items padding can be created with relation using same methods.
Actually **boxLeft()** is defined as
```
func boxLeft(_ leftPin: BoxLayout.Pin?) -> BoxItem
```
 its argument is of type **BoxLayout.Pin** and consist of two vars:
**value** and **relation**
So we can create  the Pin with **greaterThenOrEqual** relation on the left side of  the forgotButton 
with code: 
```
BoxLayout.Pin(value: 50.0, relation: .greaterThanOrEqual)
```
but it is too long, so operators **==, >=, <=** are implemented for more concise syntaxis.
E.g. **==50.0** creates Pin with equal relation, but we can wright simply 
**boxLeft(50.0)** instead of **boxLeft(==50.0)**  because BoxLayout.Pin conforms to 
**ExpressibleByFloatLiteral** protocol.
For the Pin with **greaterThenOrEqual** relation we have to write it in full form:
**boxLeft(>=0.0)** so finally our layouting code is:
 
```
boxView.items = [
    nameField.boxZero,
    passwordField.boxZero,
    forgotButton.boxLeftRight(>=0.0, 0.0)
    loginButton.boxTop(30.0).boxLeftRight(50.0, 50.0)
]
```
Perhaps we need to make the forgotButton optional, depending on some condition.
To do so we can add optional value to array and then filter it with compactMap method.

```swift
let useForgotButton = true //change it to false to remove forgotButton
...
boxView.items = [
    nameField.boxZero,
    passwordField.boxZero,
    useForgotButton ? forgotButton.boxLeftRight(>=0.0, 0.0) : nil,
    loginButton.boxTop(30.0).boxLeftRight(50.0, 50.0)
].compactMap{$0}
```
another option is simply to add items one by one:

```swift
boxView.insets = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
boxView.spacing = 20.0
boxView.items = []
boxView.items.append(nameField.boxZero)
boxView.items.append(passwordField.boxZero)
if (useForgotButton) {
    boxView.items.append(forgotButton.boxLeftRight(>=0.0, 0.0))
}
boxView.items.append(loginButton.boxTop(30.0).boxLeftRight(50.0, 50.0))
```


####  Example 5: Add layout with alignment.
![login1 image](https://github.com/vladimir-d/BoxView/blob/master/Docs/Images/login5.png?raw=true)`

Now let's add title label aligned to center.  Method **xAligned()** creates item layouted centrally along X-axis.
```
boxView.items = [
    titleLabel.xAligned(),
    nameField.boxZero,
    passwordField.boxZero,
    useForgotButton ? forgotButton.boxLeftRight(>=0.0, 0.0) : nil,
    loginButton.boxTop(30.0).boxLeftRight(50.0, 50.0)
].compactMap{$0}
```


####  Example 6: Add child boxViews with horizontal box axis.
![login1 image](https://github.com/vladimir-d/BoxView/blob/master/Docs/Images/login6.png?raw=true)`

All items in previous examples were stacked along Y-axis. What if we need also add some items placed along X-axis?
We can do it by adding nested boxViews with x-axes. For example let's add icons on the left of the name and the password text fields. 

```
let nameBoxView = BoxView(axis: .x, spacing: 10.0)
nameBoxView.items = [nameImageView.yAligned(), nameField.boxZero]
let passwordBoxView = BoxView(axis: .x, spacing: 10.0)
passwordBoxView.items = [passwordImageView.yAligned(), passwordField.boxZero]

boxView.items = [
    titleLabel.xAligned(),
    nameBoxView.boxZero,
    passwordBoxView.boxZero,
    useForgotButton ? forgotButton.boxLeftRight(>=0.0, 0.0) : nil,
    loginButton.boxTop(30.0).boxLeftRight(50.0, 50.0)
].compactMap{$0}
```

### BoxView and UIStackView
Like UIStackView the BoxView also layouting its subviews, but there are some differences:
1. BoxView never changes size constraints of own subviews. 
2. BoxView creates specified layout to each subview, while UIStackView use same layout for all subviews in stack.
3. Box is normal rendering view, it may have background color and layer properties.

UIStackView is used to automatically distribute subviews.
BoxView is used to create layout with specified insets or alignment for each view.
Yet is some simplest cases they are interchangable.
UIStackView can be nested in BoxView and vice verse.

## Topics
### Adding items to view

### Creating an item


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
