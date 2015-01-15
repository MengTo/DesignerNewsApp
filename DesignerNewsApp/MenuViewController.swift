//
//  MenuViewController.swift
//  DesignerNewsApp
//
//  Created by Meng To on 2015-01-12.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit

protocol MenuViewControllerDelegate: class {
    func topButtonPressed()
    func recentButtonPressed()
    func logoutButtonPressed()
    func loginCompleted()
}

class MenuViewController: UIViewController, LoginViewControllerDelegate {
    
    weak var delegate: MenuViewControllerDelegate?
    var token = getToken()
    @IBOutlet weak var dialogView: SpringView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var recentLabel: UILabel!
    @IBOutlet weak var creditsLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if token.isEmpty {
            loginLabel.text = "Login"
        }
        else {
            loginLabel.text = "Logout"
        }
        
        dialogView.alpha = 0
    }
    
    var firstTime = true
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if firstTime {
            dialogView.animate()
            
            firstTime = false
        }
    }
    
    // MARK: Buttons
    @IBAction func topButtonPressed(sender: AnyObject) {
        animateView()
        delegate?.topButtonPressed()
        closeButtonPressed(self)
    }
    
    @IBAction func recentButtonPressed(sender: AnyObject) {
        animateView()
        delegate?.recentButtonPressed()
        closeButtonPressed(self)
    }
    
    @IBAction func creditsButtonPressed(sender: AnyObject) {
        animateView()
    }
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        animateView()
        
        if token.isEmpty {
            performSegueWithIdentifier("LoginSegue", sender: self)
        }
        else {
            delegate?.logoutButtonPressed()
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func closeButtonPressed(sender: AnyObject) {
        dialogView.animation = "fall"
        dialogView.animateNext {
            self.dismissViewControllerAnimated(false, completion: nil)
        }
    }
    
    // MARK: LoginViewControllerDelegate
    func loginCompleted() {
        dismissViewControllerAnimated(true, completion: nil)
        delegate?.loginCompleted()
    }
    
    // MARK: Misc
    func animateView() {
        dialogView.animation = "pop"
        dialogView.animate()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "LoginSegue" {
            let loginViewController = segue.destinationViewController as LoginViewController
            loginViewController.delegate = self
        }
    }
}