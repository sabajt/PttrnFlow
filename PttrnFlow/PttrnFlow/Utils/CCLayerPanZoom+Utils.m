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

@end
