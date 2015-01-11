//
//  CommentViewController.swift
//  DesignerNewsApp
//
//  Created by Meng To on 2015-01-11.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController {
    
    @IBOutlet weak var commentTextView: UITextView!
    var data: AnyObject?
    @IBAction func closeButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentTextView.becomeFirstResponder()
    }
}