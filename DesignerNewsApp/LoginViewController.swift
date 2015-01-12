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
    
    @IBAction func signupButtonPressed(sender: AnyObject) {
        showLoading(view)
        
        postLogin(emailTextField.text, passwordTextField.text) { (json) -> () in
            hideLoading()
            
            if let token = json?["access_token"] as? String {
                saveToken(token)
                
                self.dialogView.animation = "zoomOut"
                self.dialogView.animate()
                delay(0.2, {
                    self.dismissViewControllerAnimated(true, completion: nil)
                    UIApplication.sharedApplication().sendAction("reset:", to: nil, from: self, forEvent: nil)
                    self.delegate?.loginCompleted()
                })
            }
            else {
                self.dialogView.animation = "shake"
                self.dialogView.animate()
            }
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        spring(0.7) {
            self.view.center.y = self.originalCenter.y - textField.center.y
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        spring(0.7) {
            self.view.center = self.originalCenter
        }
    }
    
    @IBAction func closeButtonPressed(sender: AnyObject) {
        dialogView.animation = "zoomOut"
        dialogView.animateNext({
            self.dismissViewControllerAnimated(false, completion: nil)
        })
        spring(0.7, {
            self.view.alpha = 0
        })
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalCenter = view.center
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        dialogView.alpha = 0
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        dialogView.animate()
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
    }
}
