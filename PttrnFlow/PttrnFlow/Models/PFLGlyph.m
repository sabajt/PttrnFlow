//
//  PFLGlyph.m
//  PttrnFlow
//
//  Created by John Saba on 3/16/14.
//
//

#import "PFLGlyph.h"
#import "PFLCoord.h"

static NSString *const kAudio = @"audio";
static NSString *const kArrow = @"arrow";
static NSString *const kCell = @"cell";
static NSString *const kEntry = @"entry";
static NSString *const kStatic = @"static";

@implementation PFLGlyph

- (id)initWithObject:(NSDictionary *)object puzzle:(PFLPuzzle *)puzzle
{
    self = [super init];
    if (self) {
        self.audioID = object[kAudio];
        self.arrow = object[kArrow];
        NSArray *cell = object[kCell];
        self.cell = [PFLCoord coordWithX:[cell[0] integerValue] Y:[cell[1] integerValue]];
        self.entry = object[kEntry];
        self.isStatic = [object[kStatic] boolValue];
        self.puzzle = puzzle;
    }
    return self;
}

@end
