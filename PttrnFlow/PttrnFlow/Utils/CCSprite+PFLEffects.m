//
//  CCSprite+PFLEffects.m
//  PttrnFlow
//
//  Created by John Saba on 3/20/14.
//
//

#import "CCSprite+PFLEffects.h"
#import "cocos2d.h"

@implementation CCSprite (PFLEffects)

- (void)backlight:(CGFloat)beatDuration completion:(void (^)(void))completion
{
    CCFadeOut *fadeOut = [CCFadeOut actionWithDuration:beatDuration * 2.0f];
    [self runAction:[CCEaseSineOut actionWithAction:fadeOut]];

    CGFloat originalScale = self.scale;
    CCScaleTo *scaleUp = [CCScaleTo actionWithDuration:beatDuration * 2.0f scale:self.scale + 0.5f];
    CCEaseSineOut *easeUp = [CCEaseSineOut actionWithAction:scaleUp];
    CCCallBlock *resetScale = [CCCallBlock actionWithBlock:^{
        self.scale = originalScale;
    }];
    
    CCCallBlock *completionAction = [CCCallBlock actionWithBlock:^{
        if (completion) {
            completion();
        }
    }];
    
    [self runAction:[CCSequence actionWithArray:@[easeUp, resetScale, completionAction]]];
}

@end
