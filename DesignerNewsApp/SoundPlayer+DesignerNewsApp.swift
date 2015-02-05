//
//  SoundPlayer+DesignerNewsApp.swift
//  DesignerNewsApp
//
//  Created by James Tang on 5/2/15.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit
import Spring

extension SoundPlayer {

    @IBAction func playRefresh(sender: AnyObject) {
        self.playSound("refresh.wav")
    }

    @IBAction func playUpvote(sender: AnyObject) {
        self.playSound("upvote.wav")
    }

}