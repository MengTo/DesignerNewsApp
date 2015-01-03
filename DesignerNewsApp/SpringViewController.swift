//
//  SpringViewController.swift
//  DesignerNewsApp
//
//  Created by Meng To on 2015-01-02.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit

class SpringViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var delayLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var forceLabel: UILabel!
    @IBOutlet weak var delaySlider: UISlider!
    @IBOutlet weak var durationSlider: UISlider!
    @IBOutlet weak var forceSlider: UISlider!
    @IBOutlet weak var ballView: SpringView!
    @IBOutlet weak var animationPicker: UIPickerView!
    var selectedRow: Int = 0
    var selectedForce: CGFloat = 1
    var selectedDuration: CGFloat = 0.7
    var selectedDelay: CGFloat = 0
    
    @IBAction func forceSliderChanged(sender: AnyObject) {
        selectedForce = sender.valueForKey("value") as CGFloat
        animateView()
        forceLabel.text = "Force: \(ceil(selectedForce))"
    }
    @IBAction func durationSliderChanged(sender: AnyObject) {
        selectedDuration = sender.valueForKey("value") as CGFloat
        animateView()
        durationLabel.text = "Duration: \(ceil(selectedDuration))"
    }
    @IBAction func delaySliderChanged(sender: AnyObject) {
        selectedDelay = sender.valueForKey("value") as CGFloat
        animateView()
        delayLabel.text = "Delay: \(ceil(selectedDelay))"
    }
    
    func animateView() {
        ballView.animation = data[selectedRow]
        ballView.duration = selectedDuration
        ballView.delay = selectedDelay
        ballView.force = selectedForce
        ballView.animate()
    }
    
    var data =
    [
        "shake",
        "pop",
        "morph",
        "squeeze",
        "flash",
        "wobble",
        "swing",
        "slideLeft",
        "slideRight",
        "slideDown",
        "slideUp",
        "fadeIn",
        "fadeOut",
        "fadeInLeft",
        "fadeInright",
        "fadeInDown",
        "fadeInUp",
        "zoomIn",
        "zoomOut",
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animationPicker.delegate = self
        animationPicker.dataSource = self
        animationPicker.showsSelectionIndicator = true
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return data[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row
        animateView()
    }

}











