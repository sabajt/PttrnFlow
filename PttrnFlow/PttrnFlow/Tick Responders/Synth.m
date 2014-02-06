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
#import "SynthEvent.h"

@interface Synth ()

@property (assign) ccColor3B defaultColor;
@property (assign) ccColor3B activeColor;
@property (strong, nonatomic) SynthEvent *event;

@end

@implementation Synth

- (id)initWithCell:(Coord *)cell synth:(NSString *)synth midi:(NSString *)midi frameName:(NSString *)frameName
{
    self = [super initWithSpriteFrameName:frameName];
    if (self) {
        self.defaultColor = [ColorUtils cream];
        self.activeColor = [ColorUtils activeYellow];
        self.color = self.defaultColor;
        
        self.event = [[SynthEvent alloc] initWithChannel:0 lastLinkedEvent:nil midiValue:midi synthType:synth];
        
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

- (TickEvent *)audioHit:(NSInteger)bpm
{
    self.color = self.activeColor;
    CCTintTo *tint = [CCTintTo actionWithDuration:1 red:self.defaultColor.r green:self.defaultColor.g blue:self.defaultColor.b];
    [self runAction:tint];
    
    return self.event;
}

@end

