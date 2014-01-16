//
//  CCNode+Grid.h
//  PttrnFlow
//
//  Created by John Saba on 11/23/13.
//
//

#import "CCNode.h"
#import "Coord.h"

@interface CCNode (Grid)

@property (strong, nonatomic) Coord *cell;
@property (assign) CGSize cellSize;

@end
