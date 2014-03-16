//
//  PFLPuzzle.m
//  PttrnFlow
//
//  Created by John Saba on 3/15/14.
//
//

#import "PFLPuzzle.h"
#import "PFLJsonUtils.h"

NSString *const kPFLPuzzleArrow = @"arrow";
NSString *const kPFLPuzzleAudio = @"audio";
NSString *const kPFLPuzzleCell = @"cell";
NSString *const kPFLPuzzleEntry = @"entry";
NSString *const kPFLPuzzleFile = @"file";
NSString *const kPFLPuzzleImage = @"image";
NSString *const kPFLPuzzleMidi = @"midi";
NSString *const kPFLPuzzleStatic = @"static";
NSString *const kPFLPuzzleSamples = @"samples";
NSString *const kPFLPuzzleSynth = @"synth";
NSString *const kPFLPuzzleTime = @"time";

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
