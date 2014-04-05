//
//  AVAudioPlayer+Utils.m
//  PttrnFlow
//
//  Created by John Saba on 4/5/14.
//
//

#import "AVAudioPlayer+Utils.h"

@implementation AVAudioPlayer (Utils)

+ (AVAudioPlayer*)audioPlayerForURL:(NSURL*)url
{
    NSError *error = nil;
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    if (error)
    {
        NSLog(@"AVAudioPlayer creation error: %@", error.description);
        return nil;
    }
    
    return audioPlayer;
}

@end
