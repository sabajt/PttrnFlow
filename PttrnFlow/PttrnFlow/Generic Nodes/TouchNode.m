//
//  TouchNode.m
//  PttrnFlow
//
//  Created by John Saba on 6/14/13.
//
//

#import "TouchNode.h"
#import "CCNode+Touch.h"

@implementation TouchNode

- (id)init
{
    self = [super init];
    if (self) {
        self.swallowsTouches = NO;
    }
    return self;
}

#pragma mark CCNode SceneManagement

- (void)onEnter
{
    [super onEnter];
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:self.swallowsTouches];
}

- (void)onExit
{
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
	[super onExit];
}

#pragma mark CCTargetedTouchDelegate

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ([self containsTouch:touch]) {
        return YES;
    }
    return NO;
}

@end