//
//  BlockFader.m
//  PttrnFlow
//
//  Created by John Saba on 6/27/13.
//
//

#import "BlockFader.h"
#import "TextureUtils.h"


@implementation BlockFader

+ (id)blockFaderWithSize:(CGSize)size color:(ccColor3B)color cell:(GridCoord)cell duration:(ccTime)duration
{
    BlockFader *fader = [[BlockFader alloc] initWithRectSize:size color:color cell:cell touch:NO];    
    CCCallFunc *completion = [CCCallFunc actionWithTarget:fader selector:@selector(fadeOutComplete)];
    CCSequence *seq = [CCSequence actions:[CCFadeOut actionWithDuration:duration], completion, nil];
    [fader.sprite runAction:seq];
    
    return fader;
}

- (void)fadeOutComplete
{
    [self removeFromParentAndCleanup:YES];
}

@end
