//
//  PanNode.h
//  PttrnFlow
//
//  Created by John Saba on 10/19/13.
//
//

#import "GameNode.h"

typedef NS_ENUM(NSInteger, ScrollDirection)
{
    ScrollDirectionBoth = 0,
    ScrollDirectionHorizontal = 1,
    ScrollDirectionVertical = 2,
};

@interface PanNode : GameNode

@property (assign) ScrollDirection scrollDirection;
@property (weak, nonatomic) CCSprite *scrollSurface;

- (id)initWithBatchNode:(CCSpriteBatchNode *)batchNode contentSize:(CGSize)size scrollingSize:(CGSize)scrollingSize scrollSprites:(NSArray *)scrollSprites;

@end
