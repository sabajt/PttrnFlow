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
                return kImageC_on;
            }
            return kImageC;
        case 49:
            if (on) {
                return kImageC_sharp_on;
            }
            return kImageC_sharp;
        case 50:
            if (on) {
                return kImageD_on;
            }
            return kImageD;
        case 51:
            if (on) {
                return kImageE_flat_on;
            }
            return kImageE_flat;
        case 52:
            if (on) {
                return kImageE_on;
            }
            return kImageE;
        case 53:
            if (on) {
                return kImageF_on;
            }
            return kImageF;
        case 54:
            if (on) {
                return kImageF_sharp_on;
            }
            return kImageF_sharp;
        case 55:
            if (on) {
                return kImageG_on;
            }
            return kImageG;
        case 56:
            if (on) {
                return kImageA_flat_on;
            }
            return kImageA_flat;
        case 57:
            if (on) {
                return kImageA_on;
            }
            return kImageA;
        case 58:
            if (on) {
                return kImageB_flat_on;
            }
            return kImageB_flat;
        case 59:
            if (on) {
                return kImageB_on;
            }
            return kImageB;;
            
        default:
            NSLog(@"tone image not found for value: %@, returning empty string", midi);
            return @"";
    }
}


@end
