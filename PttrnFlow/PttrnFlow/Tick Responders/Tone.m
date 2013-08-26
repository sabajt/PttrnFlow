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
#import "CCNode+Touch.h"
#import "TickEvent.h"
#import "AudioTouchDispatcher.h"

@interface Tone ()

@property (assign) BOOL selected;

@end


@implementation Tone

- (id)initWithTone:(NSMutableDictionary *)tone tiledMap:(CCTMXTiledMap *)tiledMap
{
    self = [super init];
    if (self) {
        self.cell = [tiledMap gridCoordForObject:tone];
        self.midiValue = [CCTMXTiledMap objectPropertyNamed:kTLDPropertyMidiValue object:tone];
        NSString *imageName = [self imageNameForMidiValue:self.midiValue on:NO];
        
        self.sprite = [self createAndCenterSpriteNamed:imageName];
        [self addChild:self.sprite];
        
        self.position = [GridUtils relativePositionForGridCoord:self.cell unitSize:kSizeGridUnit];
        _selected = NO;
    }
    return self;
}

- (void)deselectTone
{
    [SpriteUtils switchImageForSprite:self.sprite textureKey:[self imageNameForMidiValue:self.midiValue on:NO]];
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
    [SpriteUtils switchImageForSprite:self.sprite textureKey:[self imageNameForMidiValue:self.midiValue on:YES]];

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

- (NSString *)imageNameForMidiValue:(NSString *)midi on:(BOOL)on
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
