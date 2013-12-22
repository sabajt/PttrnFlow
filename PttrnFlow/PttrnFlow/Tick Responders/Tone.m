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
#import "CCNode+Grid.h"

static CGFloat const kPadding = 4;

@interface Tone ()

// fragments
@property (copy, nonatomic) NSString *synth;
@property (copy, nonatomic) NSString *midi;

@end

@implementation Tone

- (id)initWithCell:(GridCoord)cell synth:(NSString *)synth midi:(NSString *)midi frameName:(NSString *)frameName
{
    self = [super initWithSpriteFrameName:frameName];
    if (self) {
        // CCNode+Grid
        self.cell = cell;
        self.cellSize = CGSizeMake(kSizeGridUnit, kSizeGridUnit);
    
        _synth = synth;
        _midi = midi;
    }
    return self;
}

#pragma mark - AudioResponder

- (GridCoord)responderCell
{
    return self.cell;
}

- (NSArray *)audioHit:(NSInteger)bpm
{
    return @[self.midi, self.synth];
}

@end

