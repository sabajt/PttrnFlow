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

+ (id)blockFaderWithSize:(CGSize)size color:(ccColor3B)color cell:(GridCoord)cell
{
    NSString *key = [TextureUtils keyForPrimativeWithSize:size color:color];
    BlockFader *fader = [[BlockFader alloc] initWithSize:size color:color cell:cell textureKey:key touch:NO];
    return fader;
}

@end
