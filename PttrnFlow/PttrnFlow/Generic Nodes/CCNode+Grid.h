//
//  CCNode+Grid.h
//  PttrnFlow
//
//  Created by John Saba on 11/23/13.
//
//

#import "CCNode.h"
#import "GridUtils.h"

@interface CCNode (Grid)

@property (assign) GridCoord cell;
@property (assign) CGSize cellSize;

@end
