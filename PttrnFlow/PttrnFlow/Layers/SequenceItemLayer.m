//
//  SequenceItemLayer.m
//  PttrnFlow
//
//  Created by John Saba on 6/29/13.
//
//

#import "SequenceItemLayer.h"
#import "TextureUtils.h"
#import "SpriteUtils.h"

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
        
        NSMutableArray *buttons = [NSMutableArray array];
        int i = 0;
        for (NSString *item in items) {
            CCMenuItemSprite *button = [self sequenceItemButton:item];
            button.position = ccp(button.contentSize.width/2, button.contentSize.height/2 + (button.contentSize.height * i) + kHandleHeight);
            [buttons addObject:button];
            i++;
        }
        CCMenu *menu = [CCMenu menuWithArray:buttons];
        menu.position = ccp(0, 0);
        [self addChild:menu];
    }
    return self;
}

// creates a menu item with selector generated from itemType + ItemSelected:, example: arrowItemSelected:
- (CCMenuItemSprite *)sequenceItemButton:(NSString *)itemType
{
    CCSprite *normalSprite;
    CCSprite *selectedSprite;
    if ([itemType isEqualToString:kSequenceItemArrow]) {
        normalSprite = [SpriteUtils spriteWithTextureKey:kImageArrowButton_off];
        selectedSprite = [SpriteUtils spriteWithTextureKey:kImageArrowButton_on];
    }
    
    NSString *selectorName = [NSString stringWithFormat:@"%@ItemSelected:", itemType];
    SEL selector = NSSelectorFromString(selectorName);

    return [[CCMenuItemSprite alloc] initWithNormalSprite:normalSprite selectedSprite:selectedSprite disabledSprite:nil target:self selector:selector];
}

#pragma mark - item selectors 

- (void)arrowItemSelected:(id)sender
{
    NSLog(@"arrow item selected needs implementation");
}

@end
