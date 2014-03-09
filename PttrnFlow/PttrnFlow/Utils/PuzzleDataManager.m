//
//  PuzzleDataManager.m
//  SequencerGame
//
//  Created by John Saba on 4/17/13.
//
//

#import "PuzzleDataManager.h"
#import "Coord.h"

NSString *const kCell = @"cell";
NSString *const kStatic = @"static";
NSString *const kArrow = @"arrow";
NSString *const kEntry = @"entry";
NSString *const kAudio = @"audio";

NSString *const kTone = @"tone";
NSString *const kDrums = @"drums";

NSString *const kSynth = @"synth";
NSString *const kMidi = @"midi";
NSString *const kFile = @"file";
NSString *const kImage = @"image";
NSString *const kDecorator = @"decorator";
NSString *const kTime = @"time";

NSString *const kImageSet = @"image_set";

NSString *const kTonePrimary = @"tone_primary";
NSString *const kToneSecondary = @"tone_secondary";
NSString *const kDrumPrimary = @"drum_primary";
NSString *const kDrumSecondary = @"drum_secondary";

static NSString *const kPuzzles = @"puzzles";
static NSString *const kPuzzle = @"puzzle";
static NSString *const kSets = @"sets";
static NSString *const kBpm = @"bpm";
static NSString *const kArea = @"area";
static NSString *const kGlyphs = @"glyphs";
static NSString *const kSolution = @"solution";

static NSString *const kID = @"id";

@interface PuzzleDataManager ()

@property (strong, nonatomic) NSMutableDictionary *puzzles;

@end

@implementation PuzzleDataManager

+ (PuzzleDataManager *)sharedManager
{
    static PuzzleDataManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[PuzzleDataManager alloc] init];
        sharedManager.puzzles = [NSMutableDictionary dictionary];
    });
    return sharedManager;
}

+ (NSArray *)puzzleFileNames
{
    NSError *error = nil;
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[[NSBundle mainBundle] resourcePath] error:&error];
    if (error) {
        CCLOG(@"error: %@", error);
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH 'puzzle' AND pathExtension ENDSWITH 'json'"];
    return [contents filteredArrayUsingPredicate:predicate];
}

- (NSDictionary *)puzzle:(NSInteger)number
{
    if (self.puzzles[@(number)] == nil) {
        NSString *resource = [NSString stringWithFormat:@"%@%i", kPuzzle, number];
        NSString *path = [[NSBundle mainBundle] pathForResource:resource ofType:@".json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSError *error = nil;
        NSDictionary *puzzle = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSAssert(error == nil, @"Failed to deserialize %@.json with error: %@", resource, error.description);
        self.puzzles[@(number)] = puzzle;
    }
    return self.puzzles[@(number)];
}

- (NSArray *)puzzleConfig
{
    if (!_puzzleConfig) {
        NSString *resource = @"puzzleConfig";
        NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:resource ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSError *error;
        _puzzleConfig = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSAssert(error == nil, @"Failed to deserialize %@.json with error: %@", resource, error.description);
    }
    return _puzzleConfig;
}

// returns the set of puzzles at specified index
- (NSDictionary *)puzzleSet:(NSInteger)number
{
    return self.puzzleConfig[number];
}

// returns the set of puzzles that specified puzzle is part of
- (NSDictionary *)puzzleSetForPuzzle:(NSInteger)number
{
    for (NSDictionary *s in self.puzzleConfig) {
        for (NSDictionary *p in s[kPuzzles]) {
            if ([p[kID] isEqualToNumber:[NSNumber numberWithInteger:number]]) {
                return s;
            }
        }
    }
    CCLOG(@"Set not found for puzzle '%i' in puzzle config file", number);
    return nil;
}

- (NSNumber *)puzzleBpm:(NSInteger)number
{
    return [self puzzleSetForPuzzle:number][kBpm];
}

// length of 1 beat, in seconds { e.g. 120 bpm = 1 second / ( 120 bpm / 60 fps ) = 0.5 seconds }
- (CGFloat)puzzleBeatDuration:(NSInteger)number
{
    return 1.0f / ([[self puzzleBpm:number] floatValue] / 60.0f);
}

- (NSArray *)puzzleArea:(NSInteger)number
{
    NSMutableArray *area = [NSMutableArray array];
    for (NSArray *coordArray in [self puzzle:number][kArea]) {
        Coord *coord = [Coord coordWithX:[coordArray[0] integerValue] Y:[coordArray[1] integerValue]];
        [area addObject:coord];
    }
    return [NSArray arrayWithArray:area];
}

- (NSArray *)puzzleAudio:(NSInteger)number
{
    NSDictionary *puzzle = [self puzzle:number];
    return puzzle[kAudio];
}

- (NSDictionary *)puzzle:(NSInteger)number audioID:(NSInteger)audioID
{
    return [self puzzleAudio:number][audioID];
}

- (NSArray *)puzzleGlyphs:(NSInteger)number
{
    NSDictionary *puzzle = [self puzzle:number];
    return puzzle[kGlyphs];
}

- (NSArray *)puzzleSolution:(NSInteger)number
{
    NSDictionary *puzzle = [self puzzle:number];
    return puzzle[kSolution];
}

@end
