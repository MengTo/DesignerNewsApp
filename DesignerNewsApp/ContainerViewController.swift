//
//  ContainerViewController.swift
//  DesignerNewsApp
//
//  Created by James Tang on 16/3/15.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit

class ContainerViewController: UIPageViewController {

    @IBOutlet weak var loginButton: UIBarButtonItem!

    lazy var _controllers : [StoriesTableViewController] = {
        let topStories = self.storyboard?.instantiateViewControllerWithIdentifier("StoriesTableViewController") as StoriesTableViewController


        let recentStories = self.storyboard?.instantiateViewControllerWithIdentifier("StoriesTableViewController") as StoriesTableViewController

        recentStories.storySection = .Recent

        return [topStories, recentStories]
        }()

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "MenuSegue" {
            let menuViewController = segue.destinationViewController as MenuViewController
            menuViewController.delegate = self
        } else if segue.identifier == "LoginSegue" {
            let loginViewController = segue.destinationViewController as LoginViewController
            loginViewController.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()

        self.dataSource = self
        self.delegate = self

        self.loginButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Avenir Next", size: 18)!], forState: UIControlState.Normal)

        self.turnToPage(0)
    }

    func configureForDisplayingViewController(controller: StoriesTableViewController) {
        self.navigationItem.titleView = controller.navigationItem.titleView
        self.navigationItem.title = controller.navigationItem.title

        for vc in _controllers {
            // Fix scroll to top when more than one scroll view on screen
            vc.tableView.scrollsToTop = controller === vc
        }
    }

    func turnToPage(index: Int) {
        let controller = _controllers[index]

        var direction = UIPageViewControllerNavigationDirection.Forward

        if let currentViewController = self.viewControllers.first as? UIViewController {
            let currentIndex = (_controllers as NSArray).indexOfObject(currentViewController)

            if currentIndex > index {
                direction = UIPageViewControllerNavigationDirection.Reverse
            }
        }

        self.configureForDisplayingViewController(controller)
        self.setViewControllers([controller],
            direction: direction,
            animated: true) { (completion) -> Void in

        }
    }

    func loginCompleted() {
        if LocalStore.accessToken() == nil {
            loginButton.title = "Login"
            loginButton.enabled = true
        } else {
            loginButton.title = ""
            loginButton.enabled = false
        }
    }

    func logout() {
        LocalStore.logout()
    }

    // MARK: Action
    @IBAction func menuButtonTouched(sender: AnyObject) {
        performSegueWithIdentifier("MenuSegue", sender: sender)
    }

    @IBAction func loginButtonPressed(sender: AnyObject) {
        if LocalStore.accessToken() == nil {
            performSegueWithIdentifier("LoginSegue", sender: self)
        } else {
            logout()
        }
    }

}

extension ContainerViewController : LoginViewControllerDelegate {

    // MARK: LoginViewControllerDelegate
    func loginViewControllerDidLogin(controller: LoginViewController) {
        loginCompleted()
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

extension  ContainerViewController : MenuViewControllerDelegate {

    // MARK: MenuViewControllerDelegate
    func menuViewControllerDidSelectTopStories(controller: MenuViewController) {
        self.turnToPage(0)
    }

    func menuViewControllerDidSelectRecent(controller: MenuViewController) {
        self.turnToPage(1)
    }

    func menuViewControllerDidSelectLogout(controller: MenuViewController) {
//        logout()

        println("didSelect logout")
    }

    func menuViewControllerDidSelectLogin(controller: MenuViewController) {
//        loginCompleted()
        println("didSelect login")
    }

    func menuViewControllerDidSelectCloseMenu(controller: MenuViewController) {
        if let button = navigationItem.leftBarButtonItem?.customView as? MenuControl {
            button.menuAnimation()
        }
    }

}
