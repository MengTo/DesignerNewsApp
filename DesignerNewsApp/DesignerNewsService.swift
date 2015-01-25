//
//  DesignerNewsService.swift
//  DesignerNewsApp
//
//  Created by André Schneider on 20.01.15.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import Alamofire

struct DesignerNewsService {

    private static let baseURL = "https://api-news.layervault.com"
    private static let clientID = "750ab22aac78be1c6d4bbe584f0e3477064f646720f327c5464bc127100a1a6d"
    private static let clientSecret = "53e3822c49287190768e009a8f8e55d09041c5bf26d0ef982693f215c72d87da"

    enum ResourcePath: Printable {
        case Login
        case Stories
        case StoryUpvote(storyId: Int)

        var description: String {
            switch self {
            case .Login: return "/oauth/token"
            case .Stories: return "/api/v1/stories"
            case .StoryUpvote(let id): return "/api/v1/stories/\(id)/upvote"
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
        let urlString = baseURL + ResourcePath.StoryUpvote(storyId: storyId).description
        let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        mutableURLRequest.HTTPMethod = "POST"
        mutableURLRequest.setValue("Bearer \(getToken())", forHTTPHeaderField: "Authorization")

        Alamofire.request(mutableURLRequest).responseJSON { (_, _, json, _) in
            // FIXME: Upvote is not working and call response closure after json structure is known.
            println(json)
        }

    }
}
