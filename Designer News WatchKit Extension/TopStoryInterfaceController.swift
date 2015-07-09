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

extension WKInterfaceTable {
    enum RowType: String {
        case StoryRowController = "StoryRowController"
    }

    func setNumberOfRows(numberOfRows: Int, withRowType rowType: RowType) {
        setNumberOfRows(numberOfRows, withRowType: rowType.rawValue)
    }
}

class TopStoryInterfaceController: WKInterfaceController {

    @IBOutlet weak var table: WKInterfaceTable!

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        DesignerNewsService.storiesForSection("", page: 1, keyword: nil) { [unowned self] stories in
            self.table.setNumberOfRows(stories.count, withRowType: .StoryRowController)
            map(enumerate(stories), self.configureRowAtIndex)
        }
        super.willActivate()
    }

    private func configureRowAtIndex(index: Int, withStory story: Story) {
        if let row = self.table.rowControllerAtIndex(index) as? StoryRowController {
            row.titleLabel.setText(story.title)
            row.authorLabel.setText(story.userDisplayName)
            row.commentCountLabel.setText(story.commentCount.description)
            row.upvoteCountLabel.setText(story.voteCount.description)
            if !story.badge.isEmpty {
                row.badgeImage.setImageNamed("badge-\(story.badge)")
            }
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
