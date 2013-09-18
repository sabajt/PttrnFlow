//
//  SpritePicker.h
//  PttrnFlow
//
//  Created by John Saba on 7/6/13.
//
//

#import "GameNode.h"

@interface SpritePicker : GameNode

//- (id)initWithFrameNames:(NSArray *)frameNames batchNode:(CCSpriteBatchNode *)batchNode center:(CGPoint)center;
- (id)initWithFrameNames:(NSArray *)frameNames center:(CGPoint)center;
- (id)initWithFrameNames:(NSArray *)frameNames center:(CGPoint)center batchNode:(CCSpriteBatchNode *)batchNode;


- (int)numberOfSprites;
- (void)pickSprite:(int)index;
//- (CCSprite *)spriteAtIndex:(int)index;

@end
