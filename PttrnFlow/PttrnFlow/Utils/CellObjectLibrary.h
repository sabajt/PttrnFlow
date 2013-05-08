//
//  CellObjectLibrary.h
//  FishSet
//
//  Created by John Saba on 2/2/13.
//
//

#import <Foundation/Foundation.h>
#import "GridUtils.h"

@class CellNode;

FOUNDATION_EXPORT NSString *const kPGNotificationCellNodeLibraryChangedContents;


@interface CellObjectLibrary : NSObject

@property (nonatomic, strong) NSMutableDictionary *objectLibrary;

-(id) initWithGridSize:(GridCoord)size;

-(void) addNode:(CellNode *)node cell:(GridCoord)cell;
-(void) removeNode:(CellNode *)node cell:(GridCoord)cell;
-(void) transferNode:(CellNode *)node toCell:(GridCoord)cell fromCell:(GridCoord)moveFrom;

-(NSMutableArray *) nodesForCell:(GridCoord)cell;

-(BOOL) containsNode:(CellNode *)node cell:(GridCoord)cell;
-(BOOL) containsNodeOfKind:(Class)class cell:(GridCoord)cell;
-(BOOL) containsAnyNodeOfKinds:(NSArray *)kinds cell:(GridCoord)cell;

-(NSMutableArray *) nodesOfKind:(Class)class atCell:(GridCoord)cell;
-(id) firstNodeOfKind:(Class)class atCell:(GridCoord)cell;

@end
