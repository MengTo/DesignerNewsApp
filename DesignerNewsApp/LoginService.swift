//
//  LoginService.swift
//  DesignerNewsApp
//
//  Created by James Tang on 18/3/15.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit

private let LoginNotification = "UserDidLoginNotification"
private let LogoutNotification = "UserDidLogoutNotification"

class LoginAction : NSObject, LoginViewControllerDelegate {

    typealias LoginHandler = ()->()

    private var loginHandler : LoginHandler?

    init(viewController: UIViewController, completion: LoginHandler?) {
        super.init()
        loginHandler = completion
        let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        loginViewController.modalPresentationStyle = .OverCurrentContext
        loginViewController.modalTransitionStyle = .CrossDissolve
        loginViewController.delegate = self
        viewController.presentViewController(loginViewController, animated: false, completion: nil)
    }

    func didLogin(completion: LoginHandler) {
        loginHandler = completion
    }

    func loginViewControllerDidLogin(controller: LoginViewController) {
        loginHandler?()
        NSNotificationCenter.defaultCenter().postNotificationName(LoginNotification, object: nil)
    }
}

class LogoutAction : NSObject {

    override init() {
        super.init()
        LocalStore.logout()
        NSNotificationCenter.defaultCenter().postNotificationName(LogoutNotification, object: nil)
    }
}

class LoginStateHandler : NSObject {

    typealias ChangeHandler = (LoginState)->()

    enum LoginState {
        case LoggedIn, LoggedOut
    }

    private var changeHandler : ChangeHandler?

    init(handler : ChangeHandler) {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loginNotification:", name: LoginNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "logoutNotification:", name: LogoutNotification, object: nil)
        changeHandler = handler
        let isLoggedIn = LocalStore.accessToken() != nil
        handler(isLoggedIn ? .LoggedIn : .LoggedOut)
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func loginNotification(notification: NSNotification) {
        changeHandler?(.LoggedIn)
    }

    func logoutNotification(notification: NSNotification) {
        changeHandler?(.LoggedOut)
    }

}

