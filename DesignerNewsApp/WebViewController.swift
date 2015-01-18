//
//  WebViewController.swift
//  DesignerNewsApp
//
//  Created by Meng To on 2015-01-10.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var webView: UIWebView!
    var timer = NSTimer()
    var story: JSON = nil
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var closeButton: SpringButton!
    
    @IBAction func shareButtonPressed(sender: AnyObject) {
        var shareString = story["title"].string!
        var shareURL = NSURL(string: "http://google.com")!
        let activityViewController = UIActivityViewController(activityItems: [shareString, shareURL], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityTypeAirDrop]
        presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var url = NSURL(string: story["url"].string!)
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
        
        webView.delegate = self
    }

    func webViewDidFinishLoad(webView: UIWebView) {
        timer = NSTimer.scheduledTimerWithTimeInterval(
            0.1,
            target: self,
            selector: Selector("updateProgress"),
            userInfo: progressView,
            repeats: true
        )
    }
    
    func updateProgress() {
        if progressView.progress == 1 {
            progressView.hidden = true
            timer.invalidate()
        }
        else {
            UIView.animateWithDuration(0.1, animations: {
                self.progressView.progress += 0.1
            })
        }
    }
}
