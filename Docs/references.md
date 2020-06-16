
## BoxView - Login view example


```swift
var boxItem = BoxItem(view: someView, layout: BoxLayout.zero)
var boxView = BoxView()
boxView.items = [boxItem]
```

#### Creating an item
Creating items and layouts with constructors takes too much coding. So 
for easy BoxItem creation some vars and methods are added in UIView extension.
E.g.  
```swift
var boxItem: BoxItem 
boxItem = view.boxZero
```
creates an item with "zero" layout - the paddings from all 4 sides are zero. So to add zero-padding view to boxView we can write simply:
```swift
boxView.items = [view.boxZero]
```
There are also methods like boxLeft(), boxTop(), boxLeftRight() and so on. For example code

```swift
view.boxLeft(20.0) 
```
creates an item with 20 pt padding from left and zero paddings from other 3 sides.
The struct BoxItem  also has exactly same list of methods, so they can be chained, for example:
```swift
view.boxLeft(20.0).boxTop(30.0) 
```
creates an item with 20 pt padding from left, 30 pt from top and zero paddings from other 2 sides.

BoxView also has **insets** and **spacing** properties, they work exactly as in UIStackView.
So take into account that all paddings are summed up with corresponding boxView.insets values, for example
actual left padding of a view added with view.boxLeft(20.0) is 20 + boxView.insets.left\
Likewise, actual distance between two views in vertical stack is:\
**first item bottom padding  + spacing + second item top padding**


It is also possible to specify relation for each padding. In fact an argument of methods like boxLeft()
is of type BoxLayout.Pin and using its constructor we should write it as:
```swift
view.boxLeft(BoxLayout.Pin(value: 20.0, relation: .equal))
```
But it is too long, so prefix operators <=, ==, >= are defined, and same pin can be created, as ==20.0 so we can write
```swift
view.boxLeft(==20.0) 
```
also BoxLayout.Pin conforms to ExpressibleByFloatLiteral protocol, so we can omit opreator for equal relation
```swift
view.boxLeft(20.0) 
```
But for inequal realtions or using CGFloat variable to set padding we can't omit operator and have to write:
```swift
let someValue = 30.0
view.boxLeft(>=20.0).boxTop(==someValue)
```





Let's create typical login view as an example step by step.

###  Step 1: Add some views with zero padding.

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



###  Step 2: Add padding to item.

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


###  Step 3: Add more paddings to item.
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


###  Step 4: Add layout with relation.

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


###  Step 5: Add layout with alignment.
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


### Step 6: Add child boxViews with horizontal box axis.
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


