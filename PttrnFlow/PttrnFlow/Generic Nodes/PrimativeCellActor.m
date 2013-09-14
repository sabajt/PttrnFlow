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

- (id)initWithRectSize:(CGSize)size color:(ccColor3B)color cell:(GridCoord)cell
{
    return [self initWithRectSize:size edgeLength:0 color:color cell:cell];
}

- (id)initWithRectSize:(CGSize)size edgeLength:(CGFloat)edge color:(ccColor3B)color cell:(GridCoord)cell
{
    self = [super initWithCell:cell];
    if (self) {
        self.position = [GridUtils relativePositionForGridCoord:cell unitSize:kSizeGridUnit];
        
        if (edge == 0) {
            self.sprite = [CCSprite rectSpriteWithSize:size color:color];
        }
        else {
            self.sprite = [CCSprite rectSpriteWithSize:size edgeLength:edge edgeColor:color];
        }
        self.sprite.position = ccp(self.sprite.boundingBox.size.width/2, self.sprite.boundingBox.size.height/2);
        [self addChild:self.sprite];
    }
    return self;
}

@end
