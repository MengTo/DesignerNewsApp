//
//  JSONParser.swift
//  DesignerNewsApp
//
//  Created by André Schneider on 20.01.15.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import Foundation

struct JSONParser {
    static func parseStories(data: NSData?) -> [Story] {
        return self.dictionariesFromData(data)?.map(self.parseStory) ?? []
    }

    private static func parseStory(story: NSDictionary) -> Story {
        let id = story["id"] as? String ?? ""
        let title = story["title"] as? String ?? ""

        let unparsedComments = story["comments"] as? [NSDictionary] ?? []
        let parsedComments = unparsedComments.map(flattenedComments)
        let flattenedParsedComments = parsedComments.reduce([], +)

        return Story(id: id, title: title, comments: flattenedParsedComments)
    }

    private static func parseComment(comment: NSDictionary) -> Comment {
        let id = comment["id"] as? String ?? ""
        let body = comment["body"] as? String ?? ""
        let depth = comment["depth"] as? Int ?? 0
        return Comment(id: id, body: body, depth: depth)
    }

    private static func flattenedComments(comment: NSDictionary) -> [Comment] {
        let comments = comment["comments"] as? [NSDictionary] ?? []
        return comments.reduce([parseComment(comment)]) { acc, x in
            acc + self.flattenedComments(x)
        }
    }

    // MARK: Helper

    private static func dictionariesFromData(data: NSData?) -> [NSDictionary]? {
        if let data = data {
            if let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: nil) as? NSDictionary {
                if let items = dictionary["stories"] as? [NSDictionary] {
                    return items
                }
            }
        }
        return nil
    }
}
