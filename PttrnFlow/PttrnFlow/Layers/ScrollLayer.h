//
//  ScrollLayer.h
//  PttrnFlow
//
//  Created by John Saba on 1/24/14.
//
//

#import "cocos2d.h"

@interface ScrollLayer : CCLayer

@property (assign) CGRect scrollBounds;
@property (assign) BOOL allowsScrollHorizontal;
@property (assign) BOOL allowsScrollVertical;

@end
