//
//  DragButton.m
//  PttrnFlow
//
//  Created by John Saba on 7/1/13.
//
//

#import "DragButton.h"
#import "TextureUtils.h"
#import "SpriteUtils.h"

@interface DragButton ()

@property (assign) kDragItem itemType;
@property (weak, nonatomic) CCSprite *defaultSprite;
@property (weak, nonatomic) CCSprite *selectedSprite;
@property (weak, nonatomic) CCSprite *dragSprite;

@end


@implementation DragButton

- (id)initWithItemType:(kDragItem)itemType delegate:(id<DragItemDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.touchNodeDelegate = self;
        
        NSString *defaultFrameName;
        NSString *selectedFrameName;
        NSString *dragFrameName;
        
        if (itemType == kDragItemArrow) {
            defaultFrameName = kImageArrowButton_off;
            selectedFrameName = kImageArrowButton_on;
            dragFrameName = kImageArrowUp;
        }
        else if (itemType == kDragItemWarp) {
            defaultFrameName = kImageWarpButton_off;
            selectedFrameName = kImageWarpButton_on;
            dragFrameName = kImageWarpDefault;
        }
        else if (itemType == kDragItemAudioStop) {
            defaultFrameName = kImageItemButtonAudioStopOff;
            selectedFrameName = kImageItemButtonAudioStopOn;
            dragFrameName = kImageAudioStop;
        }
        else if (itemType == kDragItemSpeedChange) {
            defaultFrameName = kImageItemButtonSpeedDoubleOff;
            selectedFrameName = kImageItemButtonSpeedDoubleOn;
            dragFrameName = kImageSpeedDouble;
        }
        else {
            NSLog(@"warning: unsupported kDragItem type, enum %i", itemType);
        }

        CCSprite *defaultSprite = [CCSprite spriteWithSpriteFrameName:defaultFrameName];
        self.defaultSprite = defaultSprite;
        [self addChild:defaultSprite];

        CCSprite *selectedSprite = [CCSprite spriteWithSpriteFrameName:selectedFrameName];
        self.selectedSprite = selectedSprite;
        [self addChild:selectedSprite];

        CCSprite *dragSprite = [CCSprite spriteWithSpriteFrameName:dragFrameName];
        self.dragSprite = dragSprite;
        [self addChild:dragSprite];

        self.contentSize = defaultSprite.contentSize;

        defaultSprite.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
        selectedSprite.position = defaultSprite.position;
        selectedSprite.visible = NO;
        dragSprite.visible = NO;
        
        self.swallowsTouches = YES;
        self.dragItemDelegate = delegate;
        self.itemType = itemType;
    }
    return self;
}

- (CGFloat)buttonWidth
{
    return self.defaultSprite.contentSize.width;
}

#pragma mark - TouchNodeDelegate

- (BOOL)containsTouch:(UITouch *)touch
{
    CGPoint touchPosition = [self convertTouchToNodeSpace:touch];
    return (CGRectContainsPoint(self.defaultSprite.boundingBox, touchPosition));
}

#pragma mark - CCTargetedTouchDelegate

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ([super ccTouchBegan:touch withEvent:event]) {
        
        self.defaultSprite.visible = NO;
        self.selectedSprite.visible = YES;
        
        CGPoint touchPosition = [self convertTouchToNodeSpace:touch];
        self.dragSprite.position = touchPosition;
        self.dragSprite.visible = YES;
        
        if ([self.dragItemDelegate respondsToSelector:@selector(dragItemScaleFactor)]) {
            self.dragSprite.scale = [self.dragItemDelegate dragItemScaleFactor];
        }
        
        return YES;
    }
    return NO;
};

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super ccTouchMoved:touch withEvent:event];
    
    CGPoint touchPosition = [self convertTouchToNodeSpace:touch];
    self.dragSprite.position = touchPosition;
    [self.dragItemDelegate dragItemMoved:self.itemType touch:touch sender:self];
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super ccTouchEnded:touch withEvent:event];
    
    self.defaultSprite.visible = YES;
    self.selectedSprite.visible = NO;
    
    self.dragSprite.visible = NO;
    [self.dragItemDelegate dragItemDropped:self.itemType touch:touch sender:self];
}

@end
