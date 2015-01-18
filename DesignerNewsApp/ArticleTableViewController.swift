//
//  ArticleTableViewController.swift
//  DesignerNewsApp
//
//  Created by Meng To on 2015-01-09.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit

class ArticleTableViewController: UITableViewController, StoriesTableViewCellDelegate {

    var data: AnyObject?
    var story: JSON!
    var comments: JSON!
    private let transitionManager = TransitionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 140
        tableView.rowHeight = UITableViewAutomaticDimension
        
        story = JSON(data!)
        comments = story["comments"]
        commentsFromArray(data?.valueForKey("comments") as NSArray)
    }
    
    func commentsFromArray(comments: NSArray) {
        var newComments = NSMutableArray()
        comments.enumerateObjectsUsingBlock { (comment, idx, stop) -> Void in
            
        }
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
            toView.story = story
        }
    }
    
    @IBAction func shareBarButtonPressed(sender: AnyObject) {
        var shareString = story["title"].string!
        var shareURL = NSURL(string: story["url"].string!)!
        let activityViewController = UIActivityViewController(activityItems: [shareString, shareURL], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityTypeAirDrop]
        presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    // MARK: StoriesTableViewCellDelegate
    func upvoteButtonPressed(cell: StoriesTableViewCell, sender: AnyObject) {
        var indexPath = tableView.indexPathForCell(cell)!
        var id = toString(story["id"].int!)
        
        if token.isEmpty {
            performSegueWithIdentifier("LoginSegue", sender: self)
        }
        else {
            postUpvote(id)
            saveUpvote(id)
            let upvoteInt = story["vote_count"].int! + 1
            let upvoteString = toString(upvoteInt)
            cell.upvoteButton.setTitle(upvoteString, forState: UIControlState.Normal)
            cell.upvoteButton.setImage(UIImage(named: "icon-upvote-active"), forState: UIControlState.Normal)
        }
    }
    
    func commentButtonPressed(cell: StoriesTableViewCell, sender: AnyObject) {
    }
    
    func replyButtonPressed(cell: StoriesTableViewCell, sender: AnyObject) {
        var indexPath = tableView.indexPathForCell(cell)!
        var comment = comments[indexPath.row].dictionaryObject
        
        performSegueWithIdentifier("CommentSegue", sender: comment)
    }
    
    // MARK: TableViewDelegate
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + comments.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var identifier = "cell"
        if indexPath.row > 0 {
            identifier = "comment"
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as StoriesTableViewCell
        
        if indexPath.row == 0 {
            configureCell(cell, data: story!)
        }
        else {
            configureCell(cell, data: comments[indexPath.row-1])
        }
        
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            performSegueWithIdentifier("WebSegue", sender: self)
            UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Slide)
        }
    }
    
    // MARK: Misc
    func configureCell(cell: StoriesTableViewCell, data: JSON!) {
        
        if let title = data["title"].string? {
            cell.titleLabel.text = title
        }
        
        if let name = data["user_display_name"].string? {
            if let job = data["user_job"].string? {
                cell.authorLabel.text = name + ", " + job
            }
        }
        
        cell.upvoteButton.setTitle(toString(data["vote_count"]), forState: UIControlState.Normal)
        
        let timeAgo = dateFromString(data["created_at"].string!, "yyyy-MM-dd'T'HH:mm:ssZ")
        cell.timeLabel.text = timeAgoSinceDate(timeAgo, true)
        
        if let badge = data["badge"].string? {
            cell.storyImageView.image = UIImage(named: "badge-\(badge)")
        }
        
        cell.avatarImageView.image = UIImage(named: "content-avatar-default")
        if let urlString = data["user_portrait_url"].string? {
            ImageLoader.sharedLoader.imageForUrl(urlString, completionHandler:{(image: UIImage?, url: String) in
                cell.avatarImageView.image = image
            })
        }
        
        cell.commentTextView.layoutSubviews()
        cell.commentTextView.sizeToFit()
        cell.commentTextView.contentInset = UIEdgeInsetsMake(-4, -4, -4, -4)
        let cssString = "<style>img { max-width: 320px; } </style>"
        
        if let comment = data["body_html"].string? {
            cell.commentTextView.attributedText = htmlToAttributedString(cssString + comment)
        }
        
        if let comment = data["comment_html"].string? {
            cell.commentTextView.attributedText = htmlToAttributedString(cssString + comment)
            if comment == "" {
                cell.commentTextView.hidden = true
            }
        }
        cell.commentTextView.font = UIFont(name: "Avenir Next", size: 16)
    }
}
