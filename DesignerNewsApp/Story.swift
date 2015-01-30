//
//  Story.swift
//  DesignerNewsApp
//
//  Created by André Schneider on 20.01.15.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

struct Story : Replyable {
    let id: Int
    let title: String
    let url: String
    let commentHTML: String
    let userDisplayName: String
    let userJob: String
    let voteCount: Int
    let commentCount: Int
    let createdAt: String
    let badge: String
    let userPortraitUrl: String
    var comments: [Comment]

    mutating func addComment(comment: Comment) {
        self.comments.append(comment)
    }

    mutating func insertComment(comment: Comment, atIndex: Int) {
        self.comments.insert(comment, atIndex: atIndex)
    }
}
