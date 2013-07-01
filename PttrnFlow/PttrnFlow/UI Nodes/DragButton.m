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

+ (DragButton *)buttonWithItemType:(kDragItem)itemType defaultSprite:(CCSprite *)defaultSprite selectedSprite:(CCSprite *)selectedSprite dragItemSprite:(CCSprite *)itemSprite delegate:(id<DragButtonDelegate>)delegate
{
    return [[DragButton alloc] initWithItemType:itemType DefaultSprite:defaultSprite selectedSprite:selectedSprite dragItemSprite:itemSprite delegate:delegate];
}

- (id)initWithItemType:(kDragItem)itemType DefaultSprite:(CCSprite *)defaultSprite selectedSprite:(CCSprite *)selectedSprite dragItemSprite:(CCSprite *)dragSprite delegate:(id<DragButtonDelegate>)delegate
{
    self = [super init];
    if (self) {
        defaultSprite.position = ccp(defaultSprite.contentSize.width/2, defaultSprite.contentSize.height/2);
        selectedSprite.position = defaultSprite.position;
        selectedSprite.visible = NO;
        dragSprite.visible = NO;
        
        self.swallowsTouches = YES;
        self.delegate = delegate;
        self.itemType = itemType;
        self.defaultSprite = defaultSprite;
        self.selectedSprite = selectedSprite;
        self.contentSize = defaultSprite.contentSize;
        self.dragSprite = dragSprite;
        
        [self addChild:defaultSprite];
        [self addChild:selectedSprite];
        [self addChild:dragSprite];
    }
    return self;
}

# pragma mark - CCTargetedTouchDelegate

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ([super ccTouchBegan:touch withEvent:event]) {
        self.defaultSprite.visible = NO;
        self.selectedSprite.visible = YES;
        
        CGPoint touchPosition = [self convertTouchToNodeSpace:touch];
        self.dragSprite.position = touchPosition;
        self.dragSprite.visible = YES;
        
        return YES;
    }
    return NO;
};

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPosition = [self convertTouchToNodeSpace:touch];
    self.dragSprite.position = touchPosition;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    self.defaultSprite.visible = YES;
    self.selectedSprite.visible = NO;
    
    self.dragSprite.visible = NO;
    [self.delegate dragItemDropped:self.itemType touch:touch];
}


@end
