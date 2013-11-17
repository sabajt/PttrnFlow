//
//  AudioPad.m
//  PttrnFlow
//
//  Created by John Saba on 8/25/13.
//
//

#import "AudioPad.h"

@interface AudioPad ()

@property (strong, nonatomic) CCSprite *highlightSprite;

@end


@implementation AudioPad

- (id)initWithCell:(GridCoord)cell
{
    self = [super initWithSpriteFrameName:@"audio_box_off.png" cell:cell];
    if (self) {
        CCSprite *highlightSprite = [CCSprite spriteWithSpriteFrameName:@"audio_box_on.png"];
        _highlightSprite = highlightSprite;
        highlightSprite.visible = NO;
        highlightSprite.position = ccp(self.contentSize.width / 2, self.contentSize.height / 2);
        [self addChild:highlightSprite];
    }
    return self;
}

#pragma mark - TickResponder

- (NSArray *)tick:(NSInteger)bpm
{
    self.highlightSprite.visible = YES;
    return @[@"audio_pad"];
}

- (void)afterTick:(NSInteger)bpm
{
    self.highlightSprite.visible = NO;
}

- (GridCoord)responderCell
{
    return self.cell;
}

@end
