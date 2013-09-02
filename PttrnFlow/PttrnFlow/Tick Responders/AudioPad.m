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

- (id)initWithCell:(GridCoord)cell
{
    self = [super init];
    if (self) {
        self.cell = cell;
        
        self.sprite = [self defaultSprite];
        self.sprite.position = CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
        [self addChild:self.sprite];
        
        self.position = [GridUtils relativePositionForGridCoord:self.cell unitSize:kSizeGridUnit];
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
    self.sprite.position = CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
    [self addChild:self.sprite];
    
    return @[@"audio_pad"];
}

- (void)afterTick:(NSInteger)bpm
{
    [self.sprite removeFromParentAndCleanup:YES];
    self.sprite = [self defaultSprite];
    self.sprite.position = CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
    [self addChild:self.sprite];
}

- (GridCoord)responderCell
{
    return self.cell;
}



@end
