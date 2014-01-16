//
//  Drum.m
//  PttrnFlow
//
//  Created by John Saba on 6/22/13.
//
//

#import "Sample.h"
#import "GameConstants.h"
#import "TickEvent.h"
#import "CCNode+Grid.h"

@interface Sample ()

// fragments
@property (copy, nonatomic) NSString *sampleName;

@end

@implementation Sample

- (id)initWithCell:(Coord *)cell sampleName:(NSString *)sampleName frameName:(NSString *)frameName
{
    self = [super initWithSpriteFrameName:frameName];
    if (self) {
        // CCNode+Grid
        self.cell = cell;
        self.cellSize = CGSizeMake(kSizeGridUnit, kSizeGridUnit);
        
        self.sampleName = sampleName;
    }
    return self;
}

#pragma mark - AudioResponder

- (Coord *)audioCell
{
    return self.cell;
}

- (NSArray *)audioHit:(NSInteger)bpm
{
    return @[self.sampleName];
}





//{
//    GridCoord cell = [tiledMap gridCoordForObject:drum];
//    self = [super initWithBatchNode:batchNode cell:cell];
//    if (self) {
//        self.pattern = [CCTMXTiledMap objectPropertyNamed:kTLDPropertyPattern object:drum];
//        [self setSpriteForFrameName:[self frameNameForPattern:self.pattern on:NO] cell:cell];
//    }
//    return self;
//}
//
//- (NSString *)frameNameForPattern:(NSString *)pattern on:(BOOL)on
//{
//    if (on) {
//        return [NSString stringWithFormat:@"%@on.png", pattern];
//    }
//    return [NSString stringWithFormat:@"%@.png", pattern];
//}
//
//- (void)deselect
//{
//    [self setSpriteForFrameName:[self frameNameForPattern:self.pattern on:NO] cell:self.cell];
//}
//
//
//#pragma mark - SynthCellNode
//
//- (void)cancelTouchForPan
//{
//    [super cancelTouchForPan];
//    [self audioRelease:kBPM];
//}
//
//#pragma mark - CCTargetedTouchDelegate
//
//- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
//{
//    [super ccTouchEnded:touch withEvent:event];
//    [self deselect];
//}
//
//#pragma mark - Tick Responder
//
//- (NSArray *)audioHit:(NSInteger)bpm
//{
//    [self setSpriteForFrameName:[self frameNameForPattern:self.pattern on:YES] cell:self.cell];
//    return @[[NSString stringWithFormat:@"sample_%@", self.pattern]];
//}
//
//- (void)audioRelease:(NSInteger)bpm
//{
//    [self deselect];
//}
//
//- (GridCoord)responderCell
//{
//    return self.cell;
//}


@end
