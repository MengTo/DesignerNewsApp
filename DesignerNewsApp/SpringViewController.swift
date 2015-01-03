//
//  SpringViewController.swift
//  DesignerNewsApp
//
//  Created by Meng To on 2015-01-02.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit

class SpringViewController: UIViewController {

    @IBOutlet weak var ballView: SpringView!
    
    @IBAction func shakeButtonPressed(sender: AnyObject) {
        ballView.force = 2
        ballView.delay = 0.1
        ballView.animation = "shake"
        ballView.animate()
    }
    @IBAction func popButtonPressed(sender: AnyObject) {
        ballView.force = 3
        ballView.animation = "pop"
        ballView.animate()
    }
    @IBAction func morphButtonPressed(sender: AnyObject) {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "transform.scale"
        animation.values = [0, 30, -30, 30, 0]
        animation.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
        animation.duration = 1
        animation.additive = true
        animation.repeatCount = 1
        ballView.layer.addAnimation(animation, forKey: "shake")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
