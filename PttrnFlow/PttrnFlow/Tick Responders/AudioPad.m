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
#import "CCSprite+Utils.h"
#import "ColorUtils.h"

@interface AudioPad ()

@property (strong, nonatomic) CCSprite *defaultSprite;
@property (strong, nonatomic) CCSprite *highlightSprite;

@end


@implementation AudioPad

// TODO: audio pad doesn't actually use batch node, but it probably should, - rendering the sprite creation is probably expensive
- (id)initWithBatchNode:(CCSpriteBatchNode *)batchNode cell:(GridCoord)cell
{
    self = [super initWithBatchNode:batchNode cell:cell];
    if (self) {
        self.sprite = [self defaultSprite];
        self.sprite.position = [self relativeMidpoint];
        [self addChild:self.sprite];
    }
    return self;
}

- (CCSprite *)defaultSprite
{
    if (_defaultSprite == nil) {
        CCSprite *spr = [CCSprite rectSpriteWithSize:CGSizeMake(kSizeGridUnit, kSizeGridUnit) edgeLength:6 edgeColor:[ColorUtils white]];
        _defaultSprite = spr;
    }
    return _defaultSprite;
}

- (CCSprite *)highlightSprite
{
    if (_highlightSprite == nil) {
        CCSprite *spr = [CCSprite rectSpriteWithSize:CGSizeMake(kSizeGridUnit, kSizeGridUnit) edgeLength:6 edgeColor:[ColorUtils orange]];
        _highlightSprite = spr;
    }
    return _highlightSprite;
}

#pragma mark - Tick Responder

- (NSArray *)tick:(NSInteger)bpm
{
    [self.sprite removeFromParentAndCleanup:YES];
    self.sprite = [self highlightSprite];
    self.sprite.position = [self relativeMidpoint];
    [self addChild:self.sprite];
    
    return @[@"audio_pad"];
}

- (void)afterTick:(NSInteger)bpm
{
    [self.sprite removeFromParentAndCleanup:YES];
    self.sprite = [self defaultSprite];
    self.sprite.position = [self relativeMidpoint];
    [self addChild:self.sprite];
}

- (GridCoord)responderCell
{
    return self.cell;
}



@end
