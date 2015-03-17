//
//  ChromeActivity.swift
//  DesignerNewsApp
//
//  Created by André Schneider on 16.03.15.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit

class ChromeActivity: UIActivity {
    private var url: NSURL?

    override func activityType() -> String? {
        return "ChromeActivity"
    }

    override func activityTitle() -> String? {
        return "Open in Chrome"
    }

    override func activityImage() -> UIImage? {
        return UIImage(named: "chrome-activity-icon")
    }

    override func canPerformWithActivityItems(activityItems: [AnyObject]) -> Bool {
        if let chromeURL = NSURL(string: "googlechrome-x-callback://") {
            if !UIApplication.sharedApplication().canOpenURL(chromeURL) {
                return false
            }
            for item in activityItems {
                if let item = item as? NSURL {
                    if UIApplication.sharedApplication().canOpenURL(item) {
                        return true
                    }
                }
            }
        }
        return false
    }

    override func prepareWithActivityItems(activityItems: [AnyObject]) {
        for item in activityItems {
            if let item = item as? NSURL {
                url = item
            }
        }
    }

    override func performActivity() {
        if let url = url {
            if let chromeURL = NSURL(string: "googlechrome-x-callback://x-callback-url/open/?url=\(url)") {
                UIApplication.sharedApplication().openURL(chromeURL)
            }
        }
    }
}
