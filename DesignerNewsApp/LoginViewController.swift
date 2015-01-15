//
//  LoginViewController.swift
//  DesignerNewsApp
//
//  Created by Meng To on 2015-01-06.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit
import CoreData

protocol LoginViewControllerDelegate {
    func loginCompleted()
}

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var dialogView: SpringView!
    @IBOutlet weak var signupButton: SpringButton!
    @IBOutlet weak var emailTextField: DesignableTextField!
    @IBOutlet weak var passwordTextField: DesignableTextField!
    var originalCenter: CGPoint!
    var delegate: LoginViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalCenter = view.center
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        animator = UIDynamicAnimator(referenceView: view)
        
        dialogView.alpha = 0
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        dialogView.animate()
    }
    
    // MARK: Button
    @IBAction func signupButtonPressed(sender: AnyObject) {
        showLoading(view)
        
        postLogin(emailTextField.text, passwordTextField.text) { (json) -> () in
            hideLoading()
            
            if let token = json?["access_token"] as? String {
                saveToken(token)
                
                self.dialogView.animation = "zoomOut"
                self.dialogView.animate()
                
                self.dismissViewControllerAnimated(true, completion: nil)
                UIApplication.sharedApplication().sendAction("reset:", to: nil, from: self, forEvent: nil)
                self.delegate?.loginCompleted()
            }
            else {
                self.dialogView.animation = "shake"
                self.dialogView.animate()
            }
        }
    }
    
    @IBAction func closeButtonPressed(sender: AnyObject) {
        dialogView.animation = "zoomOut"
        dialogView.animate()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: UITextFieldDelegate
    @IBAction func scrollViewPressed(sender: AnyObject) {
        view.endEditing(true)
    }
    
    // MARK: UIDynamicAnimator
    var animator : UIDynamicAnimator!
    var attachmentBehavior : UIAttachmentBehavior!
    var gravityBehaviour : UIGravityBehavior!
    var snapBehavior : UISnapBehavior!
    
    @IBAction func handleGesture(sender: AnyObject) {
        let myView = dialogView
        let location = sender.locationInView(view)
        let boxLocation = sender.locationInView(myView)
        
        if sender.state == UIGestureRecognizerState.Began {
            animator.removeBehavior(snapBehavior)
            
            let centerOffset = UIOffsetMake(boxLocation.x - CGRectGetMidX(myView.bounds), boxLocation.y - CGRectGetMidY(myView.bounds));
            attachmentBehavior = UIAttachmentBehavior(item: myView, offsetFromCenter: centerOffset, attachedToAnchor: location)
            attachmentBehavior.frequency = 0
            
            animator.addBehavior(attachmentBehavior)
        }
        else if sender.state == UIGestureRecognizerState.Changed {
            attachmentBehavior.anchorPoint = location
        }
        else if sender.state == UIGestureRecognizerState.Ended {
            animator.removeBehavior(attachmentBehavior)
            
            snapBehavior = UISnapBehavior(item: myView, snapToPoint: view.center)
            animator.addBehavior(snapBehavior)
            
            let translation = sender.translationInView(view)
            if translation.y > 100 {
                animator.removeAllBehaviors()
                
                var gravity = UIGravityBehavior(items: [dialogView])
                gravity.gravityDirection = CGVectorMake(0, 10)
                animator.addBehavior(gravity)
                
                delay(0.3) {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        }
    }
}
