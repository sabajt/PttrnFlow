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

- (id)initWithCell:(GridCoord)cell moveable:(BOOL)moveable
{
    NSString *offFrameName = @"audio_box_off_static.png";
    if (moveable) {
        _moveable = YES;
        offFrameName = @"audio_box_off.png";
    }
    self = [super initWithSpriteFrameName:offFrameName cell:cell];
    if (self) {
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

- (GridCoord)responderCell
{
    return self.cell;
}

@end
