//
//  Comment.swift
//  DesignerNewsApp
//
//  Created by André Schneider on 20.01.15.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

public class Comment : Replyable, Equatable {

    public let id: Int
    public let bodyHTML: String
    public let depth: Int
    public let userDisplayName: String
    public let userJob: String
    private (set) public var voteCount: Int
    public let createdAt: String
    public let userPortraitUrl: String?

    init(id: Int,
        bodyHTML: String,
        depth: Int,
        userDisplayName: String,
        userJob: String,
        voteCount: Int,
        createdAt: String,
        userPortraitUrl: String?) {
            self.id = id
            self.bodyHTML = bodyHTML
            self.depth = depth
            self.userDisplayName = userDisplayName
            self.userJob = userJob
            self.voteCount = voteCount
            self.createdAt = createdAt
            self.userPortraitUrl = userPortraitUrl
    }

    public func upvote() {
        voteCount++
    }

    public func downvote() {
        voteCount--
    }

    public func hasKeyword(keyword: String) -> Bool {
        if self.bodyHTML.lowercaseString.rangeOfString(keyword) != nil || self.userDisplayName.lowercaseString.rangeOfString(keyword) != nil {
            return true
        }

        return false
    }
}

public func ==(lhs: Comment, rhs: Comment) -> Bool {
    return lhs.id == rhs.id
}