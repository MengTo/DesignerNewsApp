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
