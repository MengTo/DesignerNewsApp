//
//  IntroViewController.swift
//  DesignerNewsApp
//
//  Created by Meng To on 2015-03-24.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController, DragDropBehaviorDelegate {
    
    func dragDropBehavior(behavior: DragDropBehavior, viewDidDrop view: UIView) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
