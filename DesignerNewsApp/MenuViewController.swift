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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dialogView.alpha = 0
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        dialogView.animateFrom = true
        dialogView.animation = "squeezeDown"
        dialogView.animate()
    }
    
    @IBAction func closeButtonPressed(sender: AnyObject) {
        dialogView.resetAll()
        dialogView.animation = "fall"
        dialogView.force = 2
        dialogView.animateNext { () -> () in
            self.dismissViewControllerAnimated(false, completion: nil)
        }
    }
}