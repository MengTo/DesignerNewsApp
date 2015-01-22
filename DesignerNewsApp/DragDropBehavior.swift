//
//  DragDropBehavior.swift
//  DesignerNewsApp
//
//  Created by James Tang on 22/1/15.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit
import Spring

@objc public protocol DragDropBehaviorDelegate : class {
    func dragDropBehavior(behavior: DragDropBehavior, viewDidDrop view:UIView)
}

public class DragDropBehavior : NSObject {

    @IBOutlet public var referenceView : UIView! {
        didSet {
            if let referenceView = referenceView {
                animator = UIDynamicAnimator(referenceView: referenceView)
            }
        }
    }
    @IBOutlet public var targetView : UIView! {
        didSet {
            if let targetView = targetView {
                self.panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handleGesture:")
                targetView.addGestureRecognizer(self.panGestureRecognizer)
            }
        }
    }
    @IBOutlet public weak var delegate : NSObject? // Should really be DragDropBehaviorDelegate but to workaround forming connection issue with protocols

    // MARK: UIDynamicAnimator
    private var animator : UIDynamicAnimator!
    private var attachmentBehavior : UIAttachmentBehavior!
    private var gravityBehaviour : UIGravityBehavior!
    private var snapBehavior : UISnapBehavior!
    public private(set) var panGestureRecognizer : UIPanGestureRecognizer!

    func handleGesture(sender: AnyObject) {
        let location = sender.locationInView(referenceView)
        let boxLocation = sender.locationInView(targetView)

        if sender.state == UIGestureRecognizerState.Began {
            animator.removeBehavior(snapBehavior)

            let centerOffset = UIOffsetMake(boxLocation.x - CGRectGetMidX(targetView.bounds), boxLocation.y - CGRectGetMidY(targetView.bounds));
            attachmentBehavior = UIAttachmentBehavior(item: targetView, offsetFromCenter: centerOffset, attachedToAnchor: location)
            attachmentBehavior.frequency = 0

            animator.addBehavior(attachmentBehavior)
        }
        else if sender.state == UIGestureRecognizerState.Changed {
            attachmentBehavior.anchorPoint = location
        }
        else if sender.state == UIGestureRecognizerState.Ended {
            animator.removeBehavior(attachmentBehavior)

            snapBehavior = UISnapBehavior(item: targetView, snapToPoint: referenceView.center)
            animator.addBehavior(snapBehavior)

            let translation = sender.translationInView(referenceView)
            if translation.y > 100 {
                animator.removeAllBehaviors()

                var gravity = UIGravityBehavior(items: [targetView])
                gravity.gravityDirection = CGVectorMake(0, 10)
                animator.addBehavior(gravity)

                delay(0.3) { [weak self] in
                    if let strongSelf = self {
                        (strongSelf.delegate as? DragDropBehaviorDelegate)?.dragDropBehavior(strongSelf, viewDidDrop: strongSelf.targetView)
                    }
                }
            }
        }
    }
}
