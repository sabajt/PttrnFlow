//
//  Puzzle.m
//  PttrnFlow
//
//  Created by John Saba on 3/15/14.
//
//

#import "PFLPuzzle.h"
#import "PFLJsonUtils.h"

NSString *const kPuzzleArrow = @"arrow";
NSString *const kPuzzleAudio = @"audio";
NSString *const kPuzzleCell = @"cell";
NSString *const kPuzzleEntry = @"entry";
NSString *const kPuzzleFile = @"file";
NSString *const kPuzzleImage = @"image";
NSString *const kPuzzleMidi = @"midi";
NSString *const kPuzzleStatic = @"static";
NSString *const kPuzzleSamples = @"samples";
NSString *const kPuzzleSynth = @"synth";
NSString *const kPuzzleTime = @"time";

@implementation PFLPuzzle

+ (PFLPuzzle *)puzzleFromResource:(NSString *)resource
{
    return [[PFLPuzzle alloc] initWithJson:[PFLJsonUtils deserializeJsonObjectResource:resource]];
}

- (id)initWithJson:(NSDictionary *)json
{
    self = [super init];
    if (self) {
        self.name = json[@"name"];
        self.area = json[@"area"];
        self.audio = json[@"audio"];
        self.glyphs = json[@"glyphs"];
        self.solution = json[@"solution"];
    }
    return self;
}

@end
