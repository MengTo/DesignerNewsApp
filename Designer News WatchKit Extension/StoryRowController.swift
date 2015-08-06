//
//  StoryRowController.swift
//  DesignerNewsApp
//
//  Created by André Schneider on 08.07.15.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import WatchKit

class StoryRowController: NSObject {
    @IBOutlet weak var titleLabel: WKInterfaceLabel!
    @IBOutlet weak var authorLabel: WKInterfaceLabel!
    @IBOutlet weak var badgeImage: WKInterfaceImage!
    @IBOutlet weak var upvoteCountLabel: WKInterfaceLabel!
    @IBOutlet weak var commentCountLabel: WKInterfaceLabel!
}
