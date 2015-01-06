//
//  LoginViewController.swift
//  DesignerNewsApp
//
//  Created by Meng To on 2015-01-06.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var dialogView: SpringView!
    @IBOutlet weak var signupButton: SpringButton!
    
    @IBAction func signupButtonPressed(sender: AnyObject) {
        dialogView.resetAll()
        dialogView.animation = "shake"
        dialogView.animate()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        view.endEditing(true)
    }
}
