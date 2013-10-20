//
//  PanNode.m
//  PttrnFlow
//
//  Created by John Saba on 10/19/13.
//
//

#import "PanNode.h"
#import "CCSprite+Utils.h"

@interface PanNode ()

@property (assign) CGPoint lastTouchLocation;

@end

@implementation PanNode

- (id)initWithBatchNode:(CCSpriteBatchNode *)batchNode contentSize:(CGSize)size scrollingSize:(CGSize)scrollingSize scrollSprites:(NSArray *)scrollSprites
{
    self = [super initWithBatchNode:batchNode];
    if (self) {
        self.swallowsTouches = YES;
        self.contentSize = size;
        self.scrollDirection = ScrollDirectionBoth;
        
        CCSprite *scrollSurface = [CCSprite spriteWithSpriteFrameName:@"blankRectClear.png"];
        _scrollSurface = scrollSurface;
        
        self.scrollSurface.contentSize = scrollingSize;
        self.scrollSurface.anchorPoint = ccp(0, 0);
        
        for (CCSprite *spr in scrollSprites) {
            [self.scrollSurface addChild:spr];
        }
        [batchNode addChild:self.scrollSurface];
    }
    return self;
}

- (void)setPosition:(CGPoint)position
{
    [super setPosition:position];
    _scrollSurface.position = position;
}

- (CGFloat)scrollableDistanceHorizontal
{
    return (self.scrollSurface.contentSize.width - self.contentSize.width);
}

- (CGFloat)scrollableDistanceVertical
{
    return (self.scrollSurface.contentSize.height - self.contentSize.height);
}

- (void)scrollWithTranslation:(CGPoint)translation
{
    // correct for one-way movement if needed
    CGPoint correctedTranslation = translation;
    switch (self.scrollDirection) {
        case ScrollDirectionHorizontal:
            correctedTranslation = ccp(translation.x, 0);
            break;
        case ScrollDirectionVertical:
            correctedTranslation = ccp(0, translation.y);
        default:
            break;
    }
    
    // scroll, stopping at edges
    self.scrollSurface.position = ccp(self.scrollSurface.position.x + correctedTranslation.x, self.scrollSurface.position.y + correctedTranslation.y);
    
    CGFloat leftScrollSurfaceEdge = self.position.x - [self scrollableDistanceHorizontal];
    if (self.scrollSurface.position.x < leftScrollSurfaceEdge) {
        self.scrollSurface.position = ccp(leftScrollSurfaceEdge, self.scrollSurface.position.y);
    }
    CGFloat bottomScrollSurfaceEdge = self.position.y - [self scrollableDistanceHorizontal];
    if (self.scrollSurface.position.y < bottomScrollSurfaceEdge) {
        self.scrollSurface.position = ccp(self.scrollSurface.position.x, bottomScrollSurfaceEdge);
    }
    if (self.scrollSurface.position.x > self.position.x) {
        self.scrollSurface.position = ccp(self.position.x, self.scrollSurface.position.y);
    }
    if (self.scrollSurface.position.y > self.position.y) {
        self.scrollSurface.position = ccp(self.scrollSurface.position.x, self.position.y);
    }
}

#pragma mark CCTargetedTouchDelegate

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ([super ccTouchBegan:touch withEvent:event]) {
        self.lastTouchLocation = [self convertTouchToNodeSpace:touch];
        return YES;
    }
    return NO;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super ccTouchMoved:touch withEvent:event];
    if ([self.touchNodeDelegate containsTouch:touch]) {
        CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
        CGPoint translation = ccp(touchLocation.x - self.lastTouchLocation.x, touchLocation.y - self.lastTouchLocation.y);
        [self scrollWithTranslation:translation];
        self.lastTouchLocation = touchLocation;
    }
}

//- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
//{
//    if (self.longPressDelay > 0) {
//        [self unschedule:@selector(longPress:)];
//    }
//    self.isReceivingTouch = NO;
//}
//
//- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
//{
//    if (self.longPressDelay > 0) {
//        [self unschedule:@selector(longPress:)];
//    }
//    self.isReceivingTouch = NO;
//}

#pragma mark - TouchNodeDelegate

- (BOOL)containsTouch:(UITouch *)touch
{
    CGPoint touchPosition = [self convertTouchToNodeSpace:touch];
    CGRect rect = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
    return (CGRectContainsPoint(rect, touchPosition));
}

@end
