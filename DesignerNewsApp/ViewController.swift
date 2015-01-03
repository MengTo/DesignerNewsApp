//
//  ViewController.swift
//  DesignerNewsApp
//
//  Created by Meng To on 2014-12-26.
//  Copyright (c) 2014 Meng To. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var animationView: SpringView!
    @IBOutlet weak var signupButton: SpringButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animationView.animation = "shake"
        animationView.animateNext({
            self.animationView.animation = "wobble"
            self.animationView.animate()
        })
    }
    
    func shakeView(view: UIView) {
        
    }
    
    @IBAction func signupButtonPressed(sender: AnyObject) {
        animationView.animation = "squeezeLeft"
        animationView.force = 1
        animationView.duration = 1
        animationView.animate()
    }
    
    @IBAction func replayButtonPressed(sender: AnyObject) {
        animationView.reset()
        animationView.animate()
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        view.endEditing(true)
    }
}

