//
//  SequenceMenuLayer.h
//  PttrnFlow
//
//  Created by John Saba on 6/12/13.
//
//

#import "PFLScrollLayer.h"
#import "PFLPuzzleSetCell.h"

@class PFLPuzzleSet;

@interface PFLPuzzleSetLayer : PFLScrollLayer <PFLPuzzleSetCellDelegate>

@property (strong, nonatomic) NSArray *mapNames;

+ (CCScene *)sceneWithPuzzleSet:(PFLPuzzleSet *)puzzle leftPadding:(CGFloat)leftPadding rightPadding:(CGFloat)rightPadding;

@end
