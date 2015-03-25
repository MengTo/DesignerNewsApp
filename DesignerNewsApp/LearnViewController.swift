//
//  LearnViewController.swift
//  DesignerNewsApp
//
//  Created by Meng To on 2015-01-15.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit
import Spring

class LearnViewController: UIViewController, DragDropBehaviorDelegate {

    @IBOutlet weak var bgImageView: SpringImageView!
    @IBOutlet weak var xcodeImageView: SpringImageView!
    @IBOutlet weak var bookImageView: SpringImageView!
    @IBOutlet weak var sketchImageView: SpringImageView!
    @IBOutlet weak var dialogView: DesignableView!
    
    @IBAction func learnButtonDidTouch(sender: AnyObject) {
        openUrl("http://designcode.io")
    }
    
    @IBAction func twitterButtonDidTouch(sender: AnyObject) {
        openUrl("http://twitter.com/mengto")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func dragDropBehavior(behavior: DragDropBehavior, viewDidDrop view: UIView) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func openUrl(url:String!) {
        let targetURL = NSURL(string: url)
        let application = UIApplication.sharedApplication()
        application.openURL(targetURL!)
    }
}
