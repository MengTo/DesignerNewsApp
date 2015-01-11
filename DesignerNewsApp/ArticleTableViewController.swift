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
    var transitionManager = TransitionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 140
        tableView.rowHeight = UITableViewAutomaticDimension
        
        story = JSON(data!)
        comments = story["comments"]
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "articleToCommentSegue" {
            let toView = segue.destinationViewController as CommentViewController
            toView.data = sender
            
            toView.transitioningDelegate = self.transitionManager
        }
    }
    
    // MARK: StoriesTableViewCellDelegate
    func upvoteButtonPressed(cell: StoriesTableViewCell, sender: AnyObject) {
    }
    
    func commentButtonPressed(cell: StoriesTableViewCell, sender: AnyObject) {
    }
    
    func replyButtonPressed(cell: StoriesTableViewCell, sender: AnyObject) {
        var indexPath = tableView.indexPathForCell(cell)!
        var comment = comments[indexPath.row].dictionaryObject
        
        performSegueWithIdentifier("articleToCommentSegue", sender: comment)
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
    
    // MARK: Misc
    func configureCell(cell: StoriesTableViewCell, data: JSON!) {
        
        if let title = data["title"].string? {
            cell.titleLabel.text = title
        }
        
        cell.authorLabel.text = data["user_display_name"].string
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
        
        if let comment = data["body"].string? {
            cell.commentLabel.text = comment
        }
        
        if let comment = data["comment"].string? {
            cell.commentLabel.text = comment
            if comment == "" {
                cell.commentLabel.hidden = true
            }
        }
    }
}
