//
//  LocalStore.swift
//  DesignerNewsApp
//
//  Created by André Schneider on 30.01.15.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit

struct LocalStore {
    private static let visitedStoriesKey = "visitedStoriesKey"
    private static let upvotedStoriesKey = "upvotedStoriesKey"
    private static let repliedStoriesKey = "repliedStoriesKey"
    private static let upvotedCommentsKey = "upvotedCommentsKey"
    private static let accessTokenKey = "accessTokenKey"
    private static let userDefaults = NSUserDefaults.standardUserDefaults()

    static func setIntroAsVisited() {
        userDefaults.setObject(true, forKey: "introKey")
    }
    
    static func isIntroVisited() -> Bool {
        return userDefaults.boolForKey("introKey")
    }
    
    static func setStoryAsReplied(storyId: Int) {
        appendId(storyId, toKey: repliedStoriesKey)
    }

    static func setStoryAsVisited(storyId: Int) {
        appendId(storyId, toKey: visitedStoriesKey)
    }

    static func setStoryAsUpvoted(storyId: Int) {
        appendId(storyId, toKey: upvotedStoriesKey)
    }

    static func removeStoryFromUpvoted(storyId: Int) {
        removeId(storyId, forKey: upvotedStoriesKey)
    }

    static func setCommentAsUpvoted(commentId: Int) {
        appendId(commentId, toKey: upvotedCommentsKey)
    }

    static func removeCommentFromUpvoted(commentId: Int) {
        removeId(commentId, forKey: upvotedCommentsKey)
    }

    static func isStoryReplied(storyId: Int) -> Bool {
        return arrayForKey(repliedStoriesKey, containsId: storyId)
    }

    static func isStoryVisited(storyId: Int) -> Bool {
        return arrayForKey(visitedStoriesKey, containsId: storyId)
    }

    static func isStoryUpvoted(storyId: Int) -> Bool {
        return arrayForKey(upvotedStoriesKey, containsId: storyId)
    }

    static func isCommentUpvoted(commentId: Int) -> Bool {
        return arrayForKey(upvotedCommentsKey, containsId: commentId)
    }

    static func setAccessToken(token: String) {
        userDefaults.setObject(token, forKey: accessTokenKey)
        userDefaults.synchronize()
    }

    private static func deleteAccessToken() {
        userDefaults.removeObjectForKey(accessTokenKey)
        userDefaults.synchronize()
    }

    static func removeUpvotes() {
        userDefaults.removeObjectForKey(upvotedStoriesKey)
        userDefaults.removeObjectForKey(upvotedCommentsKey)
        userDefaults.synchronize()
    }

    static func accessToken() -> String? {
        return userDefaults.stringForKey(accessTokenKey)
    }

    static func logout() {
        self.deleteAccessToken()
    }

    // MARK: Helper

    static private func arrayForKey(key: String, containsId id: Int) -> Bool {
        let elements = userDefaults.arrayForKey(key) as? [Int] ?? []
        return contains(elements, id)
    }

    static private func appendId(id: Int, toKey key: String) {
        let elements = userDefaults.arrayForKey(key) as? [Int] ?? []
        if !contains(elements, id) {
            userDefaults.setObject(elements + [id], forKey: key)
            userDefaults.synchronize()
        }
    }

    static private func removeId(id: Int, forKey key: String) {
        var elements = userDefaults.arrayForKey(key) as? [Int] ?? []
        if let index = find(elements, id) {
            elements.removeAtIndex(index)
            userDefaults.setObject(elements, forKey: key)
            userDefaults.synchronize()
        }
    }
}
