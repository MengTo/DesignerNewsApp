//
//  LoginViewController.swift
//  DesignerNewsApp
//
//  Created by Meng To on 2015-01-06.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var dialogView: SpringView!
    @IBOutlet weak var signupButton: SpringButton!
    @IBOutlet weak var emailTextField: DesignableTextField!
    @IBOutlet weak var passwordTextField: DesignableTextField!
    var originalCenter: CGPoint!
    
    @IBAction func signupButtonPressed(sender: AnyObject) {
        dialogView.resetAll()
        dialogView.animation = "shake"
        dialogView.animate()
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
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalCenter = view.center
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
    }
}
