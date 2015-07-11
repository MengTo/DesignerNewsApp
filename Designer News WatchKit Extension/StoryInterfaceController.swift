//
//  StoryInterfaceController.swift
//  DesignerNewsApp
//
//  Created by André Schneider on 11.07.15.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import WatchKit
import Foundation

class StoryInterfaceController: WKInterfaceController {

    @IBOutlet weak var storyLabel: WKInterfaceLabel!

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
