//
//  PFLEvent.h
//  PttrnFlow
//
//  Created by John Saba on 8/12/13.
//
//

#import "cocos2d.h"

typedef NS_ENUM(NSInteger, PFLEventType)
{
    PFLEventTypeAudioStop = 0,
    PFLEventTypeDirection,
    PFLEventTypeExit,
    PFLEventTypeMultiSample,
    PFLEventTypeSample,
    PFLEventTypeSynth,
};

@class PFLPuzzle, PFLMultiSample;

FOUNDATION_EXPORT NSString *const kChannelNone;

@interface NSArray (PFLEvent)

- (BOOL)hasSameNumberOfSameEvents:(NSArray *)events;
- (NSArray *)audioEvents;

@end

@interface PFLEvent : NSObject

@property (assign) PFLEventType eventType;

@property (strong, nonatomic) NSNumber *audioID;
@property (copy, nonatomic) NSString *direction;
@property (copy, nonatomic) NSString *file;
@property (copy, nonatomic) NSString *midiValue;
@property (strong, nonatomic) NSArray *sampleEvents;
@property (copy, nonatomic) NSString *synthType;
@property (strong, nonatomic) NSNumber *time;

+ (NSArray *)puzzleSolutionEvents:(PFLPuzzle *)puzzle;

// Individual event constructors
+ (id)synthEventWithAudioID:(NSNumber *)audioID midiValue:(NSString *)midiValue synthType:(NSString *)synthType;
+ (id)sampleEventWithAudioID:(NSNumber *)audioID file:(NSString *)file time:(NSNumber *)time;
+ (id)directionEventWithDirection:(NSString *)direction;
+ (id)exitEvent;
+ (id)audioStopEventWithAudioID:(NSNumber *)audioID;
+ (id)multiSampleEventWithAudioID:(NSNumber *)audioID sampleEvents:(NSArray *)sampleEvents;
+ (id)multiSampleEventWithAudioID:(NSNumber *)audioID multiSample:(PFLMultiSample *)multiSample;

@end
