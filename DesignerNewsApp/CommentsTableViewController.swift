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
    private let transitionManager = TransitionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 140
        tableView.rowHeight = UITableViewAutomaticDimension

        // Reloading for the visible cells to layout correctly
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })
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
            UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Slide)

            let webViewController = segue.destinationViewController as WebViewController
            webViewController.shareTitle = story.title
            webViewController.url = NSURL(string: story.url)
            webViewController.transitioningDelegate = self.transitionManager
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
                if successful {
                    saveUpvote(toString(self.story.id))
                    let upvoteInt = self.story.voteCount + 1
                    let upvoteString = toString(upvoteInt)
                    cell.upvoteButton.setTitle(upvoteString, forState: UIControlState.Normal)
                    cell.upvoteButton.setImage(UIImage(named: "icon-upvote-active"), forState: UIControlState.Normal)
                }
            }
        }
    }

    func storyTableViewCell(cell: StoryTableViewCell, replyButtonPressed sender: AnyObject) {
        performSegueWithIdentifier("CommentSegue", sender: cell)
    }

    func storyTableViewCell(cell: StoryTableViewCell, linkDidPress link: NSURL) {
        performSegueWithIdentifier("WebSegue", sender: link)
    }

    // MARK: CommentTableViewCellDelegate
    func commentTableViewCell(cell: CommentTableViewCell, replyButtonPressed sender: AnyObject) {
        performSegueWithIdentifier("CommentSegue", sender: cell)
    }

    func commentTableViewCell(cell: CommentTableViewCell, upvoteButtonPressed sender: AnyObject) {
        if getToken().isEmpty {
            performSegueWithIdentifier("LoginSegue", sender: self)
        }
        else {
            let indexPath = self.tableView.indexPathForCell(cell)
            let comment = self.getCommentForIndexPath(indexPath!)
            DesignerNewsService.upvoteCommentWithId(comment.id, token: getToken()) { successful in
                if successful {
                    saveUpvote(toString(comment.id))
                    let upvoteInt = comment.voteCount + 1
                    let upvoteString = toString(upvoteInt)
                    cell.upvoteButton.setTitle(upvoteString, forState: UIControlState.Normal)
                    cell.upvoteButton.setImage(UIImage(named: "icon-upvote-active"), forState: UIControlState.Normal)
                }
            }
        }
    }

    func commentTableViewCell(cell: CommentTableViewCell, linkDidPress link: NSURL) {
        performSegueWithIdentifier("WebSegue", sender: link)
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

        // In order to make sure the cell have correct size while dequeuing,
        // manually set the frame to it's parent's bounds
        cell.frame = tableView.bounds

        if let storyCell = cell as? StoryTableViewCell {
            storyCell.configureWithStory(story)
            storyCell.delegate = self
        }

        if let commentCell = cell as? CommentTableViewCell {
            let comment = self.getCommentForIndexPath(indexPath)
            commentCell.configureWithComment(comment)
            commentCell.delegate = self
        }

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            performSegueWithIdentifier("WebSegue", sender: self)
        }
    }
    
    // MARK: Misc

    func getCommentForIndexPath(indexPath: NSIndexPath) -> Comment {
        return story.comments[indexPath.row - 1]
    }
}

