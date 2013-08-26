//
//  Drum.m
//  PttrnFlow
//
//  Created by John Saba on 6/22/13.
//
//

#import "Drum.h"
#import "CCTMXTiledMap+Utils.h"
#import "SGTiledUtils.h"
#import "SpriteUtils.h"
#import "CCSprite+Utils.h"
#import "TextureUtils.h"
#import "TickDispatcher.h"

@interface Drum ()

@property (copy, nonatomic) NSString *pattern;

@end


@implementation Drum

- (id)initWithDrum:(NSMutableDictionary *)drum tiledMap:(CCTMXTiledMap *)tiledMap
{
    self = [super init];
    if (self) {
        self.cell = [tiledMap gridCoordForObject:drum];
        self.pattern = [CCTMXTiledMap objectPropertyNamed:kTLDPropertyPattern object:drum];
        NSString *imageName = [self imageNameForPattern:self.pattern on:NO];
        self.sprite = [self createAndCenterSpriteNamed:imageName];
        [self addChild:self.sprite];
        self.position = [GridUtils relativePositionForGridCoord:self.cell unitSize:kSizeGridUnit];
    }
    return self;
}

- (NSString *)imageNameForPattern:(NSString *)pattern on:(BOOL)on
{
    if ([pattern isEqualToString:@"d1"]) {
        if (on) {
            return kImageDrum1_on;
        }
        return kImageDrum1;
    }
    else if ([pattern isEqualToString:@"d2"]) {
        if (on) {
            return kImageDrum2_on;
        }
        return kImageDrum2;
    }
    else if ([pattern isEqualToString:@"d3"]) {
        if (on) {
            return kImageDrum3_on;
        }
        return kImageDrum3;
    }
    else if ([pattern isEqualToString:@"d4"]) {
        if (on) {
            return kImageDrum4_on;
        }
        return kImageDrum4;
    }
    NSLog(@"WARNING: drum image name for pattern '%@' not found", pattern);
    return nil;
}

- (void)deselect
{
    [SpriteUtils switchImageForSprite:self.sprite textureKey:[self imageNameForPattern:self.pattern on:NO]];
}

#pragma mark - SynthCellNode

- (void)cancelTouchForPan
{
    [super cancelTouchForPan];
    [self afterTick:kBPM];
}

#pragma mark - CCTargetedTouchDelegate

//- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
//{
//    if ([super ccTouchBegan:touch withEvent:event]) {
//        NSString *event = [self tick:kBPM];
//        [MainSynth receiveEvents:@[event]];
//        return YES;
//    }
//    return NO;
//}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    [self deselect];
}


#pragma mark - Tick Responder

- (NSString *)tick:(NSInteger)bpm
{
    [SpriteUtils switchImageForSprite:self.sprite textureKey:[self imageNameForPattern:self.pattern on:YES]];
    return self.pattern;
}

- (void)afterTick:(NSInteger)bpm
{
    [self deselect];
}

- (GridCoord)responderCell
{
    return self.cell;
}


@end
