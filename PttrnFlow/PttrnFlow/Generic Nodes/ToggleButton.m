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

@property (weak, nonatomic) id<ToggleButtonDelegate> delegate;

// using different sprites for on / off state
@property (weak, nonatomic) CCSprite *offSprite;
@property (weak, nonatomic) CCSprite *onSprite;

// using tint colors with one sprite for on / off state
@property (assign) ccColor3B defaultColor;
@property (assign) ccColor3B activeColor;

@end

@implementation ToggleButton

- (id)initWithPlaceholderImage:(NSString *)placeholderImage offImage:(NSString *)offImage onImage:(NSString *)onImage delegate:(id<ToggleButtonDelegate>)delegate
{
    self = [super initWithSpriteFrameName:placeholderImage];
    if (self) {
        self.delegate = delegate;
        
        CCSprite *offSprite = [CCSprite spriteWithSpriteFrameName:offImage];
        self.offSprite = offSprite;
        CCSprite *onSprite = [CCSprite spriteWithSpriteFrameName:onImage];
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

- (id)initWithImage:(NSString *)image defaultColor:(ccColor3B)defaultColor activeColor:(ccColor3B)activeColor delegate:(id<ToggleButtonDelegate>)delegate
{
    self = [super initWithSpriteFrameName:image];
    if (self) {
        self.delegate = delegate;
        self.defaultColor = defaultColor;
        self.activeColor = activeColor;
        self.color = defaultColor;
    }
    return self;
}

- (void)toggle
{
    self.isOn = !self.isOn;
    
    if (self.offSprite) {
        self.offSprite.visible = !self.isOn;
        self.onSprite.visible = self.isOn;
    }
    else {
        if (self.isOn) {
            self.color = self.activeColor;
        }
        else {
            self.color = self.defaultColor;
        }
    }
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
