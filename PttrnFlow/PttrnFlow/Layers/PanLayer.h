//
//  PanLayer.h
//  PttrnFlow
//
//  Created by John Saba on 12/22/13.
//
//

#import "cocos2d.h"

@protocol PanLayerDelegate <NSObject>
@optional

- (BOOL)shouldPan;

@end

@interface PanLayer : CCLayer <UIGestureRecognizerDelegate>

@property (assign) BOOL allowsPanHorizontal;
@property (assign) BOOL allowsPanVertical;

@property (weak, nonatomic) id<PanLayerDelegate> panDelegate;

- (id)initWithPanBounds:(CGRect)bounds;

@end
