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

@synthesize containerWidth = _containerWidth;

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
        _clippingSprite.anchorPoint = ccp(0, 0);
        _clippingSprite.position = ccp(0, 0);
        [clippingSprite addChild:self.scrollSurface];
        [self addChild:clippingSprite];
    }
    return self;
}

- (void)setContainerWidth:(CGFloat)containerWidth
{
    _containerWidth = containerWidth;
    self.contentSize = CGSizeMake(containerWidth, self.contentSize.height);
}

- (CGFloat)containerWidth
{
    return _containerWidth;
}

- (void)setNilValueForKey:(NSString *)key
{
    if ([key isEqualToString:@"containerWidth"]) {
        [self setValue:@YES forKey:@"containerWidth"];
    }
    else {
        [super setNilValueForKey:key];
    }
}

- (void)setContentSize:(CGSize)contentSize
{
    [super setContentSize:contentSize];
    self.clippingSprite.clippingRegion = CGRectMake(0, 0, contentSize.width, contentSize.height);
}

- (CGFloat)scrollableDistanceHorizontal
{
    NSLog(@"scroll surface content size: %@, content size: %@", NSStringFromCGSize(self.scrollSurface.contentSize), NSStringFromCGSize(self.contentSize));
    return (self.scrollSurface.contentSize.width - self.contentSize.width);
}

- (CGFloat)scrollableDistanceVertical
{
    return (self.scrollSurface.contentSize.height - self.contentSize.height);
}

- (CGFloat)scrollSurfaceRight
{
    return (self.scrollSurface.position.x + self.scrollSurface.contentSize.width);
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
    NSLog(@"left scroll surface edge: %f", leftScrollSurfaceEdge);
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

- (void)blockScrollNodesFromReceivingTouch:(BOOL)shouldBlock
{
    for (id child in self.scrollSurface.children) {
        if ([child conformsToProtocol:@protocol(ScrollSpriteDelegate)]) {
            id<ScrollSpriteDelegate> delegate = (id<ScrollSpriteDelegate>)child;
            [delegate blockTouch:shouldBlock];
        }
    }
}

#pragma mark CCTargetedTouchDelegate

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ([super ccTouchBegan:touch withEvent:event]) {
        self.lastTouchLocation = [self convertTouchToNodeSpace:touch];
        return YES;
    }
    // if touch is outside of our bounds, don't pass touch to scrolling children
    [self blockScrollNodesFromReceivingTouch:YES];
    
    return NO;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super ccTouchMoved:touch withEvent:event];
    if ([self containsTouch:touch]) {
        [self blockScrollNodesFromReceivingTouch:NO];
        
        if ([self shouldPan:self.children]) {
            CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
            CGPoint translation = ccp(touchLocation.x - self.lastTouchLocation.x, touchLocation.y - self.lastTouchLocation.y);
            [self scrollWithTranslation:translation];
            self.lastTouchLocation = touchLocation;
        }
    }
    else {
        [self blockScrollNodesFromReceivingTouch:YES];
    }
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super ccTouchEnded:touch withEvent:event];
    
    // unblock scrolling children from receiving touches
    [self blockScrollNodesFromReceivingTouch:NO];
}

- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super ccTouchCancelled:touch withEvent:event];
    
    // unblock scrolling children from receiving touches
    [self blockScrollNodesFromReceivingTouch:NO];
}

#pragma mark - TouchNodeDelegate

- (BOOL)containsTouch:(UITouch *)touch
{
    CGPoint touchPosition = [self convertTouchToNodeSpace:touch];
    CGRect rect = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
    return (CGRectContainsPoint(rect, touchPosition));
}

@end