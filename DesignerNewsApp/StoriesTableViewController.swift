//
//  StoriesTableViewController.swift
//  DesignerNewsApp
//
//  Created by Meng To on 2015-01-08.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit
import Haneke

class StoriesTableViewController: UITableViewController {

    var stories: JSON = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getStories("1", { (json) -> () in
            self.stories = json["stories"]
            self.tableView.reloadData()
        })
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as StoriesTableViewCell
        configureCell(cell, indexPath: indexPath)
        
        return cell
    }
    
    func configureCell(cell: StoriesTableViewCell, indexPath: NSIndexPath) {
        var story = stories[indexPath.row]
        
        cell.titleLabel.text = story["title"].string
        cell.authorLabel.text = story["user_display_name"].string
        cell.upvoteButton.setTitle(toString(story["vote_count"]), forState: UIControlState.Normal)
        cell.commentButton.setTitle(toString(story["comment_count"]), forState: UIControlState.Normal)
        cell.timeLabel.text = "4h"
        
        if let badge = story["badge"].string? {
            cell.storyImageView.image = UIImage(named: "badge-\(badge)")
        }
        
        if let urlString = story["user_portrait_url"].string? {
            let URL = NSURL(string: urlString)!
            cell.avatarImageView.hnk_setImageFromURL(URL)
        }
    }
}
