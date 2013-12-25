//
//  PanLayer.h
//  PttrnFlow
//
//  Created by John Saba on 12/22/13.
//
//

#import "cocos2d.h"

@interface PanLayer : CCLayer <UIGestureRecognizerDelegate>

@property (assign) BOOL allowsPanHorizontal;
@property (assign) BOOL allowsPanVertical;

@end
