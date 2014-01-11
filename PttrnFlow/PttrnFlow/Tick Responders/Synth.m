//
//  Synth.m
//  PttrnFlow
//
//  Created by John Saba on 11/20/13.
//
//

#import "Synth.h"
#import "GameConstants.h"
#import "TickEvent.h"
#import "CCNode+Grid.h"

@interface Synth ()

// fragments
@property (copy, nonatomic) NSString *synth;
@property (copy, nonatomic) NSString *midi;

@end

@implementation Synth

- (id)initWithCell:(Coord *)cell synth:(NSString *)synth midi:(NSString *)midi frameName:(NSString *)frameName
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

- (Coord *)audioCell
{
    return self.cell;
}

- (NSArray *)audioHit:(NSInteger)bpm
{
    return @[self.midi, self.synth];
}

@end

