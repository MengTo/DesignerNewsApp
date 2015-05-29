//
//  WebViewController.swift
//  DesignerNewsApp
//
//  Created by Meng To on 2015-01-10.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit
import Spring

class WebViewController: UIViewController, UIWebViewDelegate, UIScrollViewDelegate {

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var webView: UIWebView!
    private var hasFinishLoading = false
    var shareTitle : String?
    var url : NSURL!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var closeButton: SpringButton!
    @IBOutlet weak var backButton: DesignableButton!
    @IBOutlet weak var forwardButton: DesignableButton!
    @IBOutlet weak var shareButton: SpringButton!
    var pointNow = CGPoint()
    
    @IBAction func backButtonDidTouch(sender: AnyObject) {
        webView.goBack()
    }
    
    @IBAction func forwardButtonDidTouch(sender: AnyObject) {
        webView.goForward()
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        pointNow = scrollView.contentOffset
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y < pointNow.y {
            
            spring(0.5) {
                self.backButton.alpha = 1
                self.forwardButton.alpha = 1
                self.shareButton.alpha = 1
                self.closeButton.alpha = 1
                
                self.backButton.transform = CGAffineTransformMakeTranslation(0, 0)
                self.forwardButton.transform = CGAffineTransformMakeTranslation(0, 0)
                self.shareButton.transform = CGAffineTransformMakeTranslation(0, 0)
                self.closeButton.transform = CGAffineTransformMakeTranslation(0, 0)
            }
        }
        if scrollView.contentOffset.y > pointNow.y {
            spring(0.5) {
                self.backButton.alpha = 0
                self.forwardButton.alpha = 0
                self.shareButton.alpha = 0
                self.closeButton.alpha = 0
                
                self.backButton.transform = CGAffineTransformMakeTranslation(0, 10)
                self.forwardButton.transform = CGAffineTransformMakeTranslation(0, 10)
                self.shareButton.transform = CGAffineTransformMakeTranslation(0, 10)
                self.closeButton.transform = CGAffineTransformMakeTranslation(0, 10)
            }
        }
    }
    
    @IBAction func shareButtonPressed(sender: AnyObject) {
        let shareString = self.shareTitle ?? ""
        let shareURL = self.url
        let activityViewController = UIActivityViewController(activityItems: [shareString, shareURL], applicationActivities: [SafariActivity(), ChromeActivity()])
        activityViewController.setValue(shareString, forKey: "subject")
        activityViewController.excludedActivityTypes = [UIActivityTypeAirDrop]
        presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
        webView.delegate = self
        
        webView.scrollView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        if webView.loading {
            webView.stopLoading()
        }
        
        let alert = UIAlertController(title: "Stopped Loading", message: "This site is memory intensive and may cause a crash. Please use a browser instead.", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss",
            style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
        }))
        
        alert.addAction(UIAlertAction(title: "Open in Safari",
            style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                UIApplication.sharedApplication().openURL(self.url)
                return
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }

    func webViewDidStartLoad(webView: UIWebView) {
        hasFinishLoading = false
        updateProgress()
    }

    func webViewDidFinishLoad(webView: UIWebView) {
        shareTitle = webView.stringByEvaluatingJavaScriptFromString("document.title");
        url = webView.request!.URL!
        delay(1) { [weak self] in
            if let _self = self {
                _self.hasFinishLoading = true
            }
        }
    }
    
    func updateProgress() {
        if progressView.progress >= 1 {
            progressView.hidden = true
        } else {

            if hasFinishLoading {
                progressView.progress += 0.002
            } else {
                if progressView.progress <= 0.3 {
                    progressView.progress += 0.004
                } else if progressView.progress <= 0.6 {
                    progressView.progress += 0.002
                } else if progressView.progress <= 0.9 {
                    progressView.progress += 0.001
                } else if progressView.progress <= 0.94 {
                    progressView.progress += 0.0001
                } else {
                    progressView.progress = 0.9401
                }
            }

            delay(0.008) { [weak self] in
                if let _self = self {
                    _self.updateProgress()
                }
            }
        }
    }

    deinit {
        webView.stopLoading()
        webView.delegate = nil
    }
}
