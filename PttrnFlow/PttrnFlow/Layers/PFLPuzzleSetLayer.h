//
//  SequenceMenuLayer.h
//  PttrnFlow
//
//  Created by John Saba on 6/12/13.
//
//

#import "PFLScrollLayer.h"
#import "PFLPuzzleSetCell.h"

@interface PFLPuzzleSetLayer : PFLScrollLayer <PFLPuzzleSetCellDelegate>

@property (strong, nonatomic) NSArray *mapNames;

+ (CCScene *)scene;

@end
