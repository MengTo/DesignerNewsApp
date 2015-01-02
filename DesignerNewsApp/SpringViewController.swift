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
        ballView.animation = "slideLeft"
        ballView.animate()
    }
    @IBAction func popButtonPressed(sender: AnyObject) {
        ballView.force = 3
        ballView.animation = "pop"
        ballView.animate()
    }
    @IBAction func morphButtonPressed(sender: AnyObject) {
        ballView.force = 1.5
        ballView.duration = 3
        ballView.animation = "flash"
        ballView.animateNext({
            println("yes")
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
