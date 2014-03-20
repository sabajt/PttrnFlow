//
//  AudioPad.m
//  PttrnFlow
//
//  Created by John Saba on 8/25/13.
//
//

#import "AudioPad.h"
#import "CCNode+Grid.h"
#import "CCSprite+PFLEffects.h"
#import "ColorUtils.h"
#import "GameConstants.h"

@interface AudioPad ()

@property (weak, nonatomic) CCSprite *boxSprite;
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
        highlightSprite.color = [ColorUtils activeYellow];
        highlightSprite.opacity = 0;
        highlightSprite.position = ccp(self.contentSize.width / 2, self.contentSize.height / 2);
        [self addChild:highlightSprite];
        
        NSString *boxFrameName = @"audio_box.png";
        CCSprite *boxSprite = [CCSprite spriteWithSpriteFrameName:boxFrameName];
        self.boxSprite = boxSprite;
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

- (PFLEvent *)audioHit:(CGFloat)beatDuration
{
    [self.highlightSprite backlight:beatDuration completion:nil];
    
    CCScaleTo *padScaleUp = [CCScaleTo actionWithDuration:beatDuration / 2.0f scale:1.2f];
    CCEaseSineIn *padEaseUp = [CCEaseSineIn actionWithAction:padScaleUp];
    CCScaleTo *padScaleDown = [CCScaleTo actionWithDuration:beatDuration / 2.0f scale:1.0f];
    CCEaseSineOut *padEaseDown = [CCEaseSineOut actionWithAction:padScaleDown];
    CCSequence *seq = [CCSequence actionWithArray:@[padEaseUp, padEaseDown]];
    [self.boxSprite runAction:seq];
    
    return nil;
}

- (Coord *)audioCell
{
    return self.cell;
}

@end
