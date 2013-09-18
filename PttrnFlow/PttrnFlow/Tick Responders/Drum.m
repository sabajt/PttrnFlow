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
    GridCoord cell = [tiledMap gridCoordForObject:drum];
    self = [super initWithBatchNode:batchNode cell:cell];
    if (self) {
        self.pattern = [CCTMXTiledMap objectPropertyNamed:kTLDPropertyPattern object:drum];
        [self setSpriteForFrameName:[self frameNameForPattern:self.pattern on:NO] cell:cell];
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
    [self setSpriteForFrameName:[self frameNameForPattern:self.pattern on:NO] cell:self.cell];
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
    [self setSpriteForFrameName:[self frameNameForPattern:self.pattern on:YES] cell:self.cell];
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
