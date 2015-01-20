//
//  Token.swift
//  DesignerNewsApp
//
//  Created by James Tang on 20/1/15.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit

let kTokenKey : String = "token"

func saveToken(value: String) {
    NSUserDefaults.standardUserDefaults().setObject(value, forKey: kTokenKey)
    NSUserDefaults.standardUserDefaults().synchronize()
}

func deleteToken() {
    NSUserDefaults.standardUserDefaults().removeObjectForKey(kTokenKey)
    NSUserDefaults.standardUserDefaults().synchronize()
}

func getToken() -> String {
    return NSUserDefaults.standardUserDefaults().stringForKey(kTokenKey)  ?? ""
}
