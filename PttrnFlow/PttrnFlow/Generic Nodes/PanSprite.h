//
//  PanSprite.h
//  PttrnFlow
//
//  Created by John Saba on 10/19/13.
//
//

#import "TouchSprite.h"

typedef NS_ENUM(NSInteger, ScrollDirection)
{
    ScrollDirectionBoth = 0,
    ScrollDirectionHorizontal = 1,
    ScrollDirectionVertical = 2,
};

@protocol ScrollSpriteDelegate <NSObject>

- (BOOL)shouldStealTouch;
- (void)blockTouch:(BOOL)blockTouch;

@end

@interface PanSprite : TouchSprite

@property (assign) ScrollDirection scrollDirection;
@property (weak, nonatomic) CCSprite *scrollSurface;
@property (assign) CGFloat containerWidth;

- (id)initWithSpriteFrameName:(NSString *)spriteFrameName contentSize:(CGSize)size scrollingSize:(CGSize)scrollingSize scrollSprites:(NSArray *)scrollSprites;
- (CGFloat)scrollSurfaceRight;

@end