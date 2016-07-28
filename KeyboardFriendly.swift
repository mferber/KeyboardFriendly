//
//  KeyboardFriendly.swift
//  AKCLink
//
//  Created by Matthias Ferber on 7/27/16.
//  Copyright © 2016 Cantina. All rights reserved.
//

import UIKit


/**
 * Helper to allow views to scroll out of the way to make room for the keyboard, with minimal boilerplate
 * code.
 *
 * To use in any UIViewController, include this extension in the project, then for each controller
 * where you want this behavior, do the following:
 *
 * 1. Make sure the view is wrapped in a top-level UIScrollView.
 *
 * 2. Override computed `var keyboardFriendlyScrollView: UIScrollView?` to return that scroll view.  If
 *    this var returns `nil` (the default), keyboard-friendliness will be turned off.
 *
 * 3. In `viewDidLoad`, call `self.activateKeyboardFriendliness()`.
 *
 * 4. In `deinit`, call `self.deactivateKeyboardFriendliness()`.  (Alternatively, depending on the needs of
 *    the controller, put the activate and deactivate calls in `viewDidAppear` and `viewDidDisappear`,
 *    respectively.)
 *
 * 5. (optional) If you want to auto-scroll the view to show the field being edited, then override computed
 *    `var keyboardFriendlyKeepOnscreen: CGRect` to return the rect area of the current field.  Return
 *    `CGRect.zero` (a.k.a. `CGRectZero`) for no auto-scrolling.*
 *
 *    A basic implementation is to track the bounds of the first responder in a concrete instance variable,
 *    and have `keyboardFriendlyKeepOnscreen` return that variable's value:
 *
 *    ```
 *    var firstResponderBounds: CGRect?
 *    override var keyboardFriendlyKeepOnscreen: CGRect { return self.firstResponderBounds ?? CGRect.zero }
 *    ```
 *
 * Note that the rect must be in the scroll view's coordinate system!
 *
 * *Why use `CGRect.zero` to mean "no scrolling" instead of returning an optional?  Current Swift limitations
 * (2.2): declarations in an extension can only be overridden in the main class if they're marked `@objc`,
 * but the `CGRect?` type can't be represented in Objective-C code.
 */
extension UIViewController {


    @objc var keyboardFriendlyScrollView: UIScrollView? {
        get {
            return nil
        }
    }


    @objc var keyboardFriendlyKeepOnscreen: CGRect {
        get {
            return CGRect.zero
        }
    }


    func activateKeyboardFriendliness() {
        guard self.keyboardFriendlyScrollView != nil else { return }

        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(keyboardFriendlyScrollUp(_:)),
            name: UIKeyboardDidShowNotification,
            object: nil
        )
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(keyboardFriendlyScrollBack(_:)),
            name: UIKeyboardWillHideNotification,
            object: nil
        )
    }


    func deactivateKeyboardFriendliness() {
        guard self.keyboardFriendlyScrollView != nil else { return }

        NSNotificationCenter.defaultCenter().removeObserver(
            self,
            name: UIKeyboardDidShowNotification,
            object: nil
        )
        NSNotificationCenter.defaultCenter().removeObserver(
            self,
            name: UIKeyboardWillHideNotification,
            object: nil
        )
    }


    @objc func keyboardFriendlyScrollUp(notification: NSNotification) {
        guard let scrollView = self.keyboardFriendlyScrollView,
            let userInfo = notification.userInfo,
            let endSize = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue()
            else { return }

        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: endSize.height, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets

        let rect = self.keyboardFriendlyKeepOnscreen
        if rect != CGRect.zero {
            scrollView.scrollRectToVisible(rect, animated: true)
        }
    }


    @objc func keyboardFriendlyScrollBack(notification: NSNotification) {
        guard let scrollView = self.keyboardFriendlyScrollView else { return }

        scrollView.contentInset = UIEdgeInsetsZero
        scrollView.scrollIndicatorInsets = UIEdgeInsetsZero
    }

}
