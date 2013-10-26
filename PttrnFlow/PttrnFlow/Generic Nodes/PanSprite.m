//
//  PanSprite.m
//  PttrnFlow
//
//  Created by John Saba on 10/19/13.
//
//

#import "PanSprite.h"
#import "CCSprite+Utils.h"
#import "ClippingSprite.h"

@interface PanSprite ()

@property (assign) CGPoint lastTouchLocation;
@property (weak, nonatomic) ClippingSprite *clippingSprite;

@end

@implementation PanSprite

- (id)initWithSpriteFrameName:(NSString *)spriteFrameName contentSize:(CGSize)size scrollingSize:(CGSize)scrollingSize scrollSprites:(NSArray *)scrollSprites
{
    self = [super initWithSpriteFrameName:spriteFrameName];
    if (self) {
        self.swallowsTouches = NO;
        self.contentSize = size;
        self.scrollDirection = ScrollDirectionBoth;
        self.anchorPoint = ccp(0, 0);
        
        CCSprite *scrollSurface = [CCSprite spriteWithSpriteFrameName:@"clear_rect_uilayer.png"];
        _scrollSurface = scrollSurface;
        self.scrollSurface.contentSize = scrollingSize;
        self.scrollSurface.anchorPoint = ccp(0, 0);
        self.scrollSurface.position = CGPointZero;
        
        for (CCSprite *spr in scrollSprites) {
            [self.scrollSurface addChild:spr];
        }
        CGRect bounds = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
        ClippingSprite *clippingSprite = [ClippingSprite clippingSpriteWithRect:bounds];
        _clippingSprite = clippingSprite;
        _clippingSprite.position = ccp(self.contentSize.width / 2, self.contentSize.height / 2);
        [clippingSprite addChild:self.scrollSurface];
        [self addChild:clippingSprite];
    }
    return self;
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
    
    CGFloat leftScrollSurfaceEdge = -[self scrollableDistanceHorizontal];
    if (self.scrollSurface.position.x < leftScrollSurfaceEdge) {
        self.scrollSurface.position = ccp(leftScrollSurfaceEdge, self.scrollSurface.position.y);
    }
    CGFloat bottomScrollSurfaceEdge = -[self scrollableDistanceVertical];
    if (self.scrollSurface.position.y < bottomScrollSurfaceEdge) {
        self.scrollSurface.position = ccp(self.scrollSurface.position.x, bottomScrollSurfaceEdge);
    }
    if (self.scrollSurface.position.x > 0) {
        self.scrollSurface.position = ccp(0, self.scrollSurface.position.y);
    }
    if (self.scrollSurface.position.y > 0) {
        self.scrollSurface.position = ccp(self.scrollSurface.position.x, 0);
    }
}

- (BOOL)shouldPan:(CCArray *)children
{
    for (CCNode *child in children) {
        if ([child conformsToProtocol:@protocol(ScrollSpriteDelegate)]) {
            id<ScrollSpriteDelegate> delegate = (id<ScrollSpriteDelegate>)child;
            if ([delegate shouldStealTouch]) {
                return NO;
            }
        }
        else if (child.children.count > 0) {
            if (![self shouldPan:child.children]) {
                return NO;
            }
        }
    }
    return YES;
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
    if ([self containsTouch:touch] && [self shouldPan:self.children]) {
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
