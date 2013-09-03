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

@interface CellNode : TouchNode

// TODO: should this be a weak ref as we always will always add as a child?
@property (strong, nonatomic) CCSprite *sprite;

@property (weak, nonatomic) CCSpriteBatchNode *batchNode;

@property (assign) GridCoord cell;
@property (copy, nonatomic) NSString *decaySpeed;

// holds batch node as weak ref, so make sure someone else owns batch node first
- (id)initWithBatchNode:(CCSpriteBatchNode *)batchNode;

// replace current sprite we point to in batch node with new sprite created from frame catch
- (void)switchSpriteForFrameName:(NSString *)name;

// returns sprite with image name, centered in content bounds (probably will get rid of this)
- (CCSprite *)createAndCenterSpriteNamed:(NSString *)name;

- (void)alignSprite:(kDirection)direction;

// subclasses should override and call super to handle any 'deselection behavior' triggered by pan start
- (void)cancelTouchForPan;

@end
