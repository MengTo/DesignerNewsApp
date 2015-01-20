//
//  MenuViewController.swift
//  DesignerNewsApp
//
//  Created by Meng To on 2015-01-12.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit
import Spring

protocol MenuViewControllerDelegate : NSObjectProtocol {
    func menuViewControllerDidSelectTopStories(controller:MenuViewController)
    func menuViewControllerDidSelectRecent(controller:MenuViewController)
    func menuViewControllerDidSelectLogout(controller:MenuViewController)
    func menuViewControllerDidLogin(controller:MenuViewController)
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
        delegate?.menuViewControllerDidSelectTopStories(self)
        closeButtonPressed(self)
    }
    
    @IBAction func recentButtonPressed(sender: AnyObject) {
        animateView()
        delegate?.menuViewControllerDidSelectRecent(self)
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
            delegate?.menuViewControllerDidLogin(self)
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
    func loginViewControllerDidLogin(controller: LoginViewController) {
        loginCompleted()
    }

    // MARK: Misc
    func loginCompleted() {
        dismissViewControllerAnimated(true, completion: nil)
        delegate?.menuViewControllerDidLogin(self)
    }

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