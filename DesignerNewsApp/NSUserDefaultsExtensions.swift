//
//  NSUserDefaultsExtensions.swift
//  DesignerNewsApp
//
//  Created by André Schneider on 27.01.15.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit

extension NSUserDefaults {
    private var visitedStoriesKey: String { return "visitedStoriesKey" }

    func setStoryAsVisited(storyId: Int) {
        let visitedStories = arrayForKey(visitedStoriesKey) as? [Int] ?? []
        if !contains(visitedStories, storyId) {
            setObject(visitedStories + [storyId], forKey: visitedStoriesKey)
            synchronize()
        }
    }

    func isStoryVisited(storyId: Int) -> Bool {
        let visitedStories = arrayForKey(visitedStoriesKey) as? [Int] ?? []
        return contains(visitedStories, storyId)
    }
}
