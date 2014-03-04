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

- (id)initWithCell:(Coord *)cell
           audioID:(NSNumber *)audioID
             synth:(NSString *)synth
              midi:(NSNumber *)midi
             image:(NSString *)image
         decorator:(NSString *)decorator
{
    self = [super initWithSpriteFrameName:image];
    if (self) {
        self.defaultColor = [ColorUtils cream];
        self.activeColor = [ColorUtils activeYellow];
        self.color = self.defaultColor;
        
        self.event = [[SynthEvent alloc] initWithAudioID:audioID midiValue:[midi stringValue] synthType:synth];
        
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

- (TickEvent *)audioHit:(CGFloat)beatDuration
{
    self.color = self.activeColor;
    CCTintTo *tint = [CCTintTo actionWithDuration:beatDuration red:self.defaultColor.r green:self.defaultColor.g blue:self.defaultColor.b];
    [self runAction:tint];
    
    return self.event;
}

@end

