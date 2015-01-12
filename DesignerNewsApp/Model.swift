//
//  Model.swift
//  DesignerNewsApp
//
//  Created by Meng To on 2015-01-08.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import Alamofire

var baseURL             = "https://api-news.layervault.com"
var loginURL            = "/oauth/token"
var storiesURL          = "/api/v1/stories"
var storiesIDURL        = "/api/v1/stories/:id"
var storiesRecentURL    = "/api/v1/stories/recent"
var storiesSearchURL    = "/api/v1/stories/search"
var storiesUpvoteURL    = "/api/v1/stories/:id/upvote"
var storiesReplyURL     = "/api/v1/stories/:id/reply"
var commentsURL         = "/api/v1/comments/:id"
var commentsUpvoteURL   = "/api/v1/comments/:id/upvote"
var commentsReplyURL    = "/api/v1/comments/:id/reply"
var clientID            = "750ab22aac78be1c6d4bbe584f0e3477064f646720f327c5464bc127100a1a6d"
var clientSecret        = "53e3822c49287190768e009a8f8e55d09041c5bf26d0ef982693f215c72d87da"

func postComment(id: Int) {
    var request = baseURL + commentsURL
    
}

func postLogin(email: String, password: String, callback: (AnyObject?) -> ()) {
    var request = baseURL + loginURL
    var parameters = [
        "grant_type": "password",
        "username": email,
        "password": password,
        "client_id": clientID,
        "client_secret": clientSecret
    ]
    
    Alamofire.request(.POST, request, parameters: parameters)
        .responseJSON { (_, _, json, _) in
            callback(json as? NSDictionary)
    }
}

func getStories(page: String, callback: (JSON) -> ()) {
    var request = baseURL + storiesURL
    var parameters = [
        "page": page,
        "client_id": clientID
    ]
    
    Alamofire.request(.GET, request, parameters: parameters)
        .response { (_, _, data, _) in
            callback(JSON(data: data as NSData))
    }
}