//
//  CommentTableViewCell.swift
//  DesignerNewsApp
//
//  Created by André Schneider on 22.01.15.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit
import Spring

protocol CommentTableViewCellDelegate: class {
    func commentTableViewCell(cell: CommentTableViewCell, upvoteButtonPressed sender: AnyObject)
    func commentTableViewCell(cell: CommentTableViewCell, replyButtonPressed sender: AnyObject)
}

class CommentTableViewCell: UITableViewCell {
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var replyButton: SpringButton!
    @IBOutlet weak var upvoteButton: SpringButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var avatarLeftConstant: NSLayoutConstraint!
    @IBOutlet weak var indentView: UIView!

    weak var delegate: CommentTableViewCellDelegate?

    @IBAction func upvoteButtonPressed(sender: AnyObject) {
        delegate?.commentTableViewCell(self, upvoteButtonPressed: sender)
        animateButton(upvoteButton)
    }

    @IBAction func replyButtonPressed(sender: AnyObject) {
        delegate?.commentTableViewCell(self, replyButtonPressed: sender)
        animateButton(replyButton)
    }

    func animateButton(layer: SpringButton) {
        layer.animation = "pop"
        layer.force = 3
        layer.animate()
    }
}

extension CommentTableViewCell {
    func configureWithComment(comment: Comment, attributedBodyText: NSAttributedString? = nil, isUpvoted: Bool = false) {
        self.authorLabel.text = comment.userDisplayName + ", " + comment.userJob
        self.upvoteButton.setTitle(toString(comment.voteCount), forState: UIControlState.Normal)
        self.avatarImageView.image = UIImage(named: "content-avatar-default")

        let timeAgo = dateFromString(comment.createdAt, "yyyy-MM-dd'T'HH:mm:ssZ")
        self.timeLabel.text = timeAgoSinceDate(timeAgo, true)

        ImageLoader.sharedLoader.imageForUrl(comment.userPortraitUrl, completionHandler:{ image, _ in
            self.avatarImageView.image = image
        })

        if comment.depth > 0 {
            self.indentView.hidden = false
            self.avatarLeftConstant.constant = CGFloat(comment.depth) * 20 + 15
            self.separatorInset = UIEdgeInsets(top: 0, left: CGFloat(comment.depth) * 20 + 15, bottom: 0, right: 0)
        }
        else {
            self.avatarLeftConstant.constant = 0
            self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            self.indentView.hidden = true
        }

        self.commentTextView.layoutSubviews()
        self.commentTextView.sizeToFit()
        self.commentTextView.contentInset = UIEdgeInsetsMake(-4, -4, -4, -4)
        commentTextView.attributedText = attributedBodyText ?? NSAttributedString(string: comment.bodyHTML)
        self.commentTextView.font = UIFont(name: "Avenir Next", size: 16)
    }
}
