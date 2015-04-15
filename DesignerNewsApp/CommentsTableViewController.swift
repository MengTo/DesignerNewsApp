//
//  ArticleTableViewController.swift
//  DesignerNewsApp
//
//  Created by Meng To on 2015-01-09.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit
import Spring

class CommentsTableViewController: UITableViewController, StoryTableViewCellDelegate, CommentTableViewCellDelegate, ReplyViewControllerDelegate, UISearchBarDelegate {

    var story: Story!
    private var searchBar : UISearchBar?
    private var comments : [Comment] {
        return self.story.comments.filter {
            comment in
            if self.keyword.length > 0 {
                if comment.hasKeyword(self.keyword) {
                    return true
                }
                return false
            }
            return true
        }
    }
    private var keyword : String = ""
    private let transitionManager = TransitionManager()
    private var loginAction: LoginAction?

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
        super.viewDidAppear(animated)
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Fade)
    }

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        coordinator.animateAlongsideTransition(nil, completion: { (context) -> Void in
            self.tableView.reloadData()
        })
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ReplySegue" {

            let toView = segue.destinationViewController as! ReplyViewController

            if let cell = sender as? CommentTableViewCell {
                let indexPath = self.tableView.indexPathForCell(cell)
                let comment = self.getCommentForIndexPath(indexPath!)
                toView.replyable = comment
            } else if let cell = sender as? StoryTableViewCell {
                toView.replyable = story
            }

            toView.delegate = self
            toView.transitioningDelegate = self.transitionManager
        }
        else if segue.identifier == "WebSegue" {
            UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Slide)

            let webViewController = segue.destinationViewController as! WebViewController

            if let url = sender as? NSURL {
                webViewController.url = url
            } else {
                webViewController.shareTitle = story.title
                webViewController.url = NSURL(string: story.url)
            }
            webViewController.transitioningDelegate = self.transitionManager
        }
    }
    
    @IBAction func shareBarButtonPressed(sender: AnyObject) {
        let shareString = story.title
        let shareURL = NSURL(string: story.url)!
        let activityViewController = UIActivityViewController(activityItems: [shareString, shareURL], applicationActivities: [SafariActivity(), ChromeActivity()])
        activityViewController.setValue(shareString, forKey: "subject")
        activityViewController.excludedActivityTypes = [UIActivityTypeAirDrop]
        presentViewController(activityViewController, animated: true, completion: nil)
    }

    // MARK: StoriesTableViewCellDelegate
    func storyTableViewCell(cell: StoryTableViewCell, upvoteButtonPressed sender: AnyObject) {
        if let token = LocalStore.accessToken() {
            let indexPath = tableView.indexPathForCell(cell)!
            let story = self.story
            let storyId = story.id
            story.upvote()
            LocalStore.setStoryAsUpvoted(storyId)
            configureCell(cell, atIndexPath: indexPath)

            DesignerNewsService.upvoteStoryWithId(storyId, token: token) { successful in
                if !successful {
                    story.downvote()
                    LocalStore.removeStoryFromUpvoted(storyId)
                    self.configureCell(cell, atIndexPath: indexPath)
                }
            }

        } else {
            self.loginAction = LoginAction(viewController: self, completion: nil)
        }
    }

    func storyTableViewCell(cell: StoryTableViewCell, replyButtonPressed sender: AnyObject) {
        if LocalStore.accessToken() == nil {
            self.loginAction = LoginAction(viewController: self, completion: nil)
        } else {
            performSegueWithIdentifier("ReplySegue", sender: cell)
        }
    }

    func storyTableViewCell(cell: StoryTableViewCell, linkDidPress link: NSURL) {
        performSegueWithIdentifier("WebSegue", sender: link)
    }

    func storyTableViewCellSizeDidChange(cell: StoryTableViewCell) {
        if let indexPath = tableView.indexPathForCell(cell) {
            self.tableView.reloadData()
        }
    }

    // MARK: CommentTableViewCellDelegate
    func commentTableViewCell(cell: CommentTableViewCell, replyButtonPressed sender: AnyObject) {
        if LocalStore.accessToken() == nil {
            self.loginAction = LoginAction(viewController: self, completion: nil)
        } else {
            performSegueWithIdentifier("ReplySegue", sender: cell)
        }
    }

    func commentTableViewCell(cell: CommentTableViewCell, upvoteButtonPressed sender: AnyObject) {
        if let token = LocalStore.accessToken() {

            let indexPath = tableView.indexPathForCell(cell)!
            let comment = self.getCommentForIndexPath(indexPath)
            let commentId = comment.id
            comment.upvote()
            LocalStore.setCommentAsUpvoted(commentId)
            configureCell(cell, atIndexPath: indexPath)

            DesignerNewsService.upvoteCommentWithId(commentId, token: token) { successful in
                if !successful {
                    comment.downvote()
                    LocalStore.removeCommentFromUpvoted(commentId)
                    self.configureCell(cell, atIndexPath: indexPath)
                }
            }

        } else {
            self.loginAction = LoginAction(viewController: self, completion: nil)
        }
    }

    func commentTableViewCell(cell: CommentTableViewCell, linkDidPress link: NSURL) {
        performSegueWithIdentifier("WebSegue", sender: link)
    }

    func commentTableViewCellSizeDidChange(cell: CommentTableViewCell) {
        if let indexPath = tableView.indexPathForCell(cell) {
            self.tableView.reloadData()
        }
    }

    // MARK: TableViewDelegate
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + comments.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = indexPath.row == 0 ? "StoryCell" : "CommentCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! UITableViewCell

        // In order to make sure the cell have correct size while dequeuing,
        // manually set the frame to it's parent's bounds
        cell.frame = tableView.bounds

        configureCell(cell, atIndexPath:indexPath)

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            performSegueWithIdentifier("WebSegue", sender: self)
        }
    }

    /*
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if searchBar == nil {
            searchBar = UISearchBar(frame: CGRectMake(0, 0, tableView.frame.size.width, 44))
            searchBar?.text = self.keyword
            searchBar?.delegate = self
        }
        return searchBar
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45;
    }
    */

    // MARK: Misc

    func configureCell(cell:UITableViewCell, atIndexPath indexPath:NSIndexPath) {

        if let storyCell = cell as? StoryTableViewCell {
            let isUpvoted = LocalStore.isStoryUpvoted(story.id)
            // Ignore visited state to keep the StoryCell title in black text color
            storyCell.configureWithStory(story, isUpvoted: isUpvoted, isVisited: false)
            storyCell.delegate = self
        }

        if let commentCell = cell as? CommentTableViewCell {
            let comment = self.getCommentForIndexPath(indexPath)
            let isUpvoted = LocalStore.isCommentUpvoted(comment.id)
            commentCell.configureWithComment(comment, isUpvoted: isUpvoted)
            commentCell.delegate = self
        }

    }

    func getCommentForIndexPath(indexPath: NSIndexPath) -> Comment {
        return comments[indexPath.row - 1]
    }

    // MARK: ReplyViewControllerDelegate

    func replyViewController(controller: ReplyViewController, didReplyComment newComment: Comment, onReplyable replyable: Replyable) {

        if let story = replyable as? Story {

            LocalStore.setStoryAsReplied(story.id)
            self.story.insertComment(newComment, atIndex: 0)
            self.tableView.reloadData()

        } else if let comment = replyable as? Comment {

            LocalStore.setStoryAsReplied(story.id)
            for (index, onComment) in enumerate(self.comments) {
                if onComment == comment {
                    self.story.insertComment(newComment, atIndex: index+1)
                    self.tableView.reloadData()
                    break
                }
            }

        }
    }

    // MARK: UISearchBarDelegate

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        keyword = searchText
        tableView.reloadData()
        searchBar.becomeFirstResponder()
    }
}

