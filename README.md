# KeyboardFriendly

An easy-reuse UIViewController extension to support making screen space for the keyboard, with minimal boilerplate code.



## Instructions

To use in any UIViewController, include this extension (`KeyboardFriendly.swift`) in your project, then in each controller where you want this behavior, do the following:

1. Make sure the view is wrapped in a top-level UIScrollView, to allow the view to be moved.

2. Override the computed property:

	`var keyboardFriendlyScrollView: UIScrollView?`
	
	to return that scroll view.  If this var returns `nil` (the default), keyboard-friendliness will not be activated.

3. In `viewDidLoad`, call `self.activateKeyboardFriendliness()`.

4. In `deinit`, call `self.deactivateKeyboardFriendliness()`.

	Alternatively, depending on the needs of the controller, put the activate and deactivate calls in `viewDidAppear` and `viewDidDisappear`, respectively.  That may be a better choice if the controller is still responding to keyboard events inappropriately while it's offscreen.

5. **Optional — To auto-scroll the view to show the field being edited:**  Override the computed property:

   `var keyboardFriendlyKeepOnscreen: CGRect`
   
   to return the rect area of the current field, or any other rect that you want to keep onscreen.  Return `CGRect.zero` (a.k.a. `CGRectZero`) to suppress auto-scrolling.<sup>1</sup>
   
   Note that the rect must be in the scroll view's coordinate system!  Use `UIView.convertRect:toView:` or `UIView.convertRect:fromView:` if necessary.

   A simple, basic implementation will track the bounds of the first responder in a concrete instance variable,
   and have `keyboardFriendlyKeepOnscreen` return that variable's value:

   ```swift
   var firstResponderBounds: CGRect?
   override var keyboardFriendlyKeepOnscreen: CGRect {
       return self.firstResponderBounds ?? CGRect.zero
   	}
   ```
   
   Use `UITextFieldDelegate` to keep track of the first responder.

-

<sup>1</sup>Why use `CGRect.zero` to mean "no scrolling" instead of returning an optional?  Current Swift limitations
(2.2): declarations in an extension can only be overridden in the main class if they're marked `@objc`,
but the `CGRect?` type can't be represented in Objective-C code.