//
//  Arrow.m
//  SequencerGame
//
//  Created by John Saba on 5/4/13.
//
//

#import "Arrow.h"
#import "CCTMXTiledMap+Utils.h"
#import "SGTiledUtils.h"
#import "TextureUtils.h"
#import "SpriteUtils.h"
#import "TickDispatcher.h"
#import "DragButton.h"


@implementation Arrow

- (id)initWithArrow:(NSMutableDictionary *)arrow tiledMap:(CCTMXTiledMap *)tiledMap synth:(id<SoundEventReceiver>)synth dragProxy:(id<DragButtonTouchProxy>)dragProxy
{
    GridCoord cell = [tiledMap gridCoordForObject:arrow];
    kDirection facing = [SGTiledUtils directionNamed:[CCTMXTiledMap objectPropertyNamed:kTLDPropertyDirection object:arrow]];
    return [self initWithSynth:synth cell:cell facing:facing dragProxy:dragProxy];
}

- (id)initWithSynth:(id<SoundEventReceiver>)synth cell:(GridCoord)cell facing:(kDirection)facing dragProxy:(id<DragButtonTouchProxy>)dragProxy
{
    self = [super initWithSynth:synth dragProxy:dragProxy];
    if (self) {
        self.cell = cell;
        self.facing = facing;
        self.sprite = [self createAndCenterSpriteNamed:[self imageNameForFacing:facing on:NO]];
        self.position = [GridUtils relativePositionForGridCoord:cell unitSize:kSizeGridUnit];
        [self addChild:self.sprite];
    }
    return self;
}

- (NSString *)imageNameForFacing:(kDirection)facing on:(BOOL)on
{
    switch (facing) {
        case kDirectionDown:
            return kImageArrowDown;
        case kDirectionUp:
            return kImageArrowUp;
        case kDirectionLeft:
            return kImageArrowLeft;
        case kDirectionRight:
            return kImageArrowRight;
        default:
            NSLog(@"warning: invalid direction for arrow image");
            return @"";
            break;
    }
}

- (void)rotateClockwise
{
    if (self.facing == kDirectionUp) {
        self.facing = kDirectionRight;
    }
    else if (self.facing == kDirectionRight) {
        self.facing = kDirectionDown;
    }
    else if (self.facing == kDirectionDown) {
        self.facing = kDirectionLeft;
    }
    else if (self.facing == kDirectionLeft) {
        self.facing = kDirectionUp;
    }
    
    NSString *imageName = [self imageNameForFacing:self.facing on:NO];
    [SpriteUtils switchImageForSprite:self.sprite textureKey:imageName];
}

#pragma mark - CCTargetedTouchDelegate

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ([super ccTouchBegan:touch withEvent:event]) {
        NSString *event = [self tick:kBPM];
        [self.synth receiveEvents:@[event]];
        [self rotateClockwise];
        return YES;
    }
    return NO;
}

#pragma mark - TickResponder

- (NSString *)tick:(NSInteger)bpm
{
    return [GridUtils directionStringForDirection:self.facing];
}

- (void)afterTick:(NSInteger)bpm
{
    
}

- (GridCoord)responderCell
{
    return self.cell;
}

@end
