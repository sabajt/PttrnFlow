//
//  CCLayerPanZoom+Utils.m
//  PttrnFlow
//
//  Created by John Saba on 7/3/13.
//
//

#import "CCLayerPanZoom+Utils.h"


@implementation CCLayerPanZoom (Utils)

// calculates the position the layer should be set at for the content to appear at the origin of screen (bounding box origin  at 0,0)
- (CGPoint)positionAtBoundsOrigin
{
    // still not sure why using CCLayerPanZoom offsets layer content by -1/2 of the contentSize... but it does! could be anchor point?
    static CGFloat transformOffset = 0.5f;
    return ccp(self.contentSize.width * transformOffset * self.scale, self.contentSize.height * transformOffset * self.scale);
}

- (CGPoint)positionAtCenterOfGridSized:(GridCoord)gridSize unitSize:(CGSize)unitSize constraintRect:(CGRect)constraintRect
{
    CGPoint origin = [self positionAtBoundsOrigin];
    CGSize scaledGridSize = CGSizeMake(gridSize.x * unitSize.width * self.scale, gridSize.y * unitSize.height * self.scale);
    CGSize offset = CGSizeMake((constraintRect.size.width - scaledGridSize.width)/2 + constraintRect.origin.x, (constraintRect.size.height - scaledGridSize.height)/2 + constraintRect.origin.y);
    return ccp(origin.x + offset.width, origin.y + offset.height);
}

- (CGFloat)scaleToFitGridSize:(GridCoord)gridSize unitSize:(CGSize)unitSize constraintSize:(CGSize)constraintSize
{
    CGSize area = CGSizeMake(gridSize.x * unitSize.width, gridSize.y * unitSize.height);
    return [self scaleToFitArea:area insideConstraintSize:constraintSize];
}

- (CGFloat)scaleToFitArea:(CGSize)area insideConstraintSize:(CGSize)constraintSize
{
    CGFloat scaleMaxHor = constraintSize.width / area.width;
    CGFloat scaleMaxVert = constraintSize.height / area.height;
    CGFloat scaleMaxFit =  fminf(scaleMaxHor, scaleMaxVert);
    return fmaxf(self.minScale,  fminf(scaleMaxFit, self.maxScale));    
}

@end
