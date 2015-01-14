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
}

class MenuViewController: UIViewController {
    weak var delegate: MenuViewControllerDelegate?
    
    var token = getToken()
    @IBOutlet weak var dialogView: SpringView!
    
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
        performSegueWithIdentifier("LoginSegue", sender: self)
    }
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var recentLabel: UILabel!
    @IBOutlet weak var creditsLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    
    func animateView() {
        dialogView.animation = "pop"
        dialogView.animate()
    }
    
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
            dialogView.animation = "squeezeDown"
            dialogView.animate()
            firstTime = false
        }
    }
    
    @IBAction func closeButtonPressed(sender: AnyObject) {
        dialogView.animation = "fall"
        dialogView.animateNext {
            self.dismissViewControllerAnimated(false, completion: nil)
        }
    }
}