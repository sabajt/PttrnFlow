//
//  TickEvent.h
//  PttrnFlow
//
//  Created by John Saba on 8/12/13.
//
//

#import "cocos2d.h"

FOUNDATION_EXPORT NSString *const kChannelNone;

@interface NSArray (TickEvents)

- (BOOL)hasSameNumberOfSameEvents:(NSArray *)events;
- (NSArray *)audioEvents;

@end

@interface TickEvent : CCNode

@property (strong, nonatomic) NSNumber *audioID;

+ (NSArray *)puzzleSolutionEvents:(NSInteger)puzzle;

- (NSString *)eventDescription;

@end
