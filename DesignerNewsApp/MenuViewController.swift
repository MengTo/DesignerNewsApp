//
//  MenuViewController.swift
//  DesignerNewsApp
//
//  Created by Meng To on 2015-01-12.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit
import Spring

protocol MenuViewControllerDelegate : class {
    func menuViewControllerDidSelectTopStories(controller:MenuViewController)
    func menuViewControllerDidSelectRecent(controller:MenuViewController)
    func menuViewControllerDidSelectLogout(controller:MenuViewController)
    func menuViewControllerDidSelectLogin(controller:MenuViewController)
    func menuViewControllerDidSelectCloseMenu(controller:MenuViewController)
}

class MenuViewController: UIViewController {
    
    weak var delegate: MenuViewControllerDelegate?
    @IBOutlet weak var dialogView: SpringView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var recentLabel: UILabel!
    @IBOutlet weak var creditsLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    private var loginAction : LoginAction?
    private var loginStateHandler: LoginStateHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let token = LocalStore.accessToken()
        loginLabel.text = token == nil ? "Login" : "Logout"
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
        if LocalStore.accessToken() == nil {
            loginAction = LoginAction(viewController: self, completion: { [weak self] () -> () in
                if let strongSelf = self {
                    strongSelf.dismissViewControllerAnimated(true, completion: nil)
                    strongSelf.delegate?.menuViewControllerDidSelectLogin(strongSelf)
                }
            })
        } else {
            LogoutAction()
            delegate?.menuViewControllerDidSelectLogout(self)
            dismissViewControllerAnimated(true, completion: nil)
        }
    }

    @IBAction func closeButtonPressed(sender: AnyObject) {
        delegate?.menuViewControllerDidSelectCloseMenu(self)
        dialogView.animation = "fall"
        dialogView.animateNext {
            self.dismissViewControllerAnimated(false, completion: nil)
        }
    }

    // MARK: Misc

    func animateView() {
        dialogView.animation = "pop"
        dialogView.animate()
    }

}