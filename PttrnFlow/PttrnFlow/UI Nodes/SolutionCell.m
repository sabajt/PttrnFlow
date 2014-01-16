//
//  SolutionCell.m
//  PttrnFlow
//
//  Created by John Saba on 1/15/14.
//
//

#import "SolutionCell.h"

@interface SolutionCell ()

@property (weak, nonatomic) CCSprite *hitDot;

@end

@implementation SolutionCell

- (id)initWithIndex:(NSInteger)index
{
    self = [super initWithSpriteFrameName:@"clear_rect_uilayer.png"];
    if (self) {
        self.index = index;
        
        // will want to pass in size later - at least to base off of screen size
        self.contentSize = CGSizeMake(320 / 8, 50);
        
        // once it's clear how many numbers there will be (probably just 16) replace with sprites so we can use batch
        CCLabelTTF *numberLabel = [CCLabelTTF labelWithString:[@(index + 1) stringValue] fontName:@"Helvetica" fontSize:20];
        numberLabel.color = ccBLACK;
        numberLabel.anchorPoint = ccp(0.5, 0.5);
        numberLabel.position = ccp(self.contentSize.width / 2, self.contentSize.height / 2);
        [self addChild:numberLabel];
        
        // dot that will appear and fade out when hit
        CCSprite *hitDot = [CCSprite spriteWithSpriteFrameName:@"tickdot_on.png"];
        hitDot.position = ccp(self.contentSize.width / 2, self.contentSize.height / 2);
        hitDot.opacity = 0;
        self.hitDot = hitDot;
        [self addChild:hitDot];
    }
    return self;
}

#pragma mark -

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ([super ccTouchBegan:touch withEvent:event]) {
        
        NSLog(@"\n");
        NSLog(@"hit solution index: %i", self.index);
        NSLog(@"self contentsize: %@", NSStringFromCGSize(self.contentSize));
        NSLog(@"self position: %@", NSStringFromCGPoint(self.position));
        NSLog(@"self bounding box: %@", NSStringFromCGRect(self.boundingBox));
        
        self.hitDot.opacity = 255;
        CCFadeOut *fadeOut = [CCFadeOut actionWithDuration:1];
        [self.hitDot runAction:fadeOut];
        return YES;
    }
    return NO;
}

@end
