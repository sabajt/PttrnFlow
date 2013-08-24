//
//  MainSynth.h
//  SequencerGame
//
//  Created by John Saba on 5/5/13.
//
//

#import <Foundation/Foundation.h>

@interface MainSynth : NSObject

+ (void)receiveEvents:(NSArray *)events;
+ (void)mute:(BOOL)mute;

@end
