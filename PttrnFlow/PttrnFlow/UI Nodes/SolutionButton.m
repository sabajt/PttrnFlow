//
//  SolutionButton.m
//  PttrnFlow
//
//  Created by John Saba on 1/15/14.
//
//

#import "SolutionButton.h"
#import "ColorUtils.h"

@interface SolutionButton ()

@property (weak, nonatomic) id<SolutionButtonDelegate> delegate;
@property (weak, nonatomic) CCSprite *numberSprite;
@property (weak, nonatomic) CCSprite *hitDot;

@end

@implementation SolutionButton

- (id)initWithPlaceholderImage:(NSString *)placeholderImage size:(CGSize)size index:(NSInteger)index delegate:(id<SolutionButtonDelegate>)delegate
{
    self = [super initWithSpriteFrameName:placeholderImage];
    if (self) {
        self.contentSize = size;
        self.index = index;
        self.delegate = delegate;
        
        // dot that will appear and fade out when hit
        CCSprite *hitDot = [CCSprite spriteWithSpriteFrameName:@"numButtonHighlight.png"];
        self.hitDot = hitDot;
        hitDot.color = [ColorUtils activeYellow];
        hitDot.position = ccp(self.contentSize.width / 2, self.contentSize.height / 2);
        hitDot.opacity = 0;
        [self addChild:hitDot];
        
        CCSprite *numberSprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"numButton%i.png", index + 1]];
        self.numberSprite = numberSprite;
        numberSprite.color = [ColorUtils dimPurple];
        numberSprite.position = ccp(size.width / 2.0f, size.height / 2.0f);
        [self addChild:numberSprite];
    }
    return self;
}

- (void)press
{
    self.hitDot.position = self.numberSprite.position;
    CCFadeOut *fadeOut = [CCFadeOut actionWithDuration:1];
    [self.hitDot runAction:fadeOut];
    [self.delegate solutionButtonPressed:self];
}

- (void)animateCorrectHit:(BOOL)correct
{
    CGFloat  offset = -8.0f;
    if (correct) {
        offset *= -1.0f;
    }

    CCMoveTo *buttonMoveTo = [CCMoveTo actionWithDuration:1.0f position:ccp(self.numberSprite.position.x, (self.contentSize.height / 2) + offset)];
    CCEaseElasticOut *buttonEase = [CCEaseElasticOut actionWithAction:buttonMoveTo];
    [self.numberSprite runAction:buttonEase];
    self.isDisplaced = YES;
}

- (void)reset
{
    [self.numberSprite stopAllActions];
    self.numberSprite.position = ccp(self.numberSprite.position.x, self.numberSprite.contentSize.height / 2);
    self.isDisplaced = NO;
}

#pragma mark - CCTargetedTouchDelegate

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ([super ccTouchBegan:touch withEvent:event]) {
        [self press];
        return YES;
    }
    return NO;
}

@end
