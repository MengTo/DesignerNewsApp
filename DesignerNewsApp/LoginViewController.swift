//
//  LoginViewController.swift
//  DesignerNewsApp
//
//  Created by Meng To on 2015-01-06.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit
import Spring
import DesignerNewsKit

protocol LoginViewControllerDelegate : class {
    func loginViewControllerDidLogin(controller:LoginViewController)
}

class LoginViewController: UIViewController, UITextFieldDelegate, DragDropBehaviorDelegate {

    @IBOutlet weak var passwordImageView: SpringImageView!
    @IBOutlet weak var emailImageView: SpringImageView!
    @IBOutlet weak var dialogView: SpringView!
    @IBOutlet weak var signupButton: SpringButton!
    @IBOutlet weak var emailTextField: DesignableTextField!
    @IBOutlet weak var passwordTextField: DesignableTextField!
    var originalCenter: CGPoint!
    weak var delegate: LoginViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalCenter = view.center
        
        emailTextField.delegate = self
        passwordTextField.delegate = self

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        dialogView.animate()
    }
    
    // MARK: Button
    @IBAction func signupButtonPressed(sender: AnyObject) {
        view.showLoading()
        DesignerNewsService.loginWithEmail(emailTextField.text, password: passwordTextField.text) { token in
            self.view.hideLoading()
            if let token = token {
                LocalStore.setAccessToken(token)
                self.dialogView.animation = "zoomOut"
                self.dialogView.animate()
                self.dismissViewControllerAnimated(true, completion: nil)
                UIApplication.sharedApplication().sendAction("reset:", to: nil, from: self, forEvent: nil)
                self.delegate?.loginViewControllerDidLogin(self)
            } else {
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
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == emailTextField {
            emailImageView.image = UIImage(named: "icon-mail-active")
            emailImageView.animate()
        }
        else {
            emailImageView.image = UIImage(named: "icon-mail")
        }
        
        if textField == passwordTextField {
            passwordImageView.image = UIImage(named: "icon-password-active")
            passwordImageView.animate()
        }
        else {
            passwordImageView.image = UIImage(named: "icon-password")
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        emailImageView.image = UIImage(named: "icon-mail")
        passwordImageView.image = UIImage(named: "icon-password")
    }

    func dragDropBehavior(behavior: DragDropBehavior, viewDidDrop view: UIView) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
