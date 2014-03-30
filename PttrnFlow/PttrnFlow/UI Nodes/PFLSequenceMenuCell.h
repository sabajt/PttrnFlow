//
//  SequenceMenuCell.h
//  PttrnFlow
//
//  Created by John Saba on 6/12/13.
//
//

#import "PFLTouchSprite.h"

@class PFLSequenceMenuCell;

@protocol SequenceMenuCellDelegate <NSObject>

- (void)sequenceMenuCellTouchUpInside:(PFLSequenceMenuCell *)cell index:(int)index;

@end


@interface PFLSequenceMenuCell : PFLTouchSprite

@property (weak, nonatomic) id<SequenceMenuCellDelegate> menuCellDelegate;

-(id) initWithIndex:(int)index;

@end
