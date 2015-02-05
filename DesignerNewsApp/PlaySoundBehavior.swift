//
//  PlaySoundBehavior.swift
//  DesignerNewsApp
//
//  Created by James Tang on 5/2/15.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit

class PlaySoundBehavior: NSObject {

    @IBAction func playRefresh(sender: AnyObject) {
        SoundEffectPlayer.sharedPlayer().playSoundNamed("refresh", fileExtension: "wav")
    }

    @IBAction func playUpvote(sender: AnyObject) {
        SoundEffectPlayer.sharedPlayer().playSoundNamed("upvote", fileExtension: "wav")
    }

}
