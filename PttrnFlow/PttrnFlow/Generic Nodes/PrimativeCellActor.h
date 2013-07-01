//
//  PrimativeCellActor.h
//  PttrnFlow
//
//  Created by John Saba on 6/27/13.
//
//

#import "CellNode.h"

@interface PrimativeCellActor : CellNode

- (id)initWithRectSize:(CGSize)size color:(ccColor3B)color cell:(GridCoord)cell touch:(BOOL)usesTouch;
- (id)initWithRectSize:(CGSize)size edgeLength:(CGFloat)edge color:(ccColor3B)color cell:(GridCoord)cell touch:(BOOL)usesTouch;
- (void)positionAtCell:(GridCoord)cell;

@end
