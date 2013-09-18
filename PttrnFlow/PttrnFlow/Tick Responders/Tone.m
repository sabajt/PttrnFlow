//
//  Tone.m
//  SequencerGame
//
//  Created by John Saba on 5/4/13.
//
//

#import "Tone.h"
#import "CCTMXTiledMap+Utils.h"
#import "SGTiledUtils.h"
#import "TextureUtils.h"
#import "SpriteUtils.h"
#import "TickDispatcher.h"
#import "TickEvent.h"
#import "AudioTouchDispatcher.h"

@interface Tone ()

@property (assign) BOOL selected;

@end 


@implementation Tone

- (id)initWithBatchNode:(CCSpriteBatchNode *)batchNode tone:(NSMutableDictionary *)tone tiledMap:(CCTMXTiledMap *)tiledMap
{
    GridCoord cell = [tiledMap gridCoordForObject:tone];
    self = [super initWithBatchNode:batchNode cell:cell];
    if (self) {
        _midiValue = [CCTMXTiledMap objectPropertyNamed:kTLDPropertyMidiValue object:tone];
        _selected = NO;
        [self setSpriteForFrameName:[self frameNameForMidiValue:self.midiValue on:NO] cell:cell];
    }
    return self;
}

- (void)deselectTone
{
    [self setSpriteForFrameName:[self frameNameForMidiValue:self.midiValue on:NO] cell:self.cell];
}

#pragma mark - CellNode

- (void)cancelTouchForPan
{
    [super cancelTouchForPan];
    [self afterTick:kBPM];
}

#pragma mark - CCTargetedTouchDelegate

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super ccTouchEnded:touch withEvent:event];
    [self afterTick:kBPM];
}

#pragma mark - Tick Responder

- (NSArray *)tick:(NSInteger)bpm
{
    // select and highlight
    self.selected = YES;
    [self setSpriteForFrameName:[self frameNameForMidiValue:self.midiValue on:YES] cell:self.cell];

    // return fragments
    return @[self.midiValue];
}

- (void)afterTick:(NSInteger)bpm
{
    self.selected = NO;
    [self deselectTone];
}

- (GridCoord)responderCell
{
    return self.cell;
}

#pragma mark - Images

// TODO: we're using convention based names so change this to just put together the string
- (NSString *)frameNameForMidiValue:(NSString *)midi on:(BOOL)on
{
    switch ([midi intValue]) {
        case 48:
            if (on) {
                return kImageNote1on;
            }
            return kImageNote1;
        case 49:
            if (on) {
                return kImageNote2on;
            }
            return kImageNote2;
        case 50:
            if (on) {
                return kImageNote3on;
            }
            return kImageNote3;
        case 51:
            if (on) {
                return kImageNote4on;
            }
            return kImageNote4;
        case 52:
            if (on) {
                return kImageNote5on;
            }
            return kImageNote5;
        case 53:
            if (on) {
                return kImageNote6on;
            }
            return kImageNote6;
        case 54:
            if (on) {
                return kImageNote7on;
            }
            return kImageNote7;
        case 55:
            if (on) {
                return kImageNote8on;
            }
            return kImageNote8;
        case 56:
            if (on) {
                return kImageNote9on;
            }
            return kImageNote9;
        case 57:
            if (on) {
                return kImageNote10on;
            }
            return kImageNote10;
        case 58:
            if (on) {
                return kImageNote11on;
            }
            return kImageNote11;
        case 59:
            if (on) {
                return kImageNote12on;
            }
            return kImageNote12;
            
        default:
            NSLog(@"tone image not found for value: %@, returning empty string", midi);
            return @"";
    }
}


@end
