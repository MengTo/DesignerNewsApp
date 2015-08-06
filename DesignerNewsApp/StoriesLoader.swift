//
//  StoriesLoader.swift
//  DesignerNewsApp
//
//  Created by James Tang on 28/1/15.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import Foundation
import DesignerNewsKit

class StoriesLoader {

    typealias StoriesLoaderCompletion = (stories:[Story]) ->()

    private (set) var hasMore : Bool = false
    private var page : Int = 1
    private var isLoading : Bool = false
    private let section : DesignerNewsService.StorySection

    init(_ section: DesignerNewsService.StorySection = .Default) {
        self.section = section
    }

    func load(page: Int = 1, completion: StoriesLoaderCompletion) {
        if isLoading {
            return
        }

        isLoading = true
        DesignerNewsService.storiesForSection(section, page: page) { [weak self] stories in
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

