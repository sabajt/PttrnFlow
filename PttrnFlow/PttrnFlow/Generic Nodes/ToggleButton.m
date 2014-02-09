//
//  ToggleButton.m
//  PttrnFlow
//
//  Created by John Saba on 1/19/14.
//
//

#import "ToggleButton.h"
#import "PFGeometry.h"

@interface ToggleButton ()

@property (weak, nonatomic) CCSprite *offSprite;
@property (weak, nonatomic) CCSprite *onSprite;
@property (weak, nonatomic) id<ToggleButtonDelegate> delegate;

@end

@implementation ToggleButton

- (id)initWithPlaceholderFrameName:(NSString *)placeholderFrameName offFrameName:(NSString *)offFrameName onFrameName:(NSString *)onFrameName delegate:(id<ToggleButtonDelegate>)delegate
{
    self = [super initWithSpriteFrameName:placeholderFrameName];
    if (self) {
        self.delegate = delegate;
        
        CCSprite *offSprite = [CCSprite spriteWithSpriteFrameName:offFrameName];
        self.offSprite = offSprite;
        CCSprite *onSprite = [CCSprite spriteWithSpriteFrameName:onFrameName];
        self.onSprite = onSprite;
        
        // minimum size to contain both sprites
        self.contentSize = CGContainingSize(offSprite.contentSize, onSprite.contentSize);
        
        offSprite.position = ccp(self.contentSize.width / 2, self.contentSize.height / 2);
        [self addChild:offSprite];
        
        onSprite.position = ccp(self.contentSize.width / 2, self.contentSize.height / 2);
        [self addChild:onSprite];
        onSprite.visible = NO;
    }
    return self;
}

- (void)toggle
{
    self.isOn = !self.isOn;
    self.offSprite.visible = !self.isOn;
    self.onSprite.visible = self.isOn;
    [self.delegate toggleButtonPressed:self];
}

#pragma mark - CCTargetedTouchDelegate

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ([super ccTouchBegan:touch withEvent:event]) {
        [self toggle];
        return YES;
    }
    return NO;
}

@end
