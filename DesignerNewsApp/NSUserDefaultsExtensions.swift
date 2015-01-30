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
    private var upvotedStoriesKey: String { return "upvotedStoriesKey" }
    private var upvotedCommentsKey: String { return "upvotedCommentsKey" }
    private var accessTokenKey: String { return "accessTokenKey" }

    func setStoryAsVisited(storyId: Int) {
        appendId(storyId, toKey: visitedStoriesKey)
    }

    func setStoryAsUpvoted(storyId: Int) {
        appendId(storyId, toKey: upvotedStoriesKey)
    }

    func setCommentAsUpvoted(commentId: Int) {
        appendId(commentId, toKey: upvotedCommentsKey)
    }

    func isStoryVisited(storyId: Int) -> Bool {
        return arrayForKey(visitedStoriesKey, containsId: storyId)
    }

    func isStoryUpvoted(storyId: Int) -> Bool {
        return arrayForKey(upvotedStoriesKey, containsId: storyId)
    }

    func isCommentUpvoted(commentId: Int) -> Bool {
        return arrayForKey(upvotedCommentsKey, containsId: commentId)
    }

    func setAccessToken(token: String) {
        setObject(token, forKey: accessTokenKey)
        synchronize()
    }

    func deleteAccessToken() {
        removeObjectForKey(accessTokenKey)
        synchronize()
    }

    func accessToken() -> String? {
        return stringForKey(accessTokenKey)
    }

    // MARK: Helper

    private func arrayForKey(key: String, containsId id: Int) -> Bool {
        let elements = arrayForKey(key) as? [Int] ?? []
        return contains(elements, id)
    }

    private func appendId(id: Int, toKey key: String) {
        let elements = arrayForKey(key) as? [Int] ?? []
        if !contains(elements, id) {
            setObject(elements + [id], forKey: key)
            synchronize()
        }
    }
}
