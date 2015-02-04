//
//  MenuControl.swift
//  DesignerNewsApp
//
//  Created by André Schneider on 04.02.15.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit

@IBDesignable class MenuControl: UIControl {

    @IBInspectable var color: UIColor = UIColor.whiteColor() {
        didSet {
            topView.backgroundColor = color
            centerView.backgroundColor = color
            bottomView.backgroundColor = color
        }
    }

    private let topView = UIView()
    private let centerView = UIView()
    private let bottomView = UIView()

    override func layoutSubviews() {
        if subviews.isEmpty {
            setUp()
        }

    }

    private func setUp() {
        backgroundColor = UIColor.clearColor()
        
        let height = CGFloat(2)
        let width = bounds.maxX

        topView.frame = CGRectMake(0, bounds.minY, width, height)
        topView.userInteractionEnabled = false
        topView.backgroundColor = color

        centerView.frame = CGRectMake(0, bounds.midY - round(height / 2), width, height)
        centerView.userInteractionEnabled = false
        centerView.backgroundColor = color

        bottomView.frame = CGRectMake(0, bounds.maxY - height, width, height)
        bottomView.userInteractionEnabled = false
        bottomView.backgroundColor = color;

        addSubview(topView)
        addSubview(centerView)
        addSubview(bottomView)
    }
}
