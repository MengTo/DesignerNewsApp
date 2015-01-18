//
//  StoriesTableViewController.swift
//  DesignerNewsApp
//
//  Created by Meng To on 2015-01-08.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit

class StoriesTableViewController: UITableViewController, StoriesTableViewCellDelegate, LoginViewControllerDelegate, MenuViewControllerDelegate {
    
    private let transitionManager = TransitionManager()
    var stories: JSON = nil
    var firstTime = true
    var token = getToken()
    var upvotes = getUpvotes()
    var storySection = ""
    @IBOutlet weak var loginButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadStories(self)
        
        refreshControl?.addTarget(self, action: "loadStories:", forControlEvents: UIControlEvents.ValueChanged)
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if firstTime {
            showLoading(view)
            firstTime = false
        }
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Fade)
    }
    
    func loadStories(sender: AnyObject) {
        getStories(storySection, "1", { (json) -> () in
            self.stories = json["stories"]
            self.upvotes = getUpvotes()
            self.tableView.reloadData()
            hideLoading()
            self.refreshControl?.endRefreshing()
        })
        
        if token.isEmpty {
            loginButton.title = "Login"
            loginButton.enabled = true
        }
        else {
            loginButton.title = ""
            loginButton.enabled = false
        }
    }
    
    // MARK: MenuViewControllerDelegate
    func topButtonPressed() {
        showLoading(view)
        storySection = ""
        loadStories(self)
    }
    
    func recentButtonPressed() {
        showLoading(view)
        storySection = "recent"
        loadStories(self)
    }
    
    // MARK: Login
    func loginCompleted() {
        token = getToken()
        loadStories(self)
    }
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        if token.isEmpty {
            performSegueWithIdentifier("LoginSegue", sender: self)
        }
        else {
            deleteToken(0)
            token = ""
            loadStories(self)
        }
    }
    
    func logoutButtonPressed() {
        deleteToken(0)
        token = ""
        loadStories(self)
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
        self.performSegueWithIdentifier("WebSegue", sender: story)
    }
    
    // MARK: StoriesTableViewCellDelegate
    func upvoteButtonPressed(cell: StoriesTableViewCell, sender: AnyObject) {
        var indexPath = tableView.indexPathForCell(cell)!
        var id = toString(stories[indexPath.row]["id"].int!)
        
        if token.isEmpty {
            performSegueWithIdentifier("LoginSegue", sender: self)
        }
        else {
            postUpvote(id)
            saveUpvote(id)
            let upvoteInt = stories[indexPath.row]["vote_count"].int! + 1
            let upvoteString = toString(upvoteInt)
            cell.upvoteButton.setTitle(upvoteString, forState: UIControlState.Normal)
            cell.upvoteButton.setImage(UIImage(named: "icon-upvote-active"), forState: UIControlState.Normal)
        }
    }
    
    func commentButtonPressed(cell: StoriesTableViewCell, sender: AnyObject) {
        var indexPath = tableView.indexPathForCell(cell)!
        var story = stories[indexPath.row].dictionaryObject
        performSegueWithIdentifier("ArticleSegue", sender: story)
    }
    
    func replyButtonPressed(cell: StoriesTableViewCell, sender: AnyObject) {
    }
    
    // MARK: Misc
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ArticleSegue" {
            let articleViewController = segue.destinationViewController as ArticleTableViewController
            articleViewController.data = sender
        }
        else if segue.identifier == "WebSegue" {
            let webViewController = segue.destinationViewController as WebViewController
            webViewController.story = JSON(sender!)
            
            webViewController.transitioningDelegate = self.transitionManager
            
            UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Slide)
        }
        else if segue.identifier == "LoginSegue" {
            let loginViewController = segue.destinationViewController as LoginViewController
            loginViewController.delegate = self
        }
        else if segue.identifier == "MenuSegue" {
            let menuViewController = segue.destinationViewController as MenuViewController
            menuViewController.delegate = self
        }
    }
    
    func configureCell(cell: StoriesTableViewCell, story: JSON) {
        
        cell.titleLabel.layoutSubviews()
        cell.titleLabel.text = story["title"].string
        
        if let name = story["user_display_name"].string? {
            if let job = story["user_job"].string? {
                cell.authorLabel.text = name + ", " + job
            }
        }
        
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
        
        if let id = story["id"].int? {
            if upvotes.containsObject(toString(id)) {
                let image = UIImage(named: "icon-upvote-active")
                cell.upvoteButton.setImage(image, forState: UIControlState.Normal)
            }
            else {
                let image = UIImage(named: "icon-upvote")
                cell.upvoteButton.setImage(image, forState: UIControlState.Normal)
            }
        }
        
        cell.avatarImageView.image = UIImage(named: "content-avatar-default")
        if let urlString = story["user_portrait_url"].string? {
            ImageLoader.sharedLoader.imageForUrl(urlString, completionHandler:{(image: UIImage?, url: String) in
                cell.avatarImageView.image = image
            })
        }
    }
}
