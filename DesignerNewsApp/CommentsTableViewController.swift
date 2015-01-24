//
//  ArticleTableViewController.swift
//  DesignerNewsApp
//
//  Created by Meng To on 2015-01-09.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit
import Spring

class CommentsTableViewController: UITableViewController, StoryTableViewCellDelegate {

    var story: Story!
    private var cachedAttributedText = [Int: NSAttributedString]()
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
    func storyTableViewCell(cell: StoryTableViewCell, upvoteButtonPressed sender: AnyObject) {
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

    func storyTableViewCell(cell: StoryTableViewCell, commentButtonPressed sender: AnyObject) {
        // TODO
    }

    func storyTableViewCell(cell: StoryTableViewCell, replyButtonPressed sender: AnyObject) {
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

        if let storyCell = cell as? StoryTableViewCell {
            let commentText = getAttributedTextAndCacheIfNecessary(story.commentHTML, id: story.id)
            storyCell.configureWithStory(story, attributedCommentText: commentText)
            storyCell.delegate = self
        }

        if let commentCell = cell as? CommentTableViewCell {
            let comment = story.comments[indexPath.row-1]
            let bodyText = getAttributedTextAndCacheIfNecessary(comment.bodyHTML, id: comment.id)
            commentCell.configureWithComment(comment, attributedBodyText: bodyText)
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

    func getAttributedTextAndCacheIfNecessary(text: String, id: Int) -> NSAttributedString? {
        let cachedAttributedText = self.cachedAttributedText[id]
        if cachedAttributedText == nil {
            // Not in cache so we create the attributed string
            let cssString = "<style>img { max-width: 320px; } </style>"
            // Save to cache
            let attributedText = htmlToAttributedString(cssString + text)
            self.cachedAttributedText[id] = attributedText
            return attributedText
        }
        return cachedAttributedText
    }
}

