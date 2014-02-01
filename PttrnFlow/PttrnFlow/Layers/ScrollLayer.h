//
//  ScrollLayer.h
//  PttrnFlow
//
//  Created by John Saba on 1/24/14.
//
//

#import "cocos2d.h"

@protocol ScrollLayerDelegate <NSObject>

@optional

- (BOOL)shouldScroll;

@end

@interface ScrollLayer : CCLayer

@property (weak, nonatomic) id<ScrollLayerDelegate> scrollDelegate;
@property (assign) CGRect scrollBounds;
@property (assign) BOOL allowsScrollHorizontal;
@property (assign) BOOL allowsScrollVertical;

@end
