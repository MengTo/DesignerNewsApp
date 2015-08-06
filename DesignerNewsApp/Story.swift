//
//  Story.swift
//  DesignerNewsApp
//
//  Created by André Schneider on 20.01.15.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

public class Story : Replyable {
    public let id: Int
    public let title: String
    public let url: String
    public let commentHTML: String
    public let userDisplayName: String
    public let userJob: String
    private (set) public var voteCount: Int
    private (set) public var commentCount: Int
    public let createdAt: String
    public let badge: String
    public let userPortraitUrl: String?
    private (set) public var comments: [Comment]

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

    public func insertComment(comment: Comment, atIndex: Int) {
        comments.insert(comment, atIndex: atIndex)
        commentCount++
    }

    public func upvote() {
        voteCount++
    }

    public func downvote() {
        voteCount--
    }

    func hasKeyword(keyword: String) -> Bool {
        if self.title.lowercaseString.rangeOfString(keyword) != nil || self.userDisplayName.lowercaseString.rangeOfString(keyword) != nil {
            return true
        }

        return false
    }
}

extension Story: Equatable {}

public func == (left: Story, right: Story) -> Bool {
    return left.id == right.id &&
    left.title == right.title &&
    left.url == right.url &&
    left.commentHTML == right.commentHTML &&
    left.userDisplayName == right.userDisplayName &&
    left.userJob == right.userJob &&
    left.voteCount == right.voteCount &&
    left.commentCount == right.commentCount &&
    left.createdAt == right.createdAt &&
    left.badge == right.badge &&
    left.userPortraitUrl == right.userPortraitUrl
}
