//
//  ReplyViewController.swift
//  DesignerNewsApp
//
//  Created by Meng To on 2015-01-11.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit
import Spring

class ReplyViewController: UIViewController {
    
    @IBOutlet weak var commentTextView: UITextView!
    var replyable : Replyable!
    @IBOutlet weak var titleItem: UINavigationItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        commentTextView.becomeFirstResponder()
        titleItem.title = self.navigationTitle()

    }


    func navigationTitle() -> String? {
        if let story = replyable as? Story {
            return "Comment"
        } else if let comment = replyable as? Comment {
            return "Reply"
        }
        return nil
    }

    // MARK: Action

    @IBAction func sendButtonDidPress(sender: AnyObject) {
        self.view.endEditing(true)
    }
}
