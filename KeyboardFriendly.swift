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
 * Automatic scrolling to make sure a particular item is visible is not included, because UIScrollViews
 * automatically do that by themselves when a text control becomes the first responder, and it's very
 * difficult to disable that behavior and replace it with your own scrolling.  That contradicts Apple's
 * own documentation on how to do that, unfortunately.
 */
extension UIViewController {


    @objc var keyboardFriendlyScrollView: UIScrollView? {
        get {
            return nil
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
    }


    @objc func keyboardFriendlyScrollBack(notification: NSNotification) {
        guard let scrollView = self.keyboardFriendlyScrollView else { return }

        scrollView.contentInset = UIEdgeInsetsZero
        scrollView.scrollIndicatorInsets = UIEdgeInsetsZero
    }

}
