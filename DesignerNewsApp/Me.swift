//
//  Me.swift
//  DesignerNewsApp
//
//  Created by James Tang on 31/1/15.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit

struct Me : Printable {
    let users = [User]()

    var description : String {
        return self.users.description
    }
}

struct User : Printable {

    let id : String = ""
    let href : String?
    let links : Links

    var description : String {
        return "id:\(id) href:\(href) links: \(links)"
    }
}

struct Links : Printable {
    let upvotes = [String]()

    var description : String {
        return self.upvotes.description
    }
}