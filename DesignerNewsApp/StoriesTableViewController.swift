//
//  StoriesTableViewController.swift
//  DesignerNewsApp
//
//  Created by Meng To on 2015-01-08.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit

class StoriesTableViewController: UITableViewController, StoriesTableViewCellDelegate, LoginViewControllerDelegate {
    
    var transitionManager = TransitionManager()
    var stories: JSON = nil
    var firstTime = true
    var token = getToken()
    @IBOutlet weak var loginButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getStories("1", { (json) -> () in
            self.stories = json["stories"]
            self.tableView.reloadData()
            hideLoading()
        })
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        if token.isEmpty {
            loginButton.title = "Login"
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if firstTime {
            showLoading(view)
            firstTime = false
        }
    }
    
    // MARK: Login
    func loginCompleted() {
        token = getToken()
        loginButton.title = "Logout"
        viewDidLoad()
    }
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        if token.isEmpty {
            performSegueWithIdentifier("storiesToLoginSegue", sender: self)
        }
        else {
            deleteToken(0)
            token = ""
            viewDidLoad()
        }
    }
    
    // MARK: TableViewDelegate
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as StoriesTableViewCell
        configureCell(cell, story: stories[indexPath.row])
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var story = stories[indexPath.row].dictionaryObject
        self.performSegueWithIdentifier("storiesToWebSegue", sender: story)
    }
    
    // MARK: StoriesTableViewCellDelegate
    func upvoteButtonPressed(cell: StoriesTableViewCell, sender: AnyObject) {
        var indexPath = tableView.indexPathForCell(cell)!
        var id = toString(stories[indexPath.row]["id"].int!)
        
        if token.isEmpty {
            performSegueWithIdentifier("storiesToLoginSegue", sender: self)
        }
        else {
            postUpvote(id, { (data) -> () in
                println(data)
            })
        }
    }
    
    func commentButtonPressed(cell: StoriesTableViewCell, sender: AnyObject) {
        var indexPath = tableView.indexPathForCell(cell)!
        var story = stories[indexPath.row].dictionaryObject
        performSegueWithIdentifier("storiesToArticleSegue", sender: story)
    }
    
    func replyButtonPressed(cell: StoriesTableViewCell, sender: AnyObject) {
    }
    
    // MARK: Misc
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "storiesToArticleSegue" {
            let articleViewController = segue.destinationViewController as ArticleTableViewController
            articleViewController.data = sender
        }
        else if segue.identifier == "storiesToWebSegue" {
            let webViewController = segue.destinationViewController as WebViewController
            webViewController.data = sender
            
            webViewController.transitioningDelegate = self.transitionManager
        }
        else if segue.identifier == "storiesToLoginSegue" {
            let loginViewController = segue.destinationViewController as LoginViewController
            loginViewController.delegate = self
        }
        else if segue.identifier == "storiesToMenuSegue" {
            let menuViewController = segue.destinationViewController as MenuViewController
        }
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
        
        cell.avatarImageView.image = UIImage(named: "content-avatar-default")
        if let urlString = story["user_portrait_url"].string? {
            ImageLoader.sharedLoader.imageForUrl(urlString, completionHandler:{(image: UIImage?, url: String) in
                cell.avatarImageView.image = image
            })
        }
    }
}
