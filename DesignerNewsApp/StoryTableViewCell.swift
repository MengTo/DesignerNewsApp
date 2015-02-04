//
//  StoriesTableViewCell.swift
//  DesignerNewsApp
//
//  Created by Meng To on 2015-01-08.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit
import Spring

@objc protocol StoryTableViewCellDelegate: class {
    func storyTableViewCell(cell: StoryTableViewCell, upvoteButtonPressed sender: AnyObject)
    optional func storyTableViewCell(cell: StoryTableViewCell, commentButtonPressed sender: AnyObject)
    optional func storyTableViewCell(cell: StoryTableViewCell, replyButtonPressed sender: AnyObject)
    optional func storyTableViewCell(cell: StoryTableViewCell, linkDidPress link:NSURL)
    optional func storyTableViewCellSizeDidChange(cell: StoryTableViewCell)

}

class StoryTableViewCell: UITableViewCell, CoreTextViewDelegate {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var avatarImageView: AsyncImageView!
    @IBOutlet weak var storyImageView: UIImageView!
    @IBOutlet weak var commentButton: SpringButton?
    @IBOutlet weak var replyButton: SpringButton?
    @IBOutlet weak var upvoteButton: SpringButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var commentTextView: CoreTextView?

    weak var delegate: StoryTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.commentTextView?.linkDelegate = self
    }
    
    @IBAction func upvoteButtonPressed(sender: AnyObject) {
        delegate?.storyTableViewCell(self, upvoteButtonPressed: sender)
        animateButton(upvoteButton)
    }
    
    @IBAction func commentButtonPressed(sender: AnyObject) {
        delegate?.storyTableViewCell?(self, commentButtonPressed: sender)
        animateButton(commentButton!)
    }
    
    @IBAction func replyButtonPressed(sender: AnyObject) {
        delegate?.storyTableViewCell?(self, replyButtonPressed: sender)
        animateButton(replyButton!)
    }
    
    func animateButton(layer: SpringButton) {
        layer.animation = "pop"
        layer.force = 3
        layer.animate()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel.preferredMaxLayoutWidth = self.titleLabel.frame.size.width
    }

    // MARK: CoreTextViewDelegate
    func coreTextView(textView: CoreTextView, linkDidTap link: NSURL) {
        self.delegate?.storyTableViewCell?(self, linkDidPress: link)
    }

    func coreTextView(textView: CoreTextView, newImageSizeDidCache size: CGSize) {
        self.delegate?.storyTableViewCellSizeDidChange?(self)
    }
}

extension StoryTableViewCell {
    func configureWithStory(story: Story, isUpvoted: Bool = false, isVisited: Bool = false, isReplied: Bool = false) {

        self.titleLabel.textColor = isVisited ? self.authorLabel.textColor : .blackColor()
        self.titleLabel.text = story.title
        self.authorLabel.text = story.userDisplayName + ", " + story.userJob
        self.upvoteButton.setTitle(toString(story.voteCount), forState: UIControlState.Normal)
        self.storyImageView.image = story.badge.isEmpty ? nil : UIImage(named: "badge-\(story.badge)")

        let timeAgo = dateFromString(story.createdAt, "yyyy-MM-dd'T'HH:mm:ssZ")
        self.timeLabel.text = timeAgoSinceDate(timeAgo, true)

        self.setIsUpvoted(isUpvoted)

        self.avatarImageView.placeholderImage = UIImage(named: "content-avatar-default")
        self.avatarImageView.url = story.userPortraitUrl?.toURL()

        if let commentTextView = self.commentTextView {

            // Make sure the textView are correctly framed before setting attributed string
            self.setNeedsLayout()
            self.layoutIfNeeded()

            let data = ("<style>p, li {font-family:\"Avenir Next\";font-size:16px;line-height:20px;}</style>" + story.commentHTML).dataUsingEncoding(NSUTF8StringEncoding)

            let attributedString = NSAttributedString(HTMLData: data, documentAttributes: nil)
            commentTextView.attributedString = attributedString

        }

        if let commentButton = self.commentButton {
            commentButton.setTitle(toString(story.commentCount), forState: UIControlState.Normal)
            let imageName = isReplied ? "icon-comment-active" : "icon-comment"
            commentButton.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        }
    }

    func setIsUpvoted(isUpvoted: Bool) {
        let imageName = isUpvoted ? "icon-upvote-active" : "icon-upvote"
        self.upvoteButton.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        self.upvoteButton.userInteractionEnabled = !isUpvoted
    }
}
