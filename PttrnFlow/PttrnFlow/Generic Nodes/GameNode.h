//
//  GameNode.h
//  PttrnFlow
//
//  Created by John Saba on 9/14/13.
//
//

#import "cocos2d.h"
#import "GridUtils.h"


@interface GameNode : CCNode <CCTargetedTouchDelegate>

@property (assign) BOOL swallowsTouches;
@property (assign) BOOL isReceivingTouch;
@property (assign) CGFloat longPressDelay;

@property (strong, nonatomic) CCSprite *sprite;
@property (weak, nonatomic) CCSpriteBatchNode *batchNode;

@property (assign) GridCoord cell;
@property (assign) CGSize cellSize;

@property (copy, nonatomic) NSString *decaySpeed;

// holds batch node as weak ref, so make sure someone else owns batch node first
- (id)initWithBatchNode:(CCSpriteBatchNode *)batchNode;
- (id)initWithCell:(GridCoord)cell;
- (id)initWithBatchNode:(CCSpriteBatchNode *)batchNode cell:(GridCoord)cell;

// touch node functionality
- (void)longPress:(ccTime)deltaTime;

// subclasses should override and call super to handle any 'deselection behavior' triggered by pan start
- (void)cancelTouchForPan;

// replace current sprite we point with new sprite created from frame catch
// supports instances with or without batch nodes
- (void)setSpriteForFrameName:(NSString *)name;

// relative mid point in cell on screen (use to position sprites or other nodes with mid anchor point)
- (CGPoint)relativeMidpoint;

// TODO: need to update to work with batch node system
- (void)alignSprite:(kDirection)direction;


@end
