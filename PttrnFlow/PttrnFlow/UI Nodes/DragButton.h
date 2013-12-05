//
//  DragButton.h
//  PttrnFlow
//
//  Created by John Saba on 7/1/13.
//
//

#import "TouchSprite.h"
#import "DragItemDelegate.h"

@interface DragButton : TouchSprite

@property (weak, nonatomic) id<DragItemDelegate> dragItemDelegate;

- (id)initWithItemKey:(NSString *)key delegate:(id<DragItemDelegate>)delegate;
- (id)initWithItemType:(kDragItem)itemType delegate:(id<DragItemDelegate>)delegate;
- (CGFloat)buttonWidth;

@end
