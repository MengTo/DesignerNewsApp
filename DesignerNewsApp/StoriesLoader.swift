//
//  StoriesLoader.swift
//  DesignerNewsApp
//
//  Created by James Tang on 28/1/15.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import Foundation

class StoriesLoader {

    typealias StoriesLoaderCompletion = (stories:[Story]) ->()

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
        default:
            self.keyword = nil
        }
    }

    func load(page: Int = 1, completion: StoriesLoaderCompletion) {
        if isLoading {
            return
        }

        isLoading = true
        DesignerNewsService.storiesForSection(self.section.description, page: page, keyword: self.keyword) { [weak self] stories in

            if let strongSelf = self {
                switch (strongSelf.section) {
                case .Search(_):
                    strongSelf.hasMore = false
                default:
                    strongSelf.hasMore = stories.count > 0
                }
                strongSelf.isLoading = false
                completion(stories: stories)
            }
        }
    }

    func next(completion: (stories:[Story]) ->()) {
        if isLoading {
            return
        }

        ++page
        load(page: page, completion: completion)
    }
}

