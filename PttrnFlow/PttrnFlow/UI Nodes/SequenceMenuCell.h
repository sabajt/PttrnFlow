//
//  SequenceMenuCell.h
//  PttrnFlow
//
//  Created by John Saba on 6/12/13.
//
//

#import "TouchSprite.h"

@class SequenceMenuCell;

@protocol SequenceMenuCellDelegate <NSObject>

- (void)sequenceMenuCellTouchUpInside:(SequenceMenuCell *)cell index:(int)index;

@end


@interface SequenceMenuCell : TouchSprite

@property (weak, nonatomic) id<SequenceMenuCellDelegate> menuCellDelegate;

-(id) initWithIndex:(int)index;

@end
