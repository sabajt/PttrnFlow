//
//  ClippingSprite.m
//

#import "ClippingSprite.h"

@implementation ClippingSprite

+ (id)clippingSpriteWithRect:(CGRect)rect
{
    return [[self alloc] initWithRect:rect];
}

- (id)initWithRect:(CGRect)rect
{
    if ((self = [super init])) {
        [self setClippingRegion:rect];
    }
    return self;
}

- (CGRect)clippingRegion
{
    return clippingRegionInNodeCoordinates;
}

- (void)setClippingRegion:(CGRect)region
{
    // keep the original region coordinates in case the user wants them back unchanged
    clippingRegionInNodeCoordinates = region;
    self.contentSize = clippingRegionInNodeCoordinates.size;
    
    // convert to retina coordinates if needed
    region = CC_RECT_POINTS_TO_PIXELS(region);
    
    // respect scaling
    clippingRegion = CGRectMake(region.origin.x * self.scaleX, region.origin.y * self.scaleY, region.size.width * self.scaleX, region.size.height * self.scaleY);
}

- (void)setScale:(float)newScale
{
    [super setScale:newScale];
    [self setClippingRegion:clippingRegionInNodeCoordinates];
}

- (void)visit
{
    glEnable(GL_SCISSOR_TEST);
    CGPoint worldPosition = [self convertToWorldSpace:CGPointZero];

    const CGFloat s = [[CCDirector sharedDirector] contentScaleFactor];
    glScissor(clippingRegion.origin.x + (worldPosition.x * s),
              clippingRegion.origin.y + (worldPosition.y * s),
              clippingRegion.size.width,
              clippingRegion.size.height);
    
    [super visit];
    
    glDisable(GL_SCISSOR_TEST);
}

@end
