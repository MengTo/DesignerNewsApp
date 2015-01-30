//
//  DesignerNewsService.swift
//  DesignerNewsApp
//
//  Created by André Schneider on 20.01.15.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import Alamofire

struct DesignerNewsService {

    // Designer News API Doc: http://developers.news.layervault.com

    private static let baseURL = "https://api-news.layervault.com"
    private static let clientID = "750ab22aac78be1c6d4bbe584f0e3477064f646720f327c5464bc127100a1a6d"
    private static let clientSecret = "53e3822c49287190768e009a8f8e55d09041c5bf26d0ef982693f215c72d87da"

    enum ResourcePath: Printable {
        case Login
        case Stories
        case StoryUpvote(storyId: Int)
        case StoryReply(storyId: Int)
        case CommentUpvote(commentId: Int)
        case CommentReply(commentId: Int)

        var description: String {
            switch self {
            case .Login: return "/oauth/token"
            case .Stories: return "/api/v1/stories"
            case .StoryUpvote(let id): return "/api/v1/stories/\(id)/upvote"
            case .StoryReply(let id): return "/api/v1/stories/\(id)/reply"
            case .CommentUpvote(let id): return "/api/v1/comments/\(id)/upvote"
            case .CommentReply(let id): return "/api/v1/comments/\(id)/reply"
            }
        }
    }

    static func storiesForSection(section: String, page: Int, response: ([Story]) -> ()) {
        let urlString = baseURL + ResourcePath.Stories.description + "/" + section
        let parameters = [
            "page": toString(page),
            "client_id": clientID
        ]
        Alamofire.request(.GET, urlString, parameters: parameters).response { (_, _, data, _) in
            let stories = JSONParser.parseStories(data as? NSData)
            response(stories)
        }
    }

    static func loginWithEmail(email: String, password: String, response: (token: String?) -> ()) {
        let urlString = baseURL + ResourcePath.Login.description
        let parameters = [
            "grant_type": "password",
            "username": email,
            "password": password,
            "client_id": clientID,
            "client_secret": clientSecret
        ]

        Alamofire.request(.POST, urlString, parameters: parameters)
            .responseJSON { (_, _, json, _) in
                let responseDictionary = json as? NSDictionary
                let token = responseDictionary?["access_token"] as? String
                response(token: token)
        }
    }

    static func upvoteStoryWithId(storyId: Int, token: String, response: (successful: Bool) -> ()) {
        let resourcePath = ResourcePath.StoryUpvote(storyId: storyId)
        upvoteWithResourcePath(resourcePath, token: token, response: response)
    }

    static func upvoteCommentWithId(commentId: Int, token: String, response: (successful: Bool) -> ()) {
        let resourcePath = ResourcePath.CommentUpvote(commentId: commentId)
        upvoteWithResourcePath(resourcePath, token: token, response: response)
    }

    private static func upvoteWithResourcePath(path: ResourcePath, token: String, response: (successful: Bool) -> ()) {
        let urlString = baseURL + path.description
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        request.HTTPMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        Alamofire.request(request).responseJSON { (_, urlResponse, _, _) in
            let successful = urlResponse?.statusCode == 200
            response(successful: successful)
        }
    }
}
