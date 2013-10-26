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

+ (id)clippingSpriteWithRect:(CGRect)rect;

@property (nonatomic) CGRect clippingRegion;

@end