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

    @IBOutlet weak var loadingLabel: WKInterfaceLabel!
    @IBOutlet weak var table: WKInterfaceTable!
    private var storySection: DesignerNewsService.StorySection = .Default
    private var stories = [Story]()

    private var needsRendering = false
    private var tableRowsAreRedered = false

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
    }

    override func willActivate() {
        loadingLabel.setText("Loading...")
        loadStories()
        super.willActivate()
    }

    private func loadStories() {
        tableRowsAreRedered = false
        DesignerNewsService.storiesForSection(storySection, page: 1) { [weak self] stories in
            if let strongSelf = self {
                strongSelf.tableRowsAreRedered = true
                if let firstRequestedStory = stories.first, let firstLocalStory = strongSelf.stories.first where firstRequestedStory == firstLocalStory && !strongSelf.needsRendering {
                    return
                }
                strongSelf.table.setNumberOfRows(stories.count, withRowType: .StoryRowController)
                map(enumerate(stories), strongSelf.configureRowAtIndex)
                strongSelf.stories = stories
                strongSelf.loadingLabel.setHidden(true)
            }
        }
    }

    private func configureRowAtIndex(index: Int, withStory story: Story) {
        if let row = self.table.rowControllerAtIndex(index) as? StoryRowController {
            row.titleLabel.setText(story.title)
            row.authorLabel.setText(story.userDisplayName)
            row.commentCountLabel.setText(story.commentCount.description)
            row.upvoteCountLabel.setText(story.voteCount.description)
            row.badgeImage.setHidden(story.badge.isEmpty)
            if !story.badge.isEmpty {
                row.badgeImage.setImageNamed("badge-\(story.badge)")
            }
        }
    }

    override func didDeactivate() {
        needsRendering = !tableRowsAreRedered
        super.didDeactivate()
    }

}
