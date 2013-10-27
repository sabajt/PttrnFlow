//
//  ClippingSprite.h
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

/** Restricts (clips) drawing of all children to a specific region. */
@interface ClippingSprite : CCSprite
{
    CGRect clippingRegionInNodeCoordinates;
    CGRect clippingRegion;
}

@property (nonatomic) CGRect clippingRegion;

+ (id)clippingSpriteWithRect:(CGRect)rect;

@end