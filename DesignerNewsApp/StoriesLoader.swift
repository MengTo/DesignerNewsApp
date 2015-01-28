//
//  StoriesLoader.swift
//  DesignerNewsApp
//
//  Created by James Tang on 28/1/15.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import Foundation

class StoriesLoader {

    enum StorySection : String {
        case Default = ""
        case Recent = "recent"
    }

    private (set) var page : Int = 1
    private (set) var stories = [Story]()
    private (set) var hasMore : Bool = false
    private (set) var isLoading : Bool = false
    private let section : StorySection

    init(_ section: StorySection = .Default) {
        self.section = section
    }

    func load(completion: (success:Bool, newStories:[Story])->()) {

        if self.isLoading {
            return
        }

        self.isLoading = true
        DesignerNewsService.storiesForSection(self.section.rawValue, page: self.page) { stories in
            self.hasMore = stories.count > 0
            self.isLoading = false
            completion(success: true, newStories: stories)
        }
    }

    func next(completion: (success:Bool, newStories:[Story])->()) {

        if self.isLoading {
            return
        }

        self.page++
        self.load(completion)
    }
}

