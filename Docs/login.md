
## BoxView - Login view example

Let's create typical login view as an example step by step.

###  Step 1: Add some views with zero padding.

![login1 image](https://github.com/vladimir-d/BoxView/blob/master/Docs/Images/login1.png?raw=true)

We can make this layout using the BoxView with the following code:

```swift
// insets of boxView content from all four sides exactly like in the UIStackView
boxView.insets = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)

// spacing between item views, exactly like in the UIStackView
boxView.spacing = 20.0

// adding 3 items to BoxView, each item is of type BoxItem
// All items are created from views using 'boxZero', it produces items with zero paddings 
boxView.items = [
   nameField.boxZero,
   passwordField.boxZero,
   loginButton.boxZero
]
```
As in these example all views have no additional paddings, all distances between each view and boxView are from boxView.insets, and all distances between neighbour views are from boxView.spacing.


###  Step 2: Add padding to item.

![login1 image](https://github.com/vladimir-d/BoxView/blob/master/Docs/Images/login2.png?raw=true)

For example we need to increase the spacing between the password field and the button to 50 pt.
We already have spacing 20 pt between all views, so we need additional padding of 30 pt.
Method **boxTop(30.0)** creates item with specified padding from top
```
boxView.insets = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
boxView.spacing = 20.0
boxView.items = [
    nameField.boxZero,
    passwordField.boxZero,
    
    // loginButton has addtional 30.0 pt padding from top
    loginButton.boxTop(30.0)
]
```

These scheme shows how each item own paddings and BoxView insets and spacing propreties used to calculate layout: 

![BoxView layout scheme image](https://github.com/vladimir-d/BoxView/blob/master/Docs/Images/boxLayout.png?raw=true)

All these padding are zero by default, so we have set only those we need in our layout.

###  Step 3: Add more paddings to item.
![login1 image](https://github.com/vladimir-d/BoxView/blob/master/Docs/Images/login3.png?raw=true)

Now let's add padding 50 pt from left and right sides.
BoxItem creation methods can be chained, so we can write:

```swift
boxView.items = [
    nameField.boxZero,
    passwordField.boxZero,
    
    // loginButton has addtional 30.0 pt padding from top, and 50.0 pt from left and right
    loginButton.boxTop(30.0).boxLeftRight(50.0, 50.0)
]
```


###  Step 4: Add layout with relation.

![login1 image](https://github.com/vladimir-d/BoxView/blob/master/Docs/Images/login4.png?raw=true)

Next step is adding another view - the button with "Forgot password?" title.
If we need to place it at the right side we have to use left constraint with **greaterThenOrEqual** relation.
All items padding can be created with relation using same methods.
Operators ">=" and  "<=" are used to add constrains with greaterThanOrEqual and lessThanOrEqual relations.
 
```swift
boxView.items = [
    nameField.boxZero,
    passwordField.boxZero,
    forgotButton.boxLeft(>=0.0)
    loginButton.boxTop(30.0).boxLeftRight(50.0, 50.0)
]
```
###  Step 5: Add layout with alignment.
![login1 image](https://github.com/vladimir-d/BoxView/blob/master/Docs/Images/login5.png?raw=true)

Now let's add title label aligned to center.  Method 
```swift
func boxCenterX(offset: CGFloat = 0.0, padding: CGFloat? = 0.0)
```
creates item aligned centrally along X-axis.
In most cases, if we place view is center, we also want to keep it sides within superview bounds, so  additional paddings with **greaterThanOrEqual** relation are added from both sides. Default padding value is 0.0 so if we don't want these paddings, we have to set padding parameter to nil.
```swift
boxView.items = [
    // creates item with bottom padding 20 pt
    // it is also centered horizontally 
    // and have padding minimum 30 pt from left and right
    titleLabel.boxBottom(20.0).boxCenterX(padding: 30.0),
    nameField.boxZero,
    passwordField.boxZero,
    forgotButton.boxLeft(>=0.0),
    loginButton.boxTop(30.0).boxLeftRight(50.0, 50.0)
].compactMap{$0}
```


### Step 6: Add child boxViews with horizontal box axis.
![login1 image](https://github.com/vladimir-d/BoxView/blob/master/Docs/Images/login6.png?raw=true)

All items in previous examples were stacked along Y-axis. 
Now lets add nested boxViews with Y-axes to show icons on the left of the name and the password text fields. 
```swift
nameBoxView.items = [nameImageView.boxCenterY(), nameField.boxZero]
passwordBoxView.items = [passwordImageView.boxCenterY(), passwordField.boxZero]
boxView.insets = .all(16.0)
boxView.spacing = 20.0

boxView.items = [
titleLabel.boxBottom(20.0).boxCenterX(padding: 30.0),
    nameBoxView.boxZero,
    passwordBoxView.boxZero,
    forgotButton.boxLeft(>=0.0),
    loginButton.boxTop(30.0).boxLeftRight(50.0, 50.0)
]
```

### Step 7: Changing layout: showing error message below empty fields
![login1 image](https://github.com/vladimir-d/BoxView/blob/master/Docs/Images/login7.png?raw=true)

```swift
func showErrorForField(_ field: UITextField) {
    // setting initial frame for error label same as of textField
    errorLabel.frame = field.convert(field.bounds, to: boxView)
    
    // set layout for error label: note that we are setting negative padding to show it without spacing from textField.
    let item = errorLabel.boxTop(-boxView.spacing).boxLeft(errorLabel.frame.minX - boxView.insets.left)
    
    // inserting item after textField
    boxView.insertItem(item, after: field.superview)
    
    // sending error label back on Z-order, to hide it behind textField
    boxView.sendSubviewToBack(errorLabel)
    
    boxView.animateChangesWithDurations(0.3)
}

// checking fields for empty text, and showng error label
@objc func onClickButton(sender: UIButton) {
    for field in [nameField, passwordField] {
        if field.text?.isEmpty ?? true {
            showErrorForField(field)
            return
        }
    }
    self.navigationController?.pushViewController(PuppiesViewController(), animated: true)
}

// removing error label if user changed text
@objc func onChangeTextField(sender: UITextField) {
    errorLabel.removeFromSuperview()
    boxView.animateChangesWithDurations(0.3)
}
```


