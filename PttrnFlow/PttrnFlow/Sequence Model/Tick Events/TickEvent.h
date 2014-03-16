//
//  TickEvent.h
//  PttrnFlow
//
//  Created by John Saba on 8/12/13.
//
//

#import "cocos2d.h"

@class PFLPuzzle;

FOUNDATION_EXPORT NSString *const kChannelNone;

@interface NSArray (TickEvents)

- (BOOL)hasSameNumberOfSameEvents:(NSArray *)events;
- (NSArray *)audioEvents;

@end

@interface TickEvent : CCNode

@property (strong, nonatomic) NSNumber *audioID;

+ (NSArray *)puzzleSolutionEvents:(PFLPuzzle *)puzzle;

- (NSString *)eventDescription;

@end
