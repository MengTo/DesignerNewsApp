//
//  ArticleTableViewController.swift
//  DesignerNewsApp
//
//  Created by Meng To on 2015-01-09.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit
import Spring

class CommentsTableViewController: UITableViewController, StoryTableViewCellDelegate, CommentTableViewCellDelegate {

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

            if let cell = sender as? CommentTableViewCell {
                let indexPath = self.tableView.indexPathForCell(cell)
                let comment = self.getCommentForIndexPath(indexPath!)
                toView.commentable = comment
            } else if let cell = sender as? StoryTableViewCell {
                toView.commentable = story
            }
            
            toView.transitioningDelegate = self.transitionManager
        }
        else if segue.identifier == "WebSegue" {
            let toView = segue.destinationViewController as WebViewController
            toView.story = story
            toView.transitioningDelegate = self.transitionManager
        }
    }
    
    @IBAction func shareBarButtonPressed(sender: AnyObject) {
        var shareString = story.title
        var shareURL = NSURL(string: story.url)!
        let activityViewController = UIActivityViewController(activityItems: [shareString, shareURL], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityTypeAirDrop]
        presentViewController(activityViewController, animated: true, completion: nil)
    }

    // MARK: StoriesTableViewCellDelegate
    func storyTableViewCell(cell: StoryTableViewCell, upvoteButtonPressed sender: AnyObject) {
        if getToken().isEmpty {
            performSegueWithIdentifier("LoginSegue", sender: self)
        }
        else {
            DesignerNewsService.upvoteStoryWithId(story.id, token: getToken()) { successful in

            }
            saveUpvote(toString(story.id))
            let upvoteInt = story.voteCount + 1
            let upvoteString = toString(upvoteInt)
            cell.upvoteButton.setTitle(upvoteString, forState: UIControlState.Normal)
            cell.upvoteButton.setImage(UIImage(named: "icon-upvote-active"), forState: UIControlState.Normal)
        }
    }

    func storyTableViewCell(cell: StoryTableViewCell, replyButtonPressed sender: AnyObject) {
        performSegueWithIdentifier("CommentSegue", sender: cell)
    }

    // MARK: CommentTableViewCellDelegate
    func commentTableViewCell(cell: CommentTableViewCell, replyButtonPressed sender: AnyObject) {
        performSegueWithIdentifier("CommentSegue", sender: cell)
    }

    func commentTableViewCell(cell: CommentTableViewCell, upvoteButtonPressed sender: AnyObject) {
        // TODO: Implement upvote
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
            let comment = self.getCommentForIndexPath(indexPath)
            let bodyText = getAttributedTextAndCacheIfNecessary(comment.bodyHTML, id: comment.id)
            commentCell.configureWithComment(comment, attributedBodyText: bodyText)
            commentCell.delegate = self
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

    func getCommentForIndexPath(indexPath: NSIndexPath) -> Comment {
        return story.comments[indexPath.row - 1]
    }
}

