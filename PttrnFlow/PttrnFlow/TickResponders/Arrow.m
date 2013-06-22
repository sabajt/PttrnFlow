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

@implementation Arrow

- (id)initWithArrow:(NSMutableDictionary *)arrow tiledMap:(CCTMXTiledMap *)tiledMap puzzleOrigin:(CGPoint)origin synth:(id<SoundEventReceiver>)synth;
{
    self = [super initWithSynth:synth];
    if (self) {
        self.cell = [tiledMap gridCoordForObject:arrow];
        NSString *facing = [CCTMXTiledMap objectPropertyNamed:kTLDPropertyDirection object:arrow];
        self.facing = [SGTiledUtils directionNamed:facing];
        NSString *imageName = [self imageNameForFacing:self.facing on:NO];
        self.sprite = [self createAndCenterSpriteNamed:imageName];
        [self addChild:self.sprite];
        self.position = [GridUtils absolutePositionForGridCoord:self.cell unitSize:kSizeGridUnit origin:origin];
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

#pragma mark - TouchNode

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ([super ccTouchBegan:touch withEvent:event]) {
        NSString *event = [self tick:kBPM];
        [self.synth receiveEvents:@[event]];
        [self rotateClockwise];
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
