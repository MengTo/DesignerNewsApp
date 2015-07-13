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

class StoriesInterfaceController: WKInterfaceController {

    @IBOutlet weak var table: WKInterfaceTable!
    private var storySection: DesignerNewsService.StorySection = .Default
    private var stories = [Story]()

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        if let title = context as? String {
            setTitle(title)
            switch title {
            case "Top": storySection = .Default
            case "Recent": storySection = .Recent
            default: break
            }
        }
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        DesignerNewsService.storiesForSection(storySection, page: 1) { [weak self] stories in
            if let strongSelf = self {
                strongSelf.stories = stories
                strongSelf.table.setNumberOfRows(stories.count, withRowType: .StoryRowController)
                map(enumerate(stories), strongSelf.configureRowAtIndex)
            }
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
