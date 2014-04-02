//
//  PFLTransitionSlide.m
//  PttrnFlow
//
//  Created by John Saba on 3/25/14.
//
//

#import "PFLTransitionSlide.h"
#import "cocos2d.h"

static CGFloat const kAdjustFactor = 0.5f; // see CCTransitionSlideInL for explanation of adjust factor

@interface PFLTransitionSlide ()

@property BOOL above;
@property BOOL forwards;
@property CGFloat leftPadding;
@property CGFloat rightPadding;

@end

@implementation PFLTransitionSlide

- (id)initWithDuration:(ccTime)t scene:(CCScene *)s above:(BOOL)above forwards:(BOOL)forwards leftPadding:(CGFloat)leftPadding rightPadding:(CGFloat)rightPadding
{
    NSAssert([s isKindOfClass:[CCScene class]], @"PFLTransitionSlide only supports CCScenes");
    self = [super initWithDuration:t scene:s];
    if (self) {
        self.above = above;
        self.forwards = forwards;
        self.leftPadding = leftPadding;
        self.rightPadding = rightPadding;
    }
    return self;
}

- (void)onEnter
{
	[super onEnter];
    
    // replaces [self initScenes]
    CGSize s = [[CCDirector sharedDirector] winSize];
    
    CCActionInterval *inAct;
    CCActionInterval *outAct;
    if (self.forwards) {
        CGFloat distance = (s.width + self.rightPadding) - kAdjustFactor;
        [inScene_ setPosition:ccp(distance, 0)];
        inAct = [CCMoveBy actionWithDuration:duration_ position:ccp(-distance, 0)];
        outAct = [CCMoveBy actionWithDuration:duration_ position:ccp(-distance, 0)];
    }
    else {
        CGFloat distance = (s.width + self.leftPadding) - kAdjustFactor;
        [inScene_ setPosition:ccp(-distance, 0)];
        inAct = [CCMoveBy actionWithDuration:duration_ position:ccp(distance, 0)];
        outAct = [CCMoveBy actionWithDuration:duration_ position:ccp(distance, 0)];
    }
    
    id inAction = [CCEaseSineOut actionWithAction:inAct];
	id outAction = [CCSequence actions:
					[CCEaseSineOut actionWithAction:outAct],
					[CCCallFunc actionWithTarget:self selector:@selector(finish)],
					nil];
    
    inSceneOnTop_ = self.above;
    
	[inScene_ runAction: inAction];
	[outScene_ runAction: outAction];
}

@end
