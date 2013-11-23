//
//  Tone.m
//  PttrnFlow
//
//  Created by John Saba on 11/20/13.
//
//

#import "Tone.h"
#import "GameConstants.h"
#import "TickEvent.h"

static CGFloat const kPadding = 4;

@interface Tone ()

@property (weak, nonatomic) CCSprite *lineOff;
@property (weak, nonatomic) CCSprite *lineOn;
@property (weak, nonatomic) CCSprite *numberOff;
@property (weak, nonatomic) CCSprite *numberOn;

// fragments
@property (copy, nonatomic) NSString *synth;
@property (copy, nonatomic) NSString *midi;

@end

@implementation Tone

- (id)initWithCell:(GridCoord)cell synth:(NSString *)synth midi:(NSString *)midi
{
    self = [super initWithSpriteFrameName:kClearRectAudioBatch cell:cell];
    if (self) {
        self.contentSize = CGSizeMake(kSizeGridUnit, kSizeGridUnit);
        _synth = synth;
        _midi = midi;
        
        CCSprite *lineOff = [CCSprite spriteWithSpriteFrameName:@"synth_line_off.png"];
        _lineOff = lineOff;
        lineOff.position = ccp(self.contentSize.width / 2, self.contentSize.height / 2);
        [self addChild:lineOff];
        
        CCSprite *lineOn = [CCSprite spriteWithSpriteFrameName:@"synth_line_on.png"];
        _lineOn = lineOn;
        lineOn.position = ccp(self.contentSize.width / 2, self.contentSize.height / 2);
        lineOn.visible = NO;
        [self addChild:lineOn];
        
        CCSprite *numberOff = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"num%i_off.png", 1]];
        _numberOff = numberOff;
        numberOff.position = ccp(lineOff.position.x + (lineOff.contentSize.width / 2) + (numberOff.contentSize.width / 2) + kPadding, self.contentSize.height / 2);
        [self addChild:numberOff];
        
        CCSprite *numberOn = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"num%i_on.png", 1]];
        _numberOn = numberOn;
        numberOn.position = ccp(lineOn.position.x + (lineOn.contentSize.width / 2) + (numberOn.contentSize.width / 2) + kPadding, self.contentSize.height/ 2);
    }
    return self;
}

#pragma mark - TickResponder

- (GridCoord)responderCell
{
    return self.cell;
}

- (NSArray *)tick:(NSInteger)bpm
{
    return @[self.midi, self.synth];
}

- (void)afterTick:(NSInteger)bpm
{
    
}

@end

