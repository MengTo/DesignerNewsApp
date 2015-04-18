//
//  IntroViewController.swift
//  DesignerNewsApp
//
//  Created by Meng To on 2015-03-24.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit
import Spring

class IntroViewController: UIViewController, DragDropBehaviorDelegate {
    @IBOutlet weak var textLabel: SpringLabel!
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.textLabel.animation = "flash"
        self.textLabel.animate()
        self.textLabel.text = "Drag down to dismiss."
    }
    
    func dragDropBehavior(behavior: DragDropBehavior, viewDidDrop view: UIView) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIScreen.mainScreen().bounds.size.height == 480 {
            textLabel.hidden = true
        }
    }
    
}
