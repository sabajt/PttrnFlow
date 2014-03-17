//
//  AudioPad.m
//  PttrnFlow
//
//  Created by John Saba on 8/25/13.
//
//

#import "AudioPad.h"
#import "CCNode+Grid.h"
#import "GameConstants.h"
#import "ColorUtils.h"

@interface AudioPad ()

@property (strong, nonatomic) CCSprite *highlightSprite;

@end


@implementation AudioPad

- (id)initWithPlaceholderFrameName:(NSString *)placeholderFrameName cell:(Coord *)cell isStatic:(BOOL)isStatic
{
    self = [super initWithSpriteFrameName:placeholderFrameName];
    if (self) {
        _isStatic = isStatic;
        
        CCSprite *highlightSprite = [CCSprite spriteWithSpriteFrameName:@"audio_box_highlight.png"];
        self.contentSize = highlightSprite.contentSize;
        _highlightSprite = highlightSprite;
        highlightSprite.opacity = 0;
        highlightSprite.position = ccp(self.contentSize.width / 2, self.contentSize.height / 2);
        [self addChild:highlightSprite];
        
        NSString *boxFrameName = @"audio_box.png";
        CCSprite *boxSprite = [CCSprite spriteWithSpriteFrameName:boxFrameName];
        boxSprite.position = ccp(self.contentSize.width / 2, self.contentSize.height / 2);
        [self addChild:boxSprite];
        boxSprite.color = [ColorUtils defaultPurple];
        if (isStatic) {
            boxSprite.color = [ColorUtils dimPurple];
        }

        // CCNode+Grid
        self.cell = cell;
        self.cellSize = CGSizeMake(kSizeGridUnit, kSizeGridUnit);
    }
    return self;
}

#pragma mark - AudioResponder

- (TickEvent *)audioHit:(CGFloat)beatDuration
{
    CCFadeOut *fadeOut = [CCFadeOut actionWithDuration:beatDuration];
    [self.highlightSprite runAction:[CCEaseSineOut actionWithAction:fadeOut]];
    
    return nil;
}

- (Coord *)audioCell
{
    return self.cell;
}

@end
