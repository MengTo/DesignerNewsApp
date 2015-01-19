//
//  StoriesTableViewCell.swift
//  DesignerNewsApp
//
//  Created by Meng To on 2015-01-08.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit

protocol StoriesTableViewCellDelegate: class {
    func upvoteButtonPressed(cell: StoriesTableViewCell, sender: AnyObject)
    func commentButtonPressed(cell: StoriesTableViewCell, sender: AnyObject)
    func replyButtonPressed(cell: StoriesTableViewCell, sender: AnyObject)
}

class StoriesTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var storyImageView: UIImageView!
    @IBOutlet weak var commentButton: SpringButton!
    @IBOutlet weak var replyButton: SpringButton!
    @IBOutlet weak var upvoteButton: SpringButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var avatarLeftConstant: NSLayoutConstraint!
    @IBOutlet weak var indentView: UIView!
    
    weak var delegate: StoriesTableViewCellDelegate?
    
    @IBAction func upvoteButtonPressed(sender: AnyObject) {
        delegate?.upvoteButtonPressed(self, sender: sender)
        animateButton(upvoteButton)
    }
    
    @IBAction func commentButtonPressed(sender: AnyObject) {
        delegate?.commentButtonPressed(self, sender: sender)
        animateButton(commentButton)
    }
    
    @IBAction func replyButtonPressed(sender: AnyObject) {
        delegate?.replyButtonPressed(self, sender: sender)
        animateButton(replyButton)
    }
    
    func animateButton(layer: SpringButton) {
        layer.animation = "pop"
        layer.force = 3
        layer.animate()
    }
}
