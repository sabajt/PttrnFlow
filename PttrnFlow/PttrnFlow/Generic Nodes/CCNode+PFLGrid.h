//
//  CCNode+Grid.h
//  PttrnFlow
//
//  Created by John Saba on 11/23/13.
//
//

#import "CCNode.h"
#import "PFLCoord.h"

@interface CCNode (PFLGrid)

@property (strong, nonatomic) PFLCoord *cell;
@property (assign) CGSize cellSize;

@end
