//
//  CellNode.m
//  FishSet
//
//  Created by John Saba on 2/3/13.
//
//

#import "CellNode.h"
#import "GameConstants.h"
#import "SpriteUtils.h"
#import "SGTiledUtils.h"
#import "CellObjectLibrary.h"
#import "CCNode+Touch.h"

@implementation CellNode

-(id) init
{
    self = [super init];
    if (self) {
        self.contentSize = CGSizeMake(kSizeGridUnit, kSizeGridUnit);
    }
    return self;
}

-(CCSprite *) createAndCenterSpriteNamed:(NSString *)name
{
    CCSprite *sprite = [SpriteUtils spriteWithTextureKey:name];
    sprite.position = CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
    return sprite;
}

- (void)alignSprite:(kDirection)direction
{
    switch (direction) {
        case kDirectionUp:
            [self topAlignSprite];
            break;
        case kDirectionRight:
            [self rightAlignSprite];
            break;
        case kDirectionDown:
            [self bottomAlignSprite];
            break;
        case kDirectionLeft:
            [self leftAlignSprite];
            break;
        default:
            NSLog(@"warning: invalid direction, can't align sprite");
            break;
    }
}

- (void)leftAlignSprite
{
    self.sprite.position = CGPointMake(self.sprite.contentSize.width/2, self.contentSize.height/2);
}

- (void)rightAlignSprite
{
    self.sprite.position = CGPointMake(self.contentSize.width - self.sprite.contentSize.width/2, self.contentSize.height/2);
}

- (void)topAlignSprite
{
    self.sprite.position = CGPointMake(self.contentSize.width/2, self.contentSize.height - self.sprite.contentSize.height/2);
}

- (void)bottomAlignSprite
{
    self.sprite.position = CGPointMake(self.contentSize.width/2, self.sprite.contentSize.height/2);
}

@end
