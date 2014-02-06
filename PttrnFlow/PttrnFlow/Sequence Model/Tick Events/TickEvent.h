//
//  TickEvent.h
//  PttrnFlow
//
//  Created by John Saba on 8/12/13.
//
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const kChannelNone;

@interface NSArray (TickEvents)

- (BOOL)hasSameNumberOfSameEvents:(NSArray *)events;
- (NSArray *)audioEvents;

@end

@interface TickEvent : NSObject

@property (assign) BOOL isAudioEvent;

- (id)initAsAudioEvent:(BOOL)isAudioEvent;
- (BOOL)isEqualToEvent:(TickEvent *)event;

@end
