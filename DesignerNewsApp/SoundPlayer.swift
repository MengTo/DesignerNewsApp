//
//  SoundPlayer.swift
//  DesignerNewsApp
//
//  Created by James Tang on 5/2/15.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit
import AudioToolbox

public class SoundPlayer: NSObject {

    @IBInspectable var filename : String?
    @IBInspectable var enabled : Bool = true

    private struct Internal {
        static var cache = [NSURL:SystemSoundID]()
    }

    public func playSound(soundFile:String) {

        if !enabled {
            return
        }

        if let url = NSBundle.mainBundle().URLForResource(soundFile, withExtension: nil) {

            var soundID : SystemSoundID = Internal.cache[url] ?? 0

            if soundID == 0 {
                AudioServicesCreateSystemSoundID(url, &soundID)
                Internal.cache[url] = soundID
            }

            AudioServicesPlaySystemSound(soundID)

        } else {
            println("Could not find sound file name `\(soundFile)`")
        }
    }

    @IBAction public func play(sender: AnyObject?) {
        if let filename = filename {
            self.playSound(filename)
        }
    }
}
