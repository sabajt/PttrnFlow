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

@property (weak, nonatomic) CCSprite *sprite;
@property (copy, nonatomic) NSString *defaultImageName;
@property (copy, nonatomic) NSString *selectedImageName;

@end


@implementation DragButton

+ (DragButton *)buttonWithDefaultImage:(NSString *)defaultName selectedImage:(NSString *)selectedName dragItem:(CCSprite *)item
{
    return [[DragButton alloc] initWithDefaultImage:defaultName selectedImage:selectedName dragItem:item];
}

- (id)initWithDefaultImage:(NSString *)defaultName selectedImage:(NSString *)selectedName dragItem:(CCSprite *)item
{
    self = [super init];
    if (self) {
        self.defaultImageName = defaultName;
        self.selectedImageName = selectedName;
        
        CCSprite *sprite = [SpriteUtils spriteWithTextureKey:defaultName];
        self.sprite = sprite;        
        self.contentSize = sprite.contentSize;
        self.sprite.position = ccp(sprite.contentSize.width/2, sprite.contentSize.height/2);
        [self addChild:sprite];
    }
    return self;
}

# pragma mark - CCTargetedTouchDelegate

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ([super ccTouchBegan:touch withEvent:event]) {
        [SpriteUtils switchImageForSprite:self.sprite textureKey:self.selectedImageName];
        return YES;
    }
    return NO;
};

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    [SpriteUtils switchImageForSprite:self.sprite textureKey:self.defaultImageName];
}


@end
