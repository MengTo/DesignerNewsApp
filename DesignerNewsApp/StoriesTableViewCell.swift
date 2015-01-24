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
    @IBOutlet weak var commentButton: SpringButton?
    @IBOutlet weak var replyButton: SpringButton?
    @IBOutlet weak var upvoteButton: SpringButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var commentTextView: UITextView?
    
    weak var delegate: StoriesTableViewCellDelegate?
    
    @IBAction func upvoteButtonPressed(sender: AnyObject) {
        setSelected(true, animated: false)
        delegate?.storiesTableViewCell(self, upvoteButtonPressed: sender)
        animateButton(upvoteButton)
        setSelected(false, animated: false)
    }
    
    @IBAction func commentButtonPressed(sender: AnyObject) {
        delegate?.storiesTableViewCell(self, commentButtonPressed: sender)
        animateButton(commentButton!)
    }
    
    @IBAction func replyButtonPressed(sender: AnyObject) {
        delegate?.storiesTableViewCell(self, replyButtonPressed: sender)
        animateButton(replyButton!)
    }
    
    func animateButton(layer: SpringButton) {
        layer.animation = "pop"
        layer.force = 3
        layer.animate()
    }
}

extension StoriesTableViewCell {
    func configureWithStory(story: Story, isUpvoted: Bool = false) {
        self.titleLabel.text = story.title
        self.authorLabel.text = story.userDisplayName + ", " + story.userJob
        self.upvoteButton.setTitle(toString(story.voteCount), forState: UIControlState.Normal)
        self.storyImageView.image = story.badge.isEmpty ? nil : UIImage(named: "badge-\(story.badge)")
        self.avatarImageView.image = UIImage(named: "content-avatar-default")

        let timeAgo = dateFromString(story.createdAt, "yyyy-MM-dd'T'HH:mm:ssZ")
        self.timeLabel.text = timeAgoSinceDate(timeAgo, true)

        let imageName = isUpvoted ? "icon-upvote-active" : "icon-upvote"
        self.upvoteButton.setImage(UIImage(named: imageName), forState: UIControlState.Normal)

        ImageLoader.sharedLoader.imageForUrl(story.userPortraitUrl, completionHandler:{ image, _ in
            self.avatarImageView.image = image
        })

        if let commentTextView = self.commentTextView {
            commentTextView.layoutSubviews()
            commentTextView.sizeToFit()
            commentTextView.contentInset = UIEdgeInsetsMake(-4, -4, -4, -4)
            // TODO: Implement Cache, inject in mehtod, or at parser level
            //self.commentTextView.attributedText = getAttributedTextAndCacheIfNecessary(story.commentHTML, id: story.id)
            commentTextView.font = UIFont(name: "Avenir Next", size: 16)
        }

        if let commentButton = self.commentButton {
            commentButton.setTitle(toString(story.commentCount), forState: UIControlState.Normal)
        }
    }
}
