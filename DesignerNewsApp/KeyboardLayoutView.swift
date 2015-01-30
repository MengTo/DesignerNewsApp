//
//  KeyboardLayoutView.swift
//  DesignerNewsApp
//
//  Created by James Tang on 30/1/15.
//  Copyright (c) 2015 James Tang. All rights reserved.
//

// Keyboard growing

import UIKit

@IBDesignable class KeyboardLayoutView : UIView {

    private var keyboardVisibleHeight : CGFloat = 0

    override func awakeFromNib() {
        super.awakeFromNib()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShowNotification:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHideNotification:", name: UIKeyboardWillHideNotification, object: nil)
    }

    override func prepareForInterfaceBuilder() {
        let imageView = UIImageView(frame: self.bounds)
        imageView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
        imageView.image = UIImage(named: "keyboard", inBundle: NSBundle(forClass: self.dynamicType), compatibleWithTraitCollection: nil)
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.setTranslatesAutoresizingMaskIntoConstraints(true)
        self.addSubview(imageView)
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    // MARK: Notification

    func keyboardWillShowNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let frameValue = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                let frame = frameValue.CGRectValue()
                keyboardVisibleHeight = frame.size.height
            }

            switch (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber, userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber) {
            case let (.Some(duration), .Some(curve)):

                let options = UIViewAnimationOptions(curve.unsignedLongValue)

                UIView.animateWithDuration(
                    NSTimeInterval(duration.doubleValue),
                    delay: 0,
                    options: options,
                    animations: {
                        self.invalidateIntrinsicContentSize()
                        self.superview?.layoutIfNeeded()
                    }, completion: { finished in
                })

                break
            default:
                self.invalidateIntrinsicContentSize()
            }

        }

    }

    func keyboardWillHideNotification(notification: NSNotification) {
        keyboardVisibleHeight = 0

        if let userInfo = notification.userInfo {

            switch (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber, userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber) {
            case let (.Some(duration), .Some(curve)):

                let options = UIViewAnimationOptions(curve.unsignedLongValue)

                UIView.animateWithDuration(
                    NSTimeInterval(duration.doubleValue),
                    delay: 0,
                    options: options,
                    animations: {
                        self.invalidateIntrinsicContentSize()
                        self.superview?.layoutIfNeeded()
                    }, completion: { finished in
                })

                break
            default:
                self.invalidateIntrinsicContentSize()
            }
        } else {
            self.invalidateIntrinsicContentSize()
        }
        
    }
    
    override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(1, keyboardVisibleHeight)
    }
    
}