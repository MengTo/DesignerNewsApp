//
//  ArticleTableViewController.swift
//  DesignerNewsApp
//
//  Created by Meng To on 2015-01-09.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit

class ArticleTableViewController: UITableViewController {

    var data: AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 140
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as StoriesTableViewCell
        
        if indexPath.row == 0 {
            configureCell(cell, story: JSON(data!))
        }
        
        return cell
    }
    
    func configureCell(cell: StoriesTableViewCell, story: JSON) {
        
        cell.titleLabel.text = story["title"].string
        cell.authorLabel.text = story["user_display_name"].string
        cell.upvoteButton.setTitle(toString(story["vote_count"]), forState: UIControlState.Normal)
        cell.commentButton.setTitle(toString(story["comment_count"]), forState: UIControlState.Normal)
        
        var timeAgo = dateFromString(story["created_at"].string!, "yyyy-MM-dd'T'HH:mm:ssZ")
        cell.timeLabel.text = timeAgoSinceDate(timeAgo, true)
        
        if let badge = story["badge"].string? {
            cell.storyImageView.image = UIImage(named: "badge-\(badge)")
        }
        else {
            cell.storyImageView.image = nil
        }
        
        if let urlString = story["user_portrait_url"].string? {
            ImageLoader.sharedLoader.imageForUrl(urlString, completionHandler:{(image: UIImage?, url: String) in
                cell.avatarImageView.image = image
            })
        }
        else {
            cell.avatarImageView.image = UIImage(named: "content-avatar-default")
        }
        
        if story["comment"].string != "" {
            cell.commentLabel.text = story["comment"].string
        }
        else {
            cell.commentLabel.text = nil
        }
    }
}
