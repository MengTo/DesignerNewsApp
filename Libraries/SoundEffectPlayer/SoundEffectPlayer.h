//
//  SoundEffectPlayer.h
//  HeyZap
//
//  Created by Maximilian Tagher on 2/6/13.
//  Copyright (c) 2013 Smart Balloon, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/** `SoundEffectPlayer` provides an interface for easily playing sound effects. It caches `SystemSoundID`s for performance. If it is currently playing a sound, it will ignore messages send to it to play another sound (sounds weird otherwise). */
@interface SoundEffectPlayer : NSObject

/** Whether or not the `SoundEffectPlayer` is currently playing a sound effect. If so, it will ignore messages sent to it to play another sound. */
@property (nonatomic, readonly, getter = isPlayingSound) BOOL playingSound;

/** The shared instance. The singleton implementation allows for the caching and one-sound-at-a-time behavior. */
+ (instancetype)sharedPlayer;

/** Plays the sound with the designated `fileName` and `extension`. The sound files must be under 30 seconds and are subject to other (minor) restrictions listed in Apple's docs.
 @param fileName The file name, e.g. `sound-delete`
 @param extension The file extension, e.g. `aif`. Valid file extensions are listed in Apple's documentation.
 */

- (void)playSoundNamed:(NSString *)fileName fileExtension:(NSString *)extension;

// Check whether (static?) extern NSString * const strings can be ==ed, and if they can be switch()ed using their pointer value?

@end
