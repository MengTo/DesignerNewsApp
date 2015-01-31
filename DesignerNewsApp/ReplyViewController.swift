//
//  ReplyViewController.swift
//  DesignerNewsApp
//
//  Created by Meng To on 2015-01-11.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit
import Spring

protocol ReplyViewControllerDelegate : class {
    func replyViewController(controller: ReplyViewController, didReplyComment comment:Comment, onReplyable replyable:Replyable)
}

class ReplyViewController: UIViewController {

    weak var delegate : ReplyViewControllerDelegate?
    var replyable : Replyable!

    @IBOutlet weak var commentTextView: UITextView!
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

        println("text \(commentTextView.text)")

        if let text = commentTextView.text {

            if let token = LocalStore.accessToken() {

                view.endEditing(true)
                view.showLoading()
                commentTextView.editable = false

                if let story = replyable as? Story {
                    DesignerNewsService.replyStoryWithId(
                        story.id,
                        token: token,
                        body: text,
                        response: handleResponse)

                } else if let comment = replyable as? Comment {
                    DesignerNewsService.replyCommentWithId(
                        comment.id,
                        token: token,
                        body: text,
                        response: handleResponse)
                }
            } else {
                println("please login")
            }
        } else {
            println("please set text")
        }
    }

    private func handleResponse(comment: Comment?, error: Error?) {
        if let comment = comment {
            self.dismissViewControllerAnimated(true, completion: nil)
            self.delegate?.replyViewController(self, didReplyComment: comment, onReplyable: self.replyable)
        } else {
            self.view.hideLoading()
            self.commentTextView.editable = true

            let alert = UIAlertView(title: "Error", message: error?.message, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }
}
