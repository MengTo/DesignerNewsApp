//
//  Story.swift
//  DesignerNewsApp
//
//  Created by André Schneider on 20.01.15.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

class Story : Replyable {
    let id: Int
    let title: String
    let url: String
    let commentHTML: String
    let userDisplayName: String
    let userJob: String
    private (set) var voteCount: Int
    private (set) var commentCount: Int
    let createdAt: String
    let badge: String
    let userPortraitUrl: String?
    private (set) var comments: [Comment]

    init (id: Int,
        title: String,
        url: String,
        commentHTML: String,
        userDisplayName: String,
        userJob: String,
        voteCount: Int,
        commentCount: Int,
        createdAt: String,
        badge: String,
        userPortraitUrl: String?,
        comments: [Comment]) {
            self.id  = id
            self.title  = title
            self.url  = url
            self.commentHTML  = commentHTML
            self.userDisplayName  = userDisplayName
            self.userJob  = userJob
            self.voteCount  = voteCount
            self.commentCount  = commentCount
            self.createdAt  = createdAt
            self.badge  = badge 
            self.userPortraitUrl  = userPortraitUrl 
            self.comments = comments
    }

    func insertComment(comment: Comment, atIndex: Int) {
        comments.insert(comment, atIndex: atIndex)
        commentCount++
    }

    func upvote() {
        voteCount++
    }

    func downvote() {
        voteCount--
    }

    func hasKeyword(keyword: String) -> Bool {
        if self.title.lowercaseString.rangeOfString(keyword) != nil || self.userDisplayName.lowercaseString.rangeOfString(keyword) != nil {
            return true
        }

        return false
    }
}
