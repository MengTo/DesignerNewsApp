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

    private (set) var hasMore : Bool = false
    private var page : Int = 1
    private var isLoading : Bool = false
    private let section : StorySection

    init(_ section: StorySection = .Default) {
        self.section = section
    }

    func load(page: Int = 1, completion: (stories:[Story]) ->()) {
        if isLoading {
            return
        }

        isLoading = true
        DesignerNewsService.storiesForSection(self.section.rawValue, page: page) { stories in
            self.hasMore = stories.count > 0
            self.isLoading = false
            completion(stories: stories)
        }
    }

    func next(completion: (stories:[Story]) ->()) {
        if isLoading {
            return
        }

        ++page
        load(page: page, completion)
    }
}

