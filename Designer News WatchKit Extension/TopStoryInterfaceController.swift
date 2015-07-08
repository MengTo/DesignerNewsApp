//
//  InterfaceController.swift
//  Designer News WatchKit Extension
//
//  Created by André Schneider on 08.07.15.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import WatchKit
import Foundation
import DesignerNewsKit

class TopStoryInterfaceController: WKInterfaceController {

    @IBOutlet weak var table: WKInterfaceTable!

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        DesignerNewsService.storiesForSection("", page: 1, keyword: nil) { [unowned self] stories in
            self.table.setNumberOfRows(stories.count, withRowType: "StoryRowController")
            for (index, story) in enumerate(stories) {
                self.configureRowAtIndex(index, withStory: story)
            }
        }
        super.willActivate()
    }

    private func configureRowAtIndex(index: Int, withStory story: Story) {
        if let row = self.table.rowControllerAtIndex(index) as? StoryRowController {
            row.textLabel.setText(story.title)
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
