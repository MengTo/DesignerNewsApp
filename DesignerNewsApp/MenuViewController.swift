//
//  MenuViewController.swift
//  DesignerNewsApp
//
//  Created by Meng To on 2015-01-12.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var dialogView: SpringView!
    
    @IBAction func topButtonPressed(sender: AnyObject) {
        animateView()
    }
    
    @IBAction func recentButtonPressed(sender: AnyObject) {
        animateView()
    }
    
    @IBAction func creditsButtonPressed(sender: AnyObject) {
        animateView()
    }
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        animateView()
    }
    
    func animateView() {
        dialogView.animation = "pop"
        dialogView.animate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dialogView.alpha = 0
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        dialogView.animation = "squeezeDown"
        dialogView.animate()
    }
    
    @IBAction func closeButtonPressed(sender: AnyObject) {
        dialogView.animation = "fall"
        dialogView.animateNext {
            self.dismissViewControllerAnimated(false, completion: nil)
        }
    }
}