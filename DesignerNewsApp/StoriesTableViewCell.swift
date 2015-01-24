//
//  StoriesTableViewCell.swift
//  DesignerNewsApp
//
//  Created by Meng To on 2015-01-08.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit
import Spring

protocol StoriesTableViewCellDelegate: class {
    func storiesTableViewCell(cell: StoriesTableViewCell, upvoteButtonPressed sender: AnyObject)
    func storiesTableViewCell(cell: StoriesTableViewCell, commentButtonPressed sender: AnyObject)
    func storiesTableViewCell(cell: StoriesTableViewCell, replyButtonPressed sender: AnyObject)
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
    
    weak var delegate: StoriesTableViewCellDelegate?
    
    @IBAction func upvoteButtonPressed(sender: AnyObject) {
        setSelected(true, animated: false)
        delegate?.storiesTableViewCell(self, upvoteButtonPressed: sender)
        animateButton(upvoteButton)
        setSelected(false, animated: false)
    }
    
    @IBAction func commentButtonPressed(sender: AnyObject) {
        delegate?.storiesTableViewCell(self, commentButtonPressed: sender)
        animateButton(commentButton)
    }
    
    @IBAction func replyButtonPressed(sender: AnyObject) {
        delegate?.storiesTableViewCell(self, replyButtonPressed: sender)
        animateButton(replyButton)
    }
    
    func animateButton(layer: SpringButton) {
        layer.animation = "pop"
        layer.force = 3
        layer.animate()
    }
}
