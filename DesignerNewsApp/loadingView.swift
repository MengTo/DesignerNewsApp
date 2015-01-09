//
//  loadingView.swift
//  DesignerNewsApp
//
//  Created by Meng To on 2015-01-10.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit

class loadingView: UIView {
    @IBOutlet weak var loadingView: SpringView!
    override func awakeFromNib() {
        let animation = CABasicAnimation()
        animation.keyPath = "transform.rotation.z"
        animation.fromValue = degreesToRadians(0)
        animation.toValue = degreesToRadians(360)
        animation.duration = 0.5
        animation.repeatCount = HUGE
        loadingView.layer.addAnimation(animation, forKey: "")
    }
}
