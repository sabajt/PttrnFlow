//
//  CCLayerPanZoom+Utils.h
//  PttrnFlow
//
//  Created by John Saba on 7/3/13.
//
//

#import "CCLayerPanZoom.h"

@interface CCLayerPanZoom (Utils)

// calculates the position the layer should be set at for the content to appear at the origin of screen (bounding box origin  at 0,0)
- (CGPoint)positionAtBoundsOrigin;

@end
