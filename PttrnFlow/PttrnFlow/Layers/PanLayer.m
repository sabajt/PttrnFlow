//
//  PanLayer.m
//  PttrnFlow
//
//  Created by John Saba on 12/22/13.
//
//

#import "PanLayer.h"

static CGFloat const kDeceleration = 0.94;
static CGFloat const kLowerSpeedLimit = 10.0;
static CGFloat const kDecelerationInterval = 1.0 / 120.0;

@interface PanLayer ()

@property (assign) CGPoint panStartLocation;
@property (assign) CGPoint velocity;

@property (weak, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;

@end

@implementation PanLayer

- (void)onEnter
{
    [super onEnter];
    
    // attach pan
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    self.panGestureRecognizer = pan;
    pan.delegate = self;
    [[CCDirector sharedDirector].view addGestureRecognizer:pan];
}

- (void)onExit
{
    [[CCDirector sharedDirector].view removeGestureRecognizer:self.panGestureRecognizer];
    [super onExit];
}

#pragma mark - Pan momentum

- (void)pan:(UIGestureRecognizer *)gesture
{
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gesture;
    UIView *view = [CCDirector sharedDirector].view;
    
    CGPoint rawTranslation = [pan translationInView:view];
    CGPoint translation = CGPointMake(rawTranslation.x, -rawTranslation.y);
    CGPoint velocity = [pan velocityInView:view];
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: {
            
            self.panStartLocation = self.position;
            break;
        }
        case UIGestureRecognizerStateChanged: {
            
            self.position = CGPointMake(self.panStartLocation.x + (translation.x * [@(self.allowsPanHorizontal) integerValue]),
                                        self.panStartLocation.y + (translation.y * [@(self.allowsPanVertical) integerValue]));
            break;
        }
        case UIGestureRecognizerStateEnded: {
            
            self.velocity = velocity;
            [self schedule:@selector(decelarate:) interval:kDecelerationInterval];
            break;
        }
        case UIGestureRecognizerStateCancelled: {
            
            break;
        }
        default: {
            break;
        }
    }
}

- (void)decelarate:(ccTime)deltaTime
{
    static CGFloat framesPerSecond = 60.0;
    self.velocity = CGPointMake(self.velocity.x * kDeceleration, self.velocity.y * kDeceleration);
    
    CGPoint deltaPosition = CGPointMake((self.velocity.x / framesPerSecond) * [@(self.allowsPanHorizontal) integerValue],
                                        (-self.velocity.y / framesPerSecond) * [@(self.allowsPanVertical) integerValue]);
    
    self.position = CGPointMake(self.position.x + deltaPosition.x, self.position.y + deltaPosition.y);
    
    if ((fabsf(self.velocity.x) < kLowerSpeedLimit) && (fabsf(self.velocity.y) < kLowerSpeedLimit)) {
        [self unschedule:@selector(decelarate:)];
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        return YES;
    }
    return NO;
}

#pragma mark - CCStandardTouchDelegate

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self unschedule:@selector(decelarate:)];
}

@end
