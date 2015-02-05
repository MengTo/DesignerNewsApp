//
//  StoriesTableViewController.swift
//  DesignerNewsApp
//
//  Created by Meng To on 2015-01-08.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit
import Spring

class StoriesTableViewController: UITableViewController, StoryTableViewCellDelegate, LoginViewControllerDelegate, MenuViewControllerDelegate, UISearchBarDelegate {
    
    private let transitionManager = TransitionManager()
    private var stories = [Story]()
    private var firstTime = true
    private var keyword : String = ""
    private var lastStorySection : StoriesLoader.StorySection = .Default
    private var storiesLoader = StoriesLoader(.Default)
    private var selectedIndexPath : NSIndexPath?
    private var searchBar : UISearchBar?

    @IBOutlet weak var loginButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl?.addTarget(self, action: "refreshControlValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
        
        tableView.estimatedRowHeight = 125
        tableView.rowHeight = UITableViewAutomaticDimension
        
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Avenir Next", size: 18)!], forState: UIControlState.Normal)
        
        loginButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Avenir Next", size: 18)!], forState: UIControlState.Normal)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = self.selectedIndexPath {
            tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None)
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            self.selectedIndexPath = nil
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if firstTime {
            loadStories()
            firstTime = false
        }
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Fade)

        // Reload Data is important because we need
        // to have our upvote and visited state updated
        self.tableView.reloadData()
    }
    
    func loadStories() {

        view.showLoading()

        storiesLoader.load(completion: { [unowned self] stories in
            self.stories = stories
            self.tableView.reloadData()
            self.view.hideLoading()
            self.refreshControl?.endRefreshing()
        })

        if LocalStore.accessToken() == nil {
            loginButton.title = "Login"
            loginButton.enabled = true
        } else {
            loginButton.title = ""
            loginButton.enabled = false
        }
    }

    func loadMoreStories() {
        storiesLoader.next { [unowned self] stories in
            self.stories += stories
            self.tableView.reloadData()
        }
    }
    
    // MARK: MenuViewControllerDelegate
    func menuViewControllerDidSelectTopStories(controller: MenuViewController) {
        lastStorySection = .Default
        storiesLoader = StoriesLoader(self.lastStorySection)
        clearSearch()
        loadStories()
    }
    
    func menuViewControllerDidSelectRecent(controller: MenuViewController) {
        lastStorySection = .Recent
        storiesLoader = StoriesLoader(self.lastStorySection)
        clearSearch()
        loadStories()
    }

    func menuViewControllerDidSelectLogout(controller: MenuViewController) {
        logout()
    }

    func menuViewControllerDidSelectLogin(controller: MenuViewController) {
        loginCompleted()
    }

    func menuViewControllerDidSelectCloseMenu(controller: MenuViewController) {
        if let button = navigationItem.leftBarButtonItem?.customView as? MenuControl {
            button.menuAnimation()
        }
    }

    // MARK: LoginViewControllerDelegate
    func loginViewControllerDidLogin(controller: LoginViewController) {
        loginCompleted()
    }

    // MARK: Action
    @IBAction func loginButtonPressed(sender: AnyObject) {
        if LocalStore.accessToken() == nil {
            performSegueWithIdentifier("LoginSegue", sender: self)
        } else {
            logout()
        }
    }

    @IBAction func menuButtonTouched(sender: AnyObject) {
        performSegueWithIdentifier("MenuSegue", sender: sender)
    }

    func refreshControlValueChanged(sender: AnyObject) {
        self.loadStories()
    }

    // MARK: Misc

    func clearSearch() {
        keyword = ""
        searchBar?.text = nil

        switch (self.lastStorySection) {
        case .Recent:
            title = "Recent Stories"
        case .Default:
            title = "Top Stories"
        default: break
        }
    }

    func loginCompleted() {
        loadStories()
    }

    func logout() {
        LocalStore.deleteAccessToken()
        loadStories()
    }

    // MARK: TableViewDelegate

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count + (storiesLoader.hasMore ? 1 : 0)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if indexPath.row == stories.count {
            let cell = tableView.dequeueReusableCellWithIdentifier("loadingCell") as LoadingTableViewCell

            if keyword.length > 0 {
                cell.stopAnimating()
            }
            return cell
        }

        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as StoryTableViewCell
        cell.frame = tableView.bounds

        configureCell(cell, atIndexPath:indexPath)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        LocalStore.setStoryAsVisited(stories[indexPath.row].id)
        self.performSegueWithIdentifier("WebSegue", sender: tableView.cellForRowAtIndexPath(indexPath))
        reloadRowAtIndexPath(indexPath)
    }

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == self.stories.count && self.keyword.length == 0 {
            self.loadMoreStories()
        }
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if searchBar == nil {
            searchBar = UISearchBar(frame: CGRectMake(0, 0, tableView.frame.size.width, 44))
            searchBar?.text = self.keyword
            searchBar?.delegate = self
//            searchBar?.showsCancelButton = true
        }
        return searchBar
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45;
    }
    
    // MARK: StoriesTableViewCellDelegate

    func storyTableViewCell(cell: StoryTableViewCell, upvoteButtonPressed sender: AnyObject) {

        if let token = LocalStore.accessToken() {
            let indexPath = tableView.indexPathForCell(cell)!
            let story = self.stories[indexPath.row]
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
            performSegueWithIdentifier("LoginSegue", sender: self)
        }
    }

    func storyTableViewCell(cell: StoryTableViewCell, commentButtonPressed sender: AnyObject) {
        var indexPath = tableView.indexPathForCell(cell)!
        let story = stories[indexPath.row]
        LocalStore.setStoryAsVisited(story.id)
        performSegueWithIdentifier("CommentsSegue", sender: cell)
        reloadRowAtIndexPath(indexPath)
    }

    // MARK: Misc
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "CommentsSegue" {
            let indexPath = tableView.indexPathForCell(sender as UITableViewCell)
            let story = stories[indexPath!.row]
            let commentsViewController = segue.destinationViewController as CommentsTableViewController
            commentsViewController.story = story
            self.selectedIndexPath = indexPath
        }
        else if segue.identifier == "WebSegue" {

            let webViewController = segue.destinationViewController as WebViewController

            if let indexPath = tableView.indexPathForCell(sender as UITableViewCell) {
                let story = stories[indexPath.row]
                webViewController.shareTitle = story.title
                webViewController.url = NSURL(string: story.url)
                self.selectedIndexPath = indexPath

            } else if let url = sender as? NSURL {
                webViewController.url = url
            }

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

    func configureCell(cell: StoryTableViewCell, atIndexPath indexPath: NSIndexPath) {
        let story = stories[indexPath.row]
        let isUpvoted = LocalStore.isStoryUpvoted(story.id)
        let isVisited = LocalStore.isStoryVisited(story.id)
        let isReplied = LocalStore.isStoryReplied(story.id)
        cell.configureWithStory(story, isUpvoted: isUpvoted, isVisited: isVisited, isReplied: isReplied)
        cell.delegate = self
    }

    func reloadRowAtIndexPath(indexPath: NSIndexPath) {
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
    }

    // MARK: UISearchBarDelegate

    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        clearSearch()
        searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        keyword = searchBar.text
        searchBar.resignFirstResponder()
    }

    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }

    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)

        if keyword.length > 0 {
            title = "Search Results"
            storiesLoader = StoriesLoader(.Search(keyword))
            loadStories()
        } else {
            storiesLoader = StoriesLoader(self.lastStorySection)
            loadStories()
        }
        return true
    }
}
