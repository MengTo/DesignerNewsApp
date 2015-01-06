//
//  SpringViewController.swift
//  DesignerNewsApp
//
//  Created by Meng To on 2015-01-02.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit

class SpringViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, OptionsViewControllerDelegate {

    @IBOutlet weak var delayLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var forceLabel: UILabel!
    @IBOutlet weak var delaySlider: UISlider!
    @IBOutlet weak var durationSlider: UISlider!
    @IBOutlet weak var forceSlider: UISlider!
    @IBOutlet weak var ballView: SpringView!
    @IBOutlet weak var animationPicker: UIPickerView!
    var selectedRow: Int = 0
    var selectedEasing: Int = 0
    
    @IBAction func forceSliderChanged(sender: AnyObject) {
        ballView.force = sender.valueForKey("value") as CGFloat
        animateView()
        forceLabel.text = String(format: "Force: %.1f", Double(ballView.force))
    }
    @IBAction func durationSliderChanged(sender: AnyObject) {
        ballView.duration = sender.valueForKey("value") as CGFloat
        animateView()
        durationLabel.text = String(format: "Duration: %.1f", Double(ballView.duration))
    }
    @IBAction func delaySliderChanged(sender: AnyObject) {
        ballView.delay = sender.valueForKey("value") as CGFloat
        animateView()
        delayLabel.text = String(format: "Delay: %.1f", Double(ballView.delay))
    }

    func dampingSliderChanged(sender: AnyObject) {
        ballView.damping = sender.valueForKey("value") as CGFloat
        animateView()
    }
    
    func velocitySliderChanged(sender: AnyObject) {
        ballView.velocity = sender.valueForKey("value") as CGFloat
        animateView()
    }
    
    func scaleSliderChanged(sender: AnyObject) {
        ballView.scaleX = sender.valueForKey("value") as CGFloat
        ballView.scaleY = sender.valueForKey("value") as CGFloat
        animateView()
    }
    
    func xSliderChanged(sender: AnyObject) {
        ballView.x = sender.valueForKey("value") as CGFloat
        animateView()
    }
    
    func ySliderChanged(sender: AnyObject) {
        ballView.y = sender.valueForKey("value") as CGFloat
        animateView()
    }
    
    func rotateSliderChanged(sender: AnyObject) {
        ballView.rotate = sender.valueForKey("value") as CGFloat
        animateView()
    }
    
    func animateView() {
        ballView.reset()
        ballView.animation = data[0][selectedRow]
        ballView.curve = data[1][selectedEasing]
        ballView.animate()
    }
    
    func minimizeView(sender: AnyObject) {
        spring(0.7, {
            self.view.transform = CGAffineTransformMakeScale(0.935, 0.935)
        })
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
    }
    
    func maximizeView(sender: AnyObject) {
        spring(0.7, {
            self.view.transform = CGAffineTransformMakeScale(1, 1)
        })
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: true)
    }
    
    var data = [[
        "shake",
        "pop",
        "morph",
        "squeeze",
        "wobble",
        "swing",
        "flipX",
        "flipY",
        "fall",
        "squeezeLeft",
        "squeezeRight",
        "squeezeDown",
        "squeezeUp",
        "slideLeft",
        "slideRight",
        "slideDown",
        "slideUp",
        "fadeIn",
        "fadeOut",
        "fadeInLeft",
        "fadeInRight",
        "fadeInDown",
        "fadeInUp",
        "zoomIn",
        "zoomOut",
        "flash",
    ], ["spring", "linear", "easeIn", "easeOut", "easeInOut"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animationPicker.delegate = self
        animationPicker.dataSource = self
        animationPicker.showsSelectionIndicator = true
    }
    
    @IBAction func ballButtonPressed(sender: AnyObject) {
        
        UIView.animateWithDuration(0.1, animations: {
            self.ballView.backgroundColor = UIColor(rgba: "#69DBFF")
        }, completion: { finished in
            UIView.animateWithDuration(0.5, animations: {
                self.ballView.backgroundColor = UIColor(rgba: "#279CEB")
            })
        })
        animateView()
    }
    
    var ballState = 0
    func changeBall() {
        switch ballState {
        case 1:
            UIView.animateWithDuration(3, animations: {
                self.ballView.layer.cornerRadius = 10
            })
            ballState = 0
        default:
            UIView.animateWithDuration(3, animations: {
                self.ballView.layer.cornerRadius = 50
            })
            ballState++
        }
        
        let animation = CABasicAnimation()
        animation.keyPath = "opacity"
        animation.fromValue = 1
        animation.toValue = 0
        animation.duration = 0.2
        animation.autoreverses = true
        ballView.layer.addAnimation(animation, forKey: "fade")
    }
    
    @IBAction func shapeButtonPressed(sender: AnyObject) {
        changeBall()
    }
    
    func resetButtonPressed(sender: AnyObject) {
        ballView.reset()
        ballView.force = 1
        ballView.duration = 1
        ballView.delay = 0
        ballView.damping = 0.7
        ballView.velocity = 0.7
        ballView.scaleX = 1
        ballView.scaleY = 1
        ballView.rotate = 0
        
        forceSlider.setValue(Float(ballView.force), animated: true)
        durationSlider.setValue(Float(ballView.duration), animated: true)
        delaySlider.setValue(Float(ballView.delay), animated: true)
        
        forceLabel.text = String(format: "Force: %.1f", Double(ballView.force))
        durationLabel.text = String(format: "Duration: %.1f", Double(ballView.duration))
        delayLabel.text = String(format: "Delay: %.1f", Double(ballView.delay))
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data[component].count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return data[component][row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            selectedRow = row
            animateView()
        default:
            selectedEasing = row
            animateView()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let optionsViewController = segue.destinationViewController as? OptionsViewController {
            optionsViewController.delegate = self
            optionsViewController.data = ballView
        }
        else if let codeViewController = segue.destinationViewController as? CodeViewController {
            codeViewController.data = ballView
        }
    }

}











