////
////  TickerControl.m
////  PttrnFlow
////
////  Created by John Saba on 6/9/13.
////
////
//
//#import "TickerControl.h"
//#import "SpriteUtils.h"
//#import "CCSprite+Utils.h"
//#import "ColorUtils.h"
//#import "TickDispatcher.h"
//
//@interface TickerControl ()
//
//@property (weak, nonatomic) CCSprite *thumbSprite;
//@property (assign) CGSize unitSize;
//
//@end
//
//@implementation TickerControl
//
//- (id)initWithBatchNode:(CCSpriteBatchNode *)batchNode steps:(int)steps unitSize:(CGSize)unitSize
//{
//    self = [super initWithBatchNode:batchNode];
//    if (self) {
//        if (steps < 1) {
//            NSLog(@"warning: steps TickerControl should be > 1");
//        }
//    
//        self.swallowsTouches = YES;
//        self.contentSize = CGSizeMake(unitSize.width * steps, unitSize.height);
//        _steps = steps;
//        _unitSize = unitSize;
//        _currentIndex = 0;
//        
//        _thumbSprite = [CCSprite spriteWithSpriteFrameName:@"tickdot_on.png"];
//        self.thumbSprite.visible = NO;
//        [batchNode addChild:self.thumbSprite];
//        
//        for (int i = 0; i < steps; i++) {
//            CCSprite *spr = [CCSprite spriteWithSpriteFrameName:@"tickdot_off.png"];
//            CGPoint relPoint = ccp((i * self.unitSize.width + (self.unitSize.width / 2)), self.unitSize.height / 2);
//            CGPoint absPoint = ccp(relPoint.x + self.position.x, relPoint.y + self.position.y);
//            spr.position = absPoint;
//            [batchNode addChild:spr];
//        }
//        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAdvancedSequence:) name:kNotificationAdvancedSequence object:nil];
//
//    }
//    return self;
//}
//
////- (id)initWithNumberOfTicks:(int)numberOfTicks padding:(CGFloat)padding batchNode:(CCSpriteBatchNode *)batchNode origin:(CGPoint)origin
////{
////    self = [super init];
////    if (self) {
////        
////        
////        self.swallowsTouches = YES;
////        self.position = origin;
////        
////        _thumbSprite = [CCSprite spriteWithSpriteFrameName:@"tick_dot_on.png"];
////        self.thumbSprite.visible = NO;
////        [batchNode addChild:self.thumbSprite];
////        
////        _padding = padding;
////        _numberOfTicks = numberOfTicks;
////        _currentIndex = 0;
////        
////        for (int i = 0; i < numberOfTicks; i++) {
////            CCSprite *spr = [CCSprite spriteWithSpriteFrameName:@"tick_dot_off.png"];
////            _unitSize = spr.contentSize;
////            CGPoint relPoint = ccp((i * (self.unitSize.width + padding) + (self.unitSize.width / 2)), self.unitSize.height / 2);
////            CGPoint absPoint = ccp(relPoint.x + origin.x, relPoint.y + origin.y);
////            spr.position = absPoint;
////            [batchNode addChild:spr];
////        }
////        
////        CGFloat width = (self.unitSize.width + padding) * numberOfTicks;
////        self.contentSize = CGSizeMake(width, self.unitSize.height);
////        
////        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAdvancedSequence:) name:kNotificationAdvancedSequence object:nil];
////    }
////    return self;
////}
//
//- (int)nearestIndex:(UITouch *)touch
//{
//    CGPoint touchPosition = [self convertTouchToNodeSpace:touch];
//    CGFloat index = touchPosition.x / self.unitSize.width;
//    return (int)index;
//}
//
//- (void)handleTouch:(UITouch *)touch
//{
//    self.currentIndex = [self nearestIndex:touch];
//    if ((self.currentIndex < self.steps) && (self.currentIndex >= 0)) {
//        [self positionThumb:self.currentIndex];
//        [self.tickerControlDelegate tickerMovedToIndex:(self.currentIndex * 4)];
//    }
//}
//
//- (void)positionThumb:(int)index
//{
//    self.thumbSprite.visible = YES;
//    CGPoint relPoint = ccp((index * self.unitSize.width) + self.unitSize.width / 2, self.unitSize.height / 2);
//    self.thumbSprite.position = ccp(self.position.x + relPoint.x, self.position.y + relPoint.y);
//}
//
//- (void)handleAdvancedSequence:(NSNotification *)notification
//{
//    NSNumber *subIndex = notification.userInfo[kKeySequenceIndex];
//    self.currentIndex = ([subIndex intValue] / 4);
//    [self positionThumb:self.currentIndex];
//}
//
//#pragma mark - TouchNodeDelegate
//
//- (BOOL)containsTouch:(UITouch *)touch
//{
//    CGPoint touchPosition = [self convertTouchToNodeSpace:touch];
//    CGRect localBox = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
//    return CGRectContainsPoint(localBox, touchPosition);
//}
//
//#pragma mark CCNode SceneManagement
//
//- (void)onExit
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//	[super onExit];
//}
//
//#pragma mark CCTargetedTouchDelegate
//
//- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
//{
//    if ([super ccTouchBegan:touch withEvent:event]) {
//        [self handleTouch:touch];
//        return YES;
//    }
//    return NO;
//}
//
//- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
//{
//    [super ccTouchMoved:touch withEvent:event];
//    
//    if (self.currentIndex != [self nearestIndex:touch]) {
//        [self handleTouch:touch];
//    }
//}
//
//- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
//{
//    [super ccTouchEnded:touch withEvent:event];
//    [self.tickerControlDelegate tickerControlTouchUp];
//}
//
//@end
