//
//  AudioPad.m
//  PttrnFlow
//
//  Created by John Saba on 8/25/13.
//
//


#import "AudioPad.h"
#import "CCTMXTiledMap+Utils.h"
#import "TextureUtils.h"

@implementation AudioPad

- (id)initWithCell:(GridCoord)cell
{
    self = [super init];
    if (self) {
        self.cell = cell;
        self.sprite = [self createAndCenterSpriteNamed:kImageAudioPad];
        [self addChild:self.sprite];
        self.position = [GridUtils relativePositionForGridCoord:self.cell unitSize:kSizeGridUnit];
    }
    return self;
}

#pragma mark - Tick Responder

- (NSArray *)tick:(NSInteger)bpm
{
    return @[@"audio_pad"];
}

- (void)afterTick:(NSInteger)bpm
{

}

- (GridCoord)responderCell
{
    return self.cell;
}



@end
