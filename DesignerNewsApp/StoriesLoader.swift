//
//  StoriesLoader.swift
//  DesignerNewsApp
//
//  Created by James Tang on 28/1/15.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import Foundation

class StoriesLoader {

    enum StorySection : Printable {
        case Default
        case Recent
        case Search(_ : String)

        var description : String {
            switch (self) {

            case .Default: return ""
            case .Recent: return "recent"
            case .Search(_): return "search"
            }
        }
    }

    private (set) var hasMore : Bool = false
    private var page : Int = 1
    private var isLoading : Bool = false
    private let section : StorySection
    private let keyword : String?

    init(_ section: StorySection = .Default) {
        self.section = section
        switch (section) {
        case let .Search(keyword):
            self.keyword = keyword
        default: break
        }
    }

    func load(page: Int = 1, completion: (stories:[Story]) ->()) {
        if isLoading {
            return
        }

        isLoading = true
        DesignerNewsService.storiesForSection(self.section.description, page: page, keyword: self.keyword) { stories in
            switch (self.section) {
            case .Search(_):
                self.hasMore = false
            default:
                self.hasMore = stories.count > 0
            }
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

