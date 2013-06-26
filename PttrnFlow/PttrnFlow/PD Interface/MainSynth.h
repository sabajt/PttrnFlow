//
//  MainSynth.h
//  SequencerGame
//
//  Created by John Saba on 5/5/13.
//
//

#import <Foundation/Foundation.h>

@class SequenceLayer;

@protocol SoundEventReceiver <NSObject>

- (void)receiveEvents:(NSArray *)events;

@end


@interface MainSynth : NSObject <SoundEventReceiver>

+ (NSMutableArray *)filterSoundEvents:(NSMutableArray *)rawEvents;

@end
