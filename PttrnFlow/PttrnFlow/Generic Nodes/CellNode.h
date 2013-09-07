//
//  CellNode.h
//  FishSet
//
//  Created by John Saba on 2/3/13.
//
//

#import "TouchNode.h"
#import "GridUtils.h"

@class CellNode;

@interface CellNode : TouchNode <TouchNodeDelegate>

// TODO: should this be a weak ref as we always will always add as a child?
@property (strong, nonatomic) CCSprite *sprite;
@property (weak, nonatomic) CCSpriteBatchNode *batchNode;
@property (assign) GridCoord cell;
@property (assign) CGSize cellSize;
@property (copy, nonatomic) NSString *decaySpeed;

// holds batch node as weak ref, so make sure someone else owns batch node first
- (id)initWithBatchNode:(CCSpriteBatchNode *)batchNode cell:(GridCoord)cell;

// replace current sprite we point to in batch node with new sprite created from frame catch
- (void)setSpriteForFrameName:(NSString *)name;

// relative mid point in cell on screen (use to position sprites or other nodes with mid anchor point)
- (CGPoint)relativeMidpoint;

// TODO: need to update to work with batch node system
- (void)alignSprite:(kDirection)direction;

// subclasses should override and call super to handle any 'deselection behavior' triggered by pan start
- (void)cancelTouchForPan;

@end
