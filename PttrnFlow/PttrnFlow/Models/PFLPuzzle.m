//
//  PFLPuzzle.m
//  PttrnFlow
//
//  Created by John Saba on 3/15/14.
//
//

#import "PFLGlyph.h"
#import "PFLJsonUtils.h"
#import "PFLMultiSample.h"
#import "PFLPuzzle.h"
#import "PFLSample.h"

static NSString *const kArea = @"area";
static NSString *const kAudio = @"audio";
static NSString *const kGlyphs = @"glyphs";
static NSString *const kMidi = @"midi";
static NSString *const kName = @"name";
static NSString *const kSolution = @"solution";
static NSString *const kSamples = @"samples";
static NSString *const kSynth = @"synth";

@implementation PFLPuzzle

+ (PFLPuzzle *)puzzleFromResource:(NSString *)resource
{
    return [[PFLPuzzle alloc] initWithJson:[PFLJsonUtils deserializeJsonObjectResource:resource]];
}

- (id)initWithJson:(NSDictionary *)json
{
    self = [super init];
    if (self) {
        self.area = json[kArea];
        self.name = json[kName];
        self.solution = json[kSolution];
        
        NSMutableArray *audio = [NSMutableArray array];
        for (NSDictionary *a in json[kAudio]) {
            NSArray *s = a[kSamples];
            if (s) {
                NSArray *samples = [PFLSample samplesFromArray:s];
                PFLMultiSample *multiSample = [[PFLMultiSample alloc] initWithSamples:samples];
                [audio addObject:multiSample];
            }
        }
        self.audio = [NSArray arrayWithArray:audio];
        
        NSMutableArray *glyphs = [NSMutableArray array];
        for (NSDictionary *g in json[kGlyphs]) {
            PFLGlyph *glyph = [[PFLGlyph alloc] initWithObject:g];
            [glyphs addObject:glyph];
        }
        self.glyphs = [NSArray arrayWithArray:glyphs];
    }
    return self;
}

@end
