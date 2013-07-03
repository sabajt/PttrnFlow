//
//  CCLayerPanZoom+Utils.h
//  PttrnFlow
//
//  Created by John Saba on 7/3/13.
//
//

#import "CCLayerPanZoom.h"
#import "GridUtils.h"

@interface CCLayerPanZoom (Utils)

// calculates the position the layer should be set at for the content to appear at the origin of screen (bounding box origin  at 0,0)
- (CGPoint)positionAtBoundsOrigin;
- (CGPoint)positionAtCenterOfGridSized:(GridCoord)gridSize unitSize:(CGSize)unitSize constraintRect:(CGRect)constraintRect;
- (CGFloat)scaleToFitGridSize:(GridCoord)gridSize unitSize:(CGSize)unitSize constraintSize:(CGSize)constraintSize;
- (CGFloat)scaleToFitArea:(CGSize)area insideConstraintSize:(CGSize)constraintSize;

@end
