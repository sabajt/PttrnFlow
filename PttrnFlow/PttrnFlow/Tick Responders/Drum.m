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

- (id)initWithDrum:(NSMutableDictionary *)drum batchNode:(CCSpriteBatchNode *)batchNode tiledMap:(CCTMXTiledMap *)tiledMap
{
    self = [super initWithBatchNode:batchNode];
    if (self) {
        self.cell = [tiledMap gridCoordForObject:drum];
        self.pattern = [CCTMXTiledMap objectPropertyNamed:kTLDPropertyPattern object:drum];
        [self switchSpriteForFrameName:[self frameNameForPattern:self.pattern on:NO]];
    }
    return self;
}

- (NSString *)frameNameForPattern:(NSString *)pattern on:(BOOL)on
{
    if (on) {
        return [NSString stringWithFormat:@"%@on.png", pattern];
    }
    return [NSString stringWithFormat:@"%@.png", pattern];
}

- (void)deselect
{
    [self switchSpriteForFrameName:[self frameNameForPattern:self.pattern on:NO]];
}


#pragma mark - SynthCellNode

- (void)cancelTouchForPan
{
    [super cancelTouchForPan];
    [self afterTick:kBPM];
}

#pragma mark - CCTargetedTouchDelegate

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super ccTouchEnded:touch withEvent:event];
    [self deselect];
}

#pragma mark - Tick Responder

- (NSArray *)tick:(NSInteger)bpm
{
    [self switchSpriteForFrameName:[self frameNameForPattern:self.pattern on:YES]];
    return @[[NSString stringWithFormat:@"sample_%@", self.pattern]];
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
