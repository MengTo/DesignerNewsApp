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
    func rotateSliderChanged(sender: AnyObject)
    func xSliderChanged(sender: AnyObject)
    func ySliderChanged(sender: AnyObject)
    func scaleSliderChanged(sender: AnyObject)
    func resetButtonPressed(sender: AnyObject)
}

class OptionsViewController: UIViewController {
    
    @IBOutlet weak var modalView: SpringView!
    
    @IBOutlet weak var dampingLabel: UILabel!
    @IBOutlet weak var velocityLabel: UILabel!
    @IBOutlet weak var rotateLabel: UILabel!
    @IBOutlet weak var scaleLabel: UILabel!
    @IBOutlet weak var xLabel: UILabel!
    @IBOutlet weak var yLabel: UILabel!
    
    @IBOutlet weak var dampingSlider: UISlider!
    @IBOutlet weak var velocitySlider: UISlider!
    @IBOutlet weak var rotateSlider: UISlider!
    @IBOutlet weak var xSlider: UISlider!
    @IBOutlet weak var ySlider: UISlider!
    @IBOutlet weak var scaleSlider: UISlider!
    
    weak var delegate: OptionsViewControllerDelegate?
    var data: SpringView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modalView.transform = CGAffineTransformMakeTranslation(0, 300)
        
        setOptions()
        
        dampingSlider.setValue(Float(data.damping), animated: true)
        velocitySlider.setValue(Float(data.velocity), animated: true)
        rotateSlider.setValue(Float(data.rotate), animated: true)
        xSlider.setValue(Float(data.x), animated: true)
        ySlider.setValue(Float(data.y), animated: true)
        scaleSlider.setValue(Float(data.scaleX), animated: true)
    }
    
    func setOptions() {
        rotateLabel.text = getString("Rotate", value: data.rotate)
        xLabel.text = getString("x", value: data.x)
        yLabel.text = getString("y", value: data.y)
        scaleLabel.text = getString("Scale", value: data.scaleX)
        dampingLabel.text = getString("Damping", value: data.damping)
        velocityLabel.text = getString("Velocity", value: data.velocity)
    }

    @IBAction func rotateSliderChanged(sender: AnyObject) {
        delegate?.rotateSliderChanged(sender)
        data.rotate = sender.valueForKey("value") as CGFloat
        setOptions()
    }
    
    @IBAction func xSliderChanged(sender: AnyObject) {
        delegate?.xSliderChanged(sender)
        data.x = sender.valueForKey("value") as CGFloat
        setOptions()
    }
    
    @IBAction func ySliderChanged(sender: AnyObject) {
        delegate?.ySliderChanged(sender)
        data.y = sender.valueForKey("value") as CGFloat
        setOptions()
    }
    
    @IBAction func scaleSliderChanged(sender: AnyObject) {
        delegate?.scaleSliderChanged(sender)
        data.scaleX = sender.valueForKey("value") as CGFloat
        setOptions()
    }
    @IBAction func resetButtonPressed(sender: AnyObject) {
        delegate?.resetButtonPressed(sender)
        dismissViewControllerAnimated(true, completion: nil)
        
        UIApplication.sharedApplication().sendAction("maximizeView:", to: nil, from: self, forEvent: nil)
    }
    
    @IBAction func dampingSliderChanged(sender: AnyObject) {
        delegate?.dampingSliderChanged(sender)
        data.damping = sender.valueForKey("value") as CGFloat
        setOptions()
    }
    
    @IBAction func velocitySliderChanged(sender: AnyObject) {
        delegate?.velocitySliderChanged(sender)
        data.velocity = sender.valueForKey("value") as CGFloat
        setOptions()
    }
    
    @IBAction func closeButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        
        UIApplication.sharedApplication().sendAction("maximizeView:", to: nil, from: self, forEvent: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        UIApplication.sharedApplication().sendAction("minimizeView:", to: nil, from: self, forEvent: nil)
        
        modalView.animate()
    }
    
    func getString(name: String, value: CGFloat) -> String {
        return String(format: "\(name): %.1f", Double(value))
    }
}
