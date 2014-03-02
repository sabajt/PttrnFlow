//
//  Drum.h
//  PttrnFlow
//
//  Created by John Saba on 2/28/14.
//
//

#import "CCSprite.h"
#import "AudioResponder.h"

@class SampleEvent;

@protocol DrumDelegate <NSObject>

- (void)receiveSampleEvent:(SampleEvent *)event;

@end

@interface Drum : CCSprite <AudioResponder>

@property (weak, nonatomic) id<DrumDelegate> delegate;

- (id)initWithCell:(Coord *)cell audioID:(NSNumber *)audioID data:(NSArray *)data isStatic:(BOOL)isStatic;

@end
