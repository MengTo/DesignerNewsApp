//
//  Story.swift
//  DesignerNewsApp
//
//  Created by André Schneider on 20.01.15.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

struct Story {
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
    let comments: [Comment]
}
