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
    private static let storiesURL = "/api/v1/stories"
    private static let clientID = "750ab22aac78be1c6d4bbe584f0e3477064f646720f327c5464bc127100a1a6d"

    static func getStories(section: String, page: String, callback: (JSON) -> ()) {
        let request = baseURL + storiesURL + "/" + section
        let parameters = [
            "page": page,
            "client_id": clientID
        ]
        Alamofire.request(.GET, request, parameters: parameters)
            .response { (_, _, data, _) in
                callback(JSON(data: data as NSData))
        }
    }
}
