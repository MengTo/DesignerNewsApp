//
//  CommentViewController.swift
//  DesignerNewsApp
//
//  Created by Meng To on 2015-01-11.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit
import Spring

class CommentViewController: UIViewController {
    
    @IBOutlet weak var commentTextView: UITextView!
    var data: AnyObject?
    @IBOutlet weak var navTitle: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentTextView.becomeFirstResponder()
        
        var comment = JSON(data!)
        
        navTitle.title = "Comment"
    }
}