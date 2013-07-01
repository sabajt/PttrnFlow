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

- (id)initWithRectSize:(CGSize)size color:(ccColor3B)color cell:(GridCoord)cell touch:(BOOL)usesTouch
{
    return [self initWithRectSize:size edgeLength:0 color:color cell:cell touch:usesTouch];
}

- (id)initWithRectSize:(CGSize)size edgeLength:(CGFloat)edge color:(ccColor3B)color cell:(GridCoord)cell touch:(BOOL)usesTouch
{
    self = [super init];
    if (self) {
        self.cell = cell;
        self.position = [GridUtils relativePositionForGridCoord:self.cell unitSize:kSizeGridUnit];
        if (edge == 0) {
            self.sprite = [CCSprite rectSpriteWithSize:size color:color];
        }
        else {
            self.sprite = [CCSprite rectSpriteWithSize:size edgeLength:edge color:color];
        }
        self.sprite.position = self.contentCenter;
        [self addChild:self.sprite];
    }
    return self;
}

- (void)positionAtCell:(GridCoord)cell
{
    self.cell = cell;
    self.position = [GridUtils relativePositionForGridCoord:self.cell unitSize:kSizeGridUnit];
}

@end
