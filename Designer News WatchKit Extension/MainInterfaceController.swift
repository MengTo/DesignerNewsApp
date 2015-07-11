//
//  SelectionInterfaceController.swift
//  DesignerNewsApp
//
//  Created by André Schneider on 09.07.15.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import WatchKit
import Foundation

class MainInterfaceController: WKInterfaceController {
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        WKInterfaceController.reloadRootControllersWithNames(
            ["StoriesInterfaceController", "StoriesInterfaceController"],
            contexts: ["Top","Recent"]
        )
    }
}
