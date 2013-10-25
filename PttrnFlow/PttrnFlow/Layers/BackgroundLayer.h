//
//  BackgroundLayer.h
//  PttrnFlow
//
//  Created by John Saba on 6/28/13.
//
//

#import "cocos2d.h"

@interface BackgroundLayer : CCLayerColor

+ (BackgroundLayer *)backgroundLayer;
- (void)tintToColor:(ccColor3B)color duration:(ccTime)duration;

@end
