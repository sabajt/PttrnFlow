//
//  SequenceMenuLayer.h
//  PttrnFlow
//
//  Created by John Saba on 6/12/13.
//
//

#import "cocos2d.h"
#import "PFLSequenceMenuCell.h"

@interface PFLPuzzleSetLayer : CCLayer <SequenceMenuCellDelegate>

@property (strong, nonatomic) NSArray *mapNames;

+ (CCScene *)scene;

@end
