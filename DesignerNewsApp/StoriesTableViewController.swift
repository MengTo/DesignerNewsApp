//
//  StoriesTableViewController.swift
//  DesignerNewsApp
//
//  Created by Meng To on 2015-01-08.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit
import Spring
import DesignerNewsKit

class StoriesTableViewController: UITableViewController, StoryTableViewCellDelegate, UISearchBarDelegate {

    private let transitionManager = TransitionManager()
    private var stories = [Story]()
    private var firstTime = true
    private var keyword : String = ""
    private var lastStorySection : DesignerNewsService.StorySection = .Default
    private var storiesLoader = StoriesLoader(.Default)
    private var selectedIndexPath : NSIndexPath?
    private var searchBar : UISearchBar?
    private var loginStateHandler : LoginStateHandler!
    private var loginAction : LoginAction?

    var storySection : DesignerNewsService.StorySection = .Default {
        didSet {
            storiesLoader = StoriesLoader(storySection)

            switch (storySection) {
            case .Default:
                title = "Top Stories"
            case .Recent:
                title = "Recent Stories"
            default:
                title = "Search"
            }

            if self.isViewLoaded() {
                loadStories()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 125
        tableView.rowHeight = UITableViewAutomaticDimension
        
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Avenir Next", size: 18)!], forState: UIControlState.Normal)

        self.loginStateHandler = LoginStateHandler(handler: { [weak self] (state) -> () in
            if let strongSelf = self {
                strongSelf.loadStories()
            }
        })
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


        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Fade)

        // Reload Data is important because we need
        // to have our upvote and visited state updated
        self.tableView.reloadData()

        switch (storySection) {
        case .Search(_):
            if stories.count == 0 {
                self.searchBar!.becomeFirstResponder()
            }
            break
        default:
            if firstTime {
                view.showLoading()
                loadStories()
            }
            firstTime = false
        }
    }
    
    func loadStories() {
        storiesLoader.load(completion: { [unowned self] stories in
            self.stories = stories
            self.tableView.reloadData()
            self.view.hideLoading()
            self.refreshControl?.endRefreshing()
        })
    }

    func loadMoreStories() {
        storiesLoader.next { [unowned self] stories in
            self.stories += stories
            self.tableView.reloadData()
        }
    }

    @IBAction func refreshControlValueChanged(sender: AnyObject) {
        self.loadStories()
    }

    // MARK: TableViewDelegate

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count + (storiesLoader.hasMore ? 1 : 0)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if indexPath.row == stories.count {
            let cell = tableView.dequeueReusableCellWithIdentifier("loadingCell") as! LoadingTableViewCell

            if keyword.length > 0 {
                cell.stopAnimating()
            }
            return cell
        }

        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! StoryTableViewCell
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

        switch (storySection) {
        case .Search(_):
            break
        default:
            return nil
        }

        if searchBar == nil {
            searchBar = UISearchBar(frame: CGRectMake(0, 0, tableView.frame.size.width, 44))
            searchBar?.text = self.keyword
            searchBar?.delegate = self
            searchBar?.backgroundColor = UIColor(hex: "EBF0F5")
            searchBar?.searchBarStyle = UISearchBarStyle.Minimal
//            searchBar?.showsCancelButton = true
        }
        return searchBar
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        switch (storySection) {
        case .Search(_):
            return 45
        default:
            return 0
        }
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
            self.loginAction = LoginAction(viewController: self, completion: nil)
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
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
            let story = stories[indexPath!.row]
            let commentsViewController = segue.destinationViewController as! CommentsTableViewController
            commentsViewController.story = story
            self.selectedIndexPath = indexPath
        }
        else if segue.identifier == "WebSegue" {

            let webViewController = segue.destinationViewController as! WebViewController

            if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) {
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
        searchBar.resignFirstResponder()
        if searchBar.text.length == 0 {
            keyword = ""
            stories = []
            tableView.reloadData()
        }
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        keyword = searchBar.text
        if keyword.length > 0 {
            storiesLoader = StoriesLoader(.Search(query: keyword))
            view.showLoading()
            loadStories()
        }
        searchBar.resignFirstResponder()
    }

    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }

    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }
}
