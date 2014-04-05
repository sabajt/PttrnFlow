//
//  AVAudioPlayer+Utils.h
//  PttrnFlow
//
//  Created by John Saba on 4/5/14.
//
//

#import <AVFoundation/AVFoundation.h>

@interface AVAudioPlayer (FTPUtils)

+ (AVAudioPlayer*)audioPlayerForURL:(NSURL*)url;

@end