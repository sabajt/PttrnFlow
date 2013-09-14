//
//  PrimativeCellActor.h
//  PttrnFlow
//
//  Created by John Saba on 6/27/13.
//
//

#import "GameNode.h"

@interface PrimativeCellActor : GameNode

- (id)initWithRectSize:(CGSize)size color:(ccColor3B)color cell:(GridCoord)cell;
- (id)initWithRectSize:(CGSize)size edgeLength:(CGFloat)edge color:(ccColor3B)color cell:(GridCoord)cell;

@end
