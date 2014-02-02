//
//  Synth.m
//  PttrnFlow
//
//  Created by John Saba on 11/20/13.
//
//

#import "Synth.h"
#import "CCNode+Grid.h"
#import "ColorUtils.h"

@interface Synth ()

@property (assign) ccColor3B defaultColor;
@property (assign) ccColor3B activeColor;
// fragments
@property (copy, nonatomic) NSString *synth;
@property (copy, nonatomic) NSString *midi;

@end

@implementation Synth

- (id)initWithCell:(Coord *)cell synth:(NSString *)synth midi:(NSString *)midi frameName:(NSString *)frameName
{
    self = [super initWithSpriteFrameName:frameName];
    if (self) {
        self.defaultColor = [ColorUtils cream];
        self.activeColor = [ColorUtils activeYellow];
        self.color = self.defaultColor;
        
        _synth = synth;
        _midi = midi;
        
        // CCNode+Grid
        self.cell = cell;
        self.cellSize = CGSizeMake(kSizeGridUnit, kSizeGridUnit);
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
    self.color = self.activeColor;
    CCTintTo *tint = [CCTintTo actionWithDuration:1 red:self.defaultColor.r green:self.defaultColor.g blue:self.defaultColor.b];
    [self runAction:tint];
    
    return @[self.midi, self.synth];
}

@end

