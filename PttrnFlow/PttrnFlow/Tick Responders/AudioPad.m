//
//  AudioPad.m
//  PttrnFlow
//
//  Created by John Saba on 8/25/13.
//
//

#import "AudioPad.h"
#import "CCNode+Grid.h"

@interface AudioPad ()

@property (strong, nonatomic) CCSprite *highlightSprite;

@end


@implementation AudioPad

- (id)initWithCell:(GridCoord)cell group:(NSNumber *)group isStatic:(BOOL)isStatic
{
    NSString *offFrameName = @"audio_box_off_static.png";
    if (!isStatic) {
        offFrameName = @"audio_box_off.png";
    }
    
    self = [super initWithSpriteFrameName:offFrameName];
    if (self) {
        _isStatic = isStatic;

        // CCNode+Grid
        self.cell = cell;
        self.cellSize = CGSizeMake(kSizeGridUnit, kSizeGridUnit);
        self.cellGroup = group;
        
        CCSprite *highlightSprite = [CCSprite spriteWithSpriteFrameName:@"audio_box_on.png"];
        _highlightSprite = highlightSprite;
        highlightSprite.visible = NO;
        highlightSprite.position = ccp(self.contentSize.width / 2, self.contentSize.height / 2);
        [self addChild:highlightSprite];
    }
    return self;
}

#pragma mark - AudioResponder

- (NSArray *)audioHit:(NSInteger)bpm
{
    self.highlightSprite.visible = YES;
    return @[@"audio_pad"];
}

- (NSArray *)audioRelease:(NSInteger)bpm
{
    self.highlightSprite.visible = NO;
    return nil;
}

- (GridCoord)audioCell
{
    return self.cell;
}

- (NSInteger)audioCluster
{
    if (self.cellGroup != nil) {
        return [self.cellGroup integerValue];
    }
    return AUDIO_CLUSTER_NONE;
}

//- (void)audioClusterMemberWasHit
//{
//    NSLog(@"*** my cluster (%i)was hit!!!\n*** i am of class:\n\n%@\n\n*** at cell: %i, %i", [self audioCluster], [self class], self.cell.x, self.cell.y);
//}

@end
