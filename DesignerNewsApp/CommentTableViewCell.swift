//
//  CommentTableViewCell.swift
//  DesignerNewsApp
//
//  Created by André Schneider on 22.01.15.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit
import Spring

@objc protocol CommentTableViewCellDelegate: class {
    func commentTableViewCell(cell: CommentTableViewCell, upvoteButtonPressed sender: AnyObject)
    func commentTableViewCell(cell: CommentTableViewCell, replyButtonPressed sender: AnyObject)
    optional func commentTableViewCell(cell: CommentTableViewCell, linkDidPress link:NSURL)
}

class CommentTableViewCell: UITableViewCell, CoreTextViewDelegate {
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var replyButton: SpringButton!
    @IBOutlet weak var upvoteButton: SpringButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var commentTextView: CoreTextView!
    @IBOutlet weak var avatarLeftConstant: NSLayoutConstraint!
    @IBOutlet weak var indentView: UIView!

    weak var delegate: CommentTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.commentTextView.linkDelegate = self
    }

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

    // MARK: CoreTextViewDelegate
    func coreTextView(textView: CoreTextView, linkDidTap link: NSURL) {
        self.delegate?.commentTableViewCell?(self, linkDidPress: link)
    }
}

extension CommentTableViewCell {
    func configureWithComment(comment: Comment, isUpvoted: Bool = false) {

        if comment.depth > 0 {
            self.indentView.hidden = false
            self.avatarLeftConstant.constant = CGFloat(comment.depth) * 20 + 15
            self.separatorInset = UIEdgeInsets(top: 0, left: CGFloat(comment.depth) * 20 + 15, bottom: 0, right: 0)
        }
        else {
            self.avatarLeftConstant.constant = 0
            self.separatorInset = UIEdgeInsets(top: 0, left: 35, bottom: 0, right: 0)
            self.indentView.hidden = true
        }

        self.authorLabel.text = comment.userDisplayName + ", " + comment.userJob
        self.upvoteButton.setTitle(toString(comment.voteCount), forState: UIControlState.Normal)
        self.avatarImageView.image = UIImage(named: "content-avatar-default")

        let timeAgo = dateFromString(comment.createdAt, "yyyy-MM-dd'T'HH:mm:ssZ")
        self.timeLabel.text = timeAgoSinceDate(timeAgo, true)

        ImageLoader.sharedLoader.imageForUrl(comment.userPortraitUrl, completionHandler:{ image, _ in
            self.avatarImageView.image = image
        })

        // Make sure the textView are correctly framed before setting attributed string
        self.setNeedsLayout()
        self.layoutIfNeeded()

        let data = ("<style>img { max-width: 320px; } p {font-family:\"Avenir Next\";font-size:16px}</style>" + comment.bodyHTML).dataUsingEncoding(NSUTF8StringEncoding)
        commentTextView.attributedString = NSAttributedString(HTMLData: data, documentAttributes: nil)

    }
}
