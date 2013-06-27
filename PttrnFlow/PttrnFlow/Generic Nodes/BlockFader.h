//
//  BlockFader.h
//  PttrnFlow
//
//  Created by John Saba on 6/27/13.
//
//

#import "PrimativeCellActor.h"

@interface BlockFader : PrimativeCellActor

+ (id)blockFaderWithSize:(CGSize)size color:(ccColor3B)color cell:(GridCoord)cell;

@end
