//
//  SequenceItemLayer.m
//  PttrnFlow
//
//  Created by John Saba on 6/29/13.
//
//

#import "SequenceItemLayer.h"
#import "TextureUtils.h"
#import "DragButton.h"

static CGFloat const kHandleHeight = 40;

NSString *const kSequenceItemArrow = @"arrow";
NSString *const kSequenceItemWarp = @"warp";
NSString *const kSequenceItemSplitter = @"splitter";

@implementation SequenceItemLayer

+ (id)layerWithColor:(ccColor4B)color width:(GLfloat)w items:(NSArray *)items
{
    return [[SequenceItemLayer alloc] initWithColor:color width:w height:(w * items.count) + kHandleHeight items:items];
}

- (id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h items:(NSArray *)items
{
    self = [super initWithColor:color width:w height:h];
    if (self) {
        
        int i = 0;
        for (NSString *item in items) {
            DragButton *button = [self sequenceItemButton:item];
            button.position = ccp(0, (button.contentSize.height * i) + kHandleHeight);
            [self addChild:button];
            i++;
        }
    }
    return self;
}

// creates a menu item with selector generated from itemType + ItemSelected:, example: arrowItemSelected:
- (DragButton *)sequenceItemButton:(NSString *)itemType
{
    NSString *defaultName;
    NSString *selectedName;
    if ([itemType isEqualToString:kSequenceItemArrow]) {
        defaultName = kImageArrowButton_off;
        selectedName = kImageArrowButton_on;
    }
    
    return [DragButton buttonWithDefaultImage:defaultName selectedImage:selectedName dragItem:nil];
}

#pragma mark - item selectors 

- (void)arrowItemSelected:(id)sender
{
    NSLog(@"arrow item selected needs implementation");
}

@end
