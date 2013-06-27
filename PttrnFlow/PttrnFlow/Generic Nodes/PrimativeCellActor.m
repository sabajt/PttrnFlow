//
//  PrimativeCellActor.m
//  PttrnFlow
//
//  Created by John Saba on 6/27/13.
//
//

#import "PrimativeCellActor.h"
#import "CCSprite+Utils.h"
#import "CCNode+Content.h"

@implementation PrimativeCellActor

- (id)initWithSize:(CGSize)size color:(ccColor3B)color cell:(GridCoord)cell textureKey:(NSString *)key touch:(BOOL)usesTouch
{
    self = [super init];
    if (self) {
        self.cell = cell;
        self.position = [GridUtils relativePositionForGridCoord:self.cell unitSize:kSizeGridUnit];
        self.sprite = [CCSprite spriteWithSize:size color:color key:key];
        self.sprite.position = self.contentCenter;
        [self addChild:self.sprite];
    }
    return self;
}

@end
