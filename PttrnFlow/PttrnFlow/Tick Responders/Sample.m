//
//  Drum.m
//  PttrnFlow
//
//  Created by John Saba on 6/22/13.
//
//

#import "Sample.h"
#import "CCNode+Grid.h"
#import "ColorUtils.h"
#import "SampleEvent.h"
#import "PuzzleDataManager.h"

@interface Sample ()

@property (assign) ccColor3B defaultColor;
@property (assign) ccColor3B activeColor;
@property (strong, nonatomic) SampleEvent *event;

@end

@implementation Sample

- (id)initWithCell:(Coord *)cell toneData:(NSDictionary *)toneData
{
    self = [super initWithSpriteFrameName:toneData[kImage]];
    if (self) {
        self.defaultColor = [ColorUtils cream];
        self.activeColor = [ColorUtils activeYellow];
        self.color = self.defaultColor;
        
        NSString *sample = [NSString stringWithFormat:@"%@-%@.wav", toneData[kInstrument], toneData[kMidi]];
        self.event = [[SampleEvent alloc] initWithSampleName:sample];
        
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
