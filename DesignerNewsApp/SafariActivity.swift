//
//  SafariActivity.swift
//  DesignerNewsApp
//
//  Created by André Schneider on 16.03.15.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit

class SafariActivity: UIActivity {
    private var url: NSURL?

    override func activityType() -> String? {
        return "SafariActivity"
    }

    override func activityTitle() -> String? {
        return "Open in Safari"
    }

    override func activityImage() -> UIImage? {
        return UIImage(named: "safari-activity-icon")
    }

    override func canPerformWithActivityItems(activityItems: [AnyObject]) -> Bool {
        for item in activityItems {
            if let item = item as? NSURL {
                if UIApplication.sharedApplication().canOpenURL(item) {
                    return true
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
            UIApplication.sharedApplication().openURL(url)
        }
    }
}
