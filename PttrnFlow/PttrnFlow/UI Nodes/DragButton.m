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


+ (DragButton *)buttonWithBatchNode:(CCSpriteBatchNode *)batchNode itemType:(kDragItem)itemType defaultSprite:(CCSprite *)defaultSprite selectedSprite:(CCSprite *)selectedSprite dragItemSprite:(CCSprite *)itemSprite delegate:(id<DragItemDelegate>)delegate
{
    return [[DragButton alloc] initWithBatchNode:batchNode itemType:itemType defaultSprite:defaultSprite selectedSprite:selectedSprite dragItemSprite:itemSprite delegate:delegate];
}

- (id)initWithBatchNode:(CCSpriteBatchNode *)batchNode itemType:(kDragItem)itemType defaultSprite:(CCSprite *)defaultSprite selectedSprite:(CCSprite *)selectedSprite dragItemSprite:(CCSprite *)dragSprite delegate:(id<DragItemDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.touchNodeDelegate = self;
        
        defaultSprite.position = ccp(defaultSprite.contentSize.width/2, defaultSprite.contentSize.height/2);
        selectedSprite.position = defaultSprite.position;
        selectedSprite.visible = NO;
        dragSprite.visible = NO;
        
        self.swallowsTouches = YES;
        self.dragItemDelegate = delegate;
        self.itemType = itemType;
        self.defaultSprite = defaultSprite;
        self.selectedSprite = selectedSprite;
        self.contentSize = defaultSprite.contentSize;
        self.dragSprite = dragSprite;
        
        [batchNode addChild:defaultSprite];
        [batchNode addChild:selectedSprite];
        [batchNode addChild:dragSprite];
    }
    return self;
}

- (void)setPosition:(CGPoint)position
{
    [super setPosition:position];
    
    self.defaultSprite.position = position_;
    self.selectedSprite.position = position_;
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
