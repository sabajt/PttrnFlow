//
//  PrimativeCellActor.h
//  PttrnFlow
//
//  Created by John Saba on 6/27/13.
//
//

#import "CellNode.h"

@interface PrimativeCellActor : CellNode

- (id)initWithSize:(CGSize)size color:(ccColor3B)color cell:(GridCoord)cell textureKey:(NSString *)key touch:(BOOL)usesTouch;

@end
