//
//  OptionsViewController.swift
//  DesignerNewsApp
//
//  Created by Meng To on 2015-01-04.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit

protocol OptionsViewControllerDelegate: class {
    func dampingSliderChanged(sender: AnyObject)
    func velocitySliderChanged(sender: AnyObject)
}

class OptionsViewController: UIViewController {
    
    @IBOutlet weak var dampingLabel: UILabel!
    @IBOutlet weak var velocityLabel: UILabel!
    
    weak var delegate: OptionsViewControllerDelegate?

    @IBAction func dampingSliderChanged(sender: AnyObject) {
        if let delegate = self.delegate {
            delegate.dampingSliderChanged(sender)
        }
        dampingLabel.text = String(format: "Damping: %.1f", sender.valueForKey("value") as Double)
    }
    
    @IBAction func velocitySliderChanged(sender: AnyObject) {
        if let delegate = self.delegate {
            delegate.velocitySliderChanged(sender)
        }
        velocityLabel.text = String(format: "Velocity: %.1f", sender.valueForKey("value") as Double)
    }
    
    @IBAction func closeButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet weak var modalView: SpringView!
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        modalView.animate()
    }
}
