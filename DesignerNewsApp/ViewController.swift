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
        
//        animationView.x = 200
//        animationView.y = 200
//        animationView.duration = 1
//        animationView.animateNext({
//            
//            self.animationView.x = 0
//            self.animationView.y = 0
//            self.animationView.duration = 1
//            self.animationView.opacity = 0
//            self.animationView.scaleX = 0.5
//            self.animationView.scaleY = 0.5
//            self.animationView.animate()
//            
//        })
        shakeView(animationView)
    }
    
    func shakeView(view: UIView) {
        let morphX = CAKeyframeAnimation()
        morphX.keyPath = "transform.scale.x"
        morphX.values = [1, 1.1, 0.9, 1.1, 1]
        morphX.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
        morphX.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
        morphX.duration = 1
        view.layer.addAnimation(morphX, forKey: "morphX")
        
        let morphY = CAKeyframeAnimation()
        morphY.keyPath = "transform.scale.y"
        morphY.values = [1, 0.9, 1.1, 0.9, 1]
        morphY.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
        morphY.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
        morphY.duration = 1
        view.layer.addAnimation(morphY, forKey: "morphY")
    }
    
    @IBAction func signupButtonPressed(sender: AnyObject) {
        animationView.reset()
        animationView.scaleX = 0.8
        animationView.scaleY = 0.8
        animationView.rotate = -0.1
        animationView.animate()
    }
    
    @IBAction func replayButtonPressed(sender: AnyObject) {
        animationView.reset()
        animationView.animate()
        shakeView(animationView)
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        view.endEditing(true)
    }
}

