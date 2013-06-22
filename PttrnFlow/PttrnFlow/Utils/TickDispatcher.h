//
//  TickDispatcher.h
//  SequencerGame
//
//  Created by John Saba on 4/30/13.
//
//

#import <Foundation/Foundation.h>
#import "GridUtils.h"
#import "MainSynth.h"
#import "TickerControl.h"
#import "TickResponder.h"


FOUNDATION_EXPORT NSInteger const kBPM;
FOUNDATION_EXPORT NSString *const kNotificationAdvancedSequence;
FOUNDATION_EXPORT NSString *const kKeySequenceIndex;

typedef enum
{
    kTickEventNote = 0,
    kTickEventArrow,
    kTickEventWarp
}kTickEvent;

@interface TickDispatcher : CCNode <TickerControlDelegate>

@property (assign) int sequenceLength;
@property (strong, nonatomic) NSMutableDictionary *eventSequence;

@property (weak, nonatomic) id<SoundEventReceiver> synth;

- (id)initWithSequence:(NSMutableDictionary *)sequence tiledMap:(CCTMXTiledMap *)tiledMap synth:(id<SoundEventReceiver>)synth;
- (void)registerTickResponder:(id<TickResponder>)responder;

- (void)start;
- (void)stop;
- (void)play:(int)index;
- (void)scheduleSequence;

+ (BOOL)isArrowEvent:(NSString *)event;


@end
