//
//  ContainerViewController.swift
//  DesignerNewsApp
//
//  Created by James Tang on 16/3/15.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit

class ContainerViewController: UIPageViewController {

    lazy var _controllers : [StoriesTableViewController] = {
        let topStories = self.storyboard?.instantiateViewControllerWithIdentifier("StoriesTableViewController") as StoriesTableViewController


        let recentStories = self.storyboard?.instantiateViewControllerWithIdentifier("StoriesTableViewController") as StoriesTableViewController

        recentStories.storySection = .Recent

        return [topStories, recentStories]
        }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()

        self.dataSource = self
        self.delegate = self

        let firstViewController = _controllers[0]
        self.configureForDisplayingViewController(firstViewController)
        self.setViewControllers([firstViewController],
            direction: UIPageViewControllerNavigationDirection.Forward,
            animated: true) { (completion) -> Void in

        }
    }

    func configureForDisplayingViewController(controller: StoriesTableViewController) {
        self.navigationItem.leftBarButtonItem = controller.navigationItem.leftBarButtonItem
        self.navigationItem.titleView = controller.navigationItem.titleView
        self.navigationItem.rightBarButtonItem = controller.navigationItem.rightBarButtonItem
        self.navigationItem.title = controller.navigationItem.title


        for vc in _controllers {
            // Fix login button for the other vc after login/logout
            vc.refreshLoginState()

            // Fix scroll to top when more than one scroll view on screen
            vc.tableView.scrollsToTop = controller === vc
        }
    }

}

extension ContainerViewController : UIPageViewControllerDataSource {

    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {

        let index = (_controllers as NSArray).indexOfObject(viewController)

        if index > 0 {
            return _controllers[index - 1]
        }

        return nil
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {

        let index = (_controllers as NSArray).indexOfObject(viewController)

        if index < _controllers.count - 1 {
            return _controllers[index + 1]
        }

        return nil
    }

}

extension ContainerViewController : UIPageViewControllerDelegate {

    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [AnyObject]) {
        self.configureForDisplayingViewController(pendingViewControllers.first as StoriesTableViewController)
    }

    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject], transitionCompleted completed: Bool) {
        if !completed {
            self.configureForDisplayingViewController(previousViewControllers.first as StoriesTableViewController)
        }
    }

}
