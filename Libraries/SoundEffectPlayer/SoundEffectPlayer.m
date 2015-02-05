//
//  SoundEffectPlayer.m
//  HeyZap
//
//  Created by Maximilian Tagher on 2/6/13.
//  Copyright (c) 2013 Smart Balloon, Inc. All rights reserved.
//

#import "SoundEffectPlayer.h"
#import <AudioToolbox/AudioToolbox.h>

@interface SoundEffectPlayer()

@property (nonatomic, strong) NSMutableDictionary *systemSoundIds;
@property (nonatomic, getter = isPlayingSound) BOOL playingSound;

@end

@implementation SoundEffectPlayer

+ (instancetype)sharedPlayer
{
    static SoundEffectPlayer *sharedPlayer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPlayer = [[SoundEffectPlayer alloc] init];
        sharedPlayer.systemSoundIds = [@{} mutableCopy];
    });
    return sharedPlayer;
}

- (void)playSoundNamed:(NSString *)fileName fileExtension:(NSString *)extension
{
    NSString *key = [fileName stringByAppendingString:extension];
    SystemSoundID audioEffect;
    
    NSNumber *systemSoundID = [self.systemSoundIds objectForKey:key];
    if (!systemSoundID) {
        NSString *path  = [[NSBundle mainBundle] pathForResource:fileName ofType:extension];
        {
            NSURL *pathURL = [NSURL fileURLWithPath: path];
            AudioServicesCreateSystemSoundID((__bridge CFURLRef) pathURL, &audioEffect);
            
            AudioServicesAddSystemSoundCompletion(audioEffect, NULL, NULL, completionCallback, (__bridge_retained void *)self);
            
            [self.systemSoundIds setObject:@(audioEffect) forKey:key];
        }
    } else {
        audioEffect = [systemSoundID unsignedIntValue];
    }
    
    AudioServicesPlaySystemSound(audioEffect);
}

static void completionCallback (SystemSoundID  mySSID, void *myself)
{
    SoundEffectPlayer *thisInstance = (__bridge SoundEffectPlayer *)myself;
    thisInstance.playingSound = NO;
}



@end
