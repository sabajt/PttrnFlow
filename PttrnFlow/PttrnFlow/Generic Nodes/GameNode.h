//
//  GameNode.h
//  PttrnFlow
//
//  Created by John Saba on 9/14/13.
//
//

#import "cocos2d.h"
#import "GridUtils.h"
#import "TouchNode.h"

@interface GameNode : TouchNode <TouchNodeDelegate>

@property (strong, nonatomic) CCSprite *sprite;
@property (weak, nonatomic) CCSpriteBatchNode *batchNode;

@property (assign) GridCoord cell;
@property (assign) CGSize cellSize;

@property (copy, nonatomic) NSString *decaySpeed;

// holds batch node as weak ref, so make sure someone else owns batch node first
- (id)initWithBatchNode:(CCSpriteBatchNode *)batchNode;
- (id)initWithCell:(GridCoord)cell;
- (id)initWithBatchNode:(CCSpriteBatchNode *)batchNode cell:(GridCoord)cell;

// subclasses should override and call super to handle any 'deselection behavior' triggered by pan start
- (void)cancelTouchForPan;

// replace current sprite we point with new sprite created from frame catch
// supports instances with or without batch nodes
- (void)setSpriteForFrameName:(NSString *)name;
- (void)setSpriteForFrameName:(NSString *)name cell:(GridCoord)cell;
- (void)setSpriteForFrameName:(NSString *)name position:(CGPoint)position;

// TODO: need to update to work with batch node system
- (void)alignSprite:(kDirection)direction;

@end