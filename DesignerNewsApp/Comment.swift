//
//  Comment.swift
//  DesignerNewsApp
//
//  Created by André Schneider on 20.01.15.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

class Comment : Replyable, Equatable {

    let id: Int
    let bodyHTML: String
    let depth: Int
    let userDisplayName: String
    let userJob: String
    private (set) var voteCount: Int
    let createdAt: String
    let userPortraitUrl: String?

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

    func upvote() {
        voteCount++
    }

    func downvote() {
        voteCount--
    }

    func hasKeyword(keyword: String) -> Bool {
        if self.bodyHTML.lowercaseString.rangeOfString(keyword) != nil || self.userDisplayName.lowercaseString.rangeOfString(keyword) != nil {
            return true
        }

        return false
    }
}

func ==(lhs: Comment, rhs: Comment) -> Bool {
    return lhs.id == rhs.id
}