//
//  ArticleTableViewController.swift
//  DesignerNewsApp
//
//  Created by Meng To on 2015-01-09.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit
import Spring

class ArticleTableViewController: UITableViewController, StoriesTableViewCellDelegate {

    var story: Story!
    private var cachedAttributedText = [NSNumber:NSAttributedString]()
    private let transitionManager = TransitionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 140
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Fade)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "CommentSegue" {
            let toView = segue.destinationViewController as CommentViewController
            toView.data = sender
            
            toView.transitioningDelegate = self.transitionManager
        }
        else if segue.identifier == "WebSegue" {
            let toView = segue.destinationViewController as WebViewController
            // TODO: USe concrete Story instead of JSON
//            toView.story = story
//            toView.transitioningDelegate = self.transitionManager
        }
    }
    
    @IBAction func shareBarButtonPressed(sender: AnyObject) {
        var shareString = story.title
        var shareURL = NSURL(string: story.url)!
        let activityViewController = UIActivityViewController(activityItems: [shareString, shareURL], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityTypeAirDrop]
        presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    func commentsForComment(comment: JSON) -> [JSON] {
        let comments = comment["comments"].array ?? []
        return comments.reduce([comment]) { acc, x in
            acc + self.commentsForComment(x)
        }
    }
    
    // MARK: StoriesTableViewCellDelegate
    func storiesTableViewCell(cell: StoriesTableViewCell, upvoteButtonPressed sender: AnyObject) {
        var indexPath = tableView.indexPathForCell(cell)!
        var id = toString(story.id)
        
        if token.isEmpty {
            performSegueWithIdentifier("LoginSegue", sender: self)
        }
        else {
            postUpvote(id)
            saveUpvote(id)
            let upvoteInt = story.voteCount + 1
            let upvoteString = toString(upvoteInt)
            cell.upvoteButton.setTitle(upvoteString, forState: UIControlState.Normal)
            cell.upvoteButton.setImage(UIImage(named: "icon-upvote-active"), forState: UIControlState.Normal)
        }
    }

    func storiesTableViewCell(cell: StoriesTableViewCell, commentButtonPressed sender: AnyObject) {
        // TODO
    }

    func storiesTableViewCell(cell: StoriesTableViewCell, replyButtonPressed sender: AnyObject) {
        var indexPath = tableView.indexPathForCell(cell)!
        // TODO: Pass a concrete Comment to the Comment View Controller
//        var comment = comments[indexPath.row].dictionaryObject
//        performSegueWithIdentifier("CommentSegue", sender: comment)
    }
    
    // MARK: TableViewDelegate
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + story.comments.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = indexPath.row == 0 ? "StoryCell" : "CommentCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as UITableViewCell
        
        if indexPath.row == 0 {
            configureStoryCell(cell as StoriesTableViewCell, story: story)
        }
        else {
            configureCommentCell(cell as CommentTableViewCell, comment: story.comments[indexPath.row-1])
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            performSegueWithIdentifier("WebSegue", sender: self)
            UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Slide)
        }
    }
    
    // MARK: Misc
    func configureStoryCell(cell: StoriesTableViewCell, story: Story) {

        cell.delegate = self

        cell.titleLabel.text = story.title
        cell.authorLabel.text = story.userDisplayName + ", " + story.userJob
        cell.upvoteButton.setTitle(toString(story.voteCount), forState: UIControlState.Normal)
        cell.storyImageView.image = story.badge.isEmpty ? nil : UIImage(named: "badge-\(story.badge)")
        cell.avatarImageView.image = UIImage(named: "content-avatar-default")

        let timeAgo = dateFromString(story.createdAt, "yyyy-MM-dd'T'HH:mm:ssZ")
        cell.timeLabel.text = timeAgoSinceDate(timeAgo, true)

        ImageLoader.sharedLoader.imageForUrl(story.userPortraitUrl, completionHandler:{ image, _ in
            cell.avatarImageView.image = image
        })
        
        cell.commentTextView.layoutSubviews()
        cell.commentTextView.sizeToFit()
        cell.commentTextView.contentInset = UIEdgeInsetsMake(-4, -4, -4, -4)
        // TODO: Add chache
        //cell.commentTextView.attributedText = getAttributedTextAndCacheIfNecessary(data)
        cell.commentTextView.font = UIFont(name: "Avenir Next", size: 16)
    }


    func configureCommentCell(cell: CommentTableViewCell, comment: Comment) {

        cell.authorLabel.text = story.userDisplayName + ", " + story.userJob
        cell.upvoteButton.setTitle(toString(story.voteCount), forState: UIControlState.Normal)
        cell.avatarImageView.image = UIImage(named: "content-avatar-default")

        let timeAgo = dateFromString(story.createdAt, "yyyy-MM-dd'T'HH:mm:ssZ")
        cell.timeLabel.text = timeAgoSinceDate(timeAgo, true)

        ImageLoader.sharedLoader.imageForUrl(story.userPortraitUrl, completionHandler:{ image, _ in
            cell.avatarImageView.image = image
        })

        if comment.depth > 0 {
            cell.indentView.hidden = false
            cell.avatarLeftConstant.constant = CGFloat(comment.depth) * 20 + 15
            cell.separatorInset = UIEdgeInsets(top: 0, left: CGFloat(comment.depth) * 20 + 15, bottom: 0, right: 0)
        }
        else {
            cell.avatarLeftConstant.constant = 0
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            cell.indentView.hidden = true
        }

        cell.commentTextView.layoutSubviews()
        cell.commentTextView.sizeToFit()
        cell.commentTextView.contentInset = UIEdgeInsetsMake(-4, -4, -4, -4)
        // TODO: Add chache
        //cell.commentTextView.attributedText = getAttributedTextAndCacheIfNecessary(data)
        cell.commentTextView.font = UIFont(name: "Avenir Next", size: 16)
    }

    func getAttributedTextAndCacheIfNecessary(data : JSON) -> NSAttributedString? {

        if let id = data["id"].number {

            // Check cache
            var attributedText : NSAttributedString? = self.cachedAttributedText[id]

            if attributedText == nil {
                // Not in cache so we create the attributed string
                let cssString = "<style>img { max-width: 320px; } </style>"
                if let comment = data["body_html"].string? {
                    attributedText = htmlToAttributedString(cssString + comment)
                }

                if let comment = data["comment_html"].string? {
                    attributedText = htmlToAttributedString(cssString + comment)
                }

                // Save to cache
                self.cachedAttributedText[id] = attributedText
            }

            return attributedText
        }
        return nil
    }
}

