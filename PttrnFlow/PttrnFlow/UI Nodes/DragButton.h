//
//  DragButton.h
//  PttrnFlow
//
//  Created by John Saba on 7/1/13.
//
//

#import "TouchNode.h"
#import "DragItemDelegate.h"


@interface DragButton : TouchNode <TouchNodeDelegate>

@property (weak, nonatomic) id<DragItemDelegate> dragItemDelegate;

- (id)initWithItemType:(kDragItem)itemType delegate:(id<DragItemDelegate>)delegate;

- (CGFloat)buttonWidth;


@end
