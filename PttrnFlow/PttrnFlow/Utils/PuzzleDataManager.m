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

NSString *const kSamples = @"samples";

NSString *const kSynth = @"synth";
NSString *const kMidi = @"midi";
NSString *const kFile = @"file";
NSString *const kImage = @"image";
NSString *const kDecorator = @"decorator";
NSString *const kTime = @"time";

NSString *const kImageSet = @"image_set";

static NSString *const kPuzzles = @"puzzles";
static NSString *const kPuzzle = @"puzzle";
static NSString *const kSets = @"sets";
static NSString *const kBpm = @"bpm";
static NSString *const kArea = @"area";
static NSString *const kGlyphs = @"glyphs";
static NSString *const kSolution = @"solution";

static NSString *const kID = @"id";
static NSString *const kKeyframes = @"keyframes";

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

#pragma mark - main puzzle data

- (NSDictionary *)puzzle:(NSInteger)puzzle
{
    if (self.puzzles[@(puzzle)] == nil) {
        NSString *resource = [NSString stringWithFormat:@"%@%ld", kPuzzle, (long)puzzle];
        NSString *path = [[NSBundle mainBundle] pathForResource:resource ofType:@".json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSError *error = nil;
        NSDictionary *p = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSAssert(error == nil, @"Failed to deserialize %@.json with error: %@", resource, error.description);
        self.puzzles[@(puzzle)] = p;
    }
    return self.puzzles[@(puzzle)];
}

- (NSArray *)puzzleArea:(NSInteger)puzzle
{
    NSMutableArray *area = [NSMutableArray array];
    for (NSArray *coordArray in [self puzzle:puzzle][kArea]) {
        Coord *coord = [Coord coordWithX:[coordArray[0] integerValue] Y:[coordArray[1] integerValue]];
        [area addObject:coord];
    }
    return [NSArray arrayWithArray:area];
}

- (NSArray *)puzzleAudio:(NSInteger)puzzle
{
    NSDictionary *p = [self puzzle:puzzle];
    return p[kAudio];
}

- (NSDictionary *)puzzle:(NSInteger)puzzle audioID:(NSInteger)audioID
{
    return [self puzzleAudio:puzzle][audioID];
}

- (NSArray *)puzzleGlyphs:(NSInteger)puzzle
{
    NSDictionary *p = [self puzzle:puzzle];
    return p[kGlyphs];
}

- (NSArray *)puzzleSolution:(NSInteger)puzzle
{
    NSDictionary *p = [self puzzle:puzzle];
    return p[kSolution];
}

#pragma mark - puzzle config

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

- (NSDictionary *)puzzleMetaData:(NSInteger)puzzle
{
    for (NSDictionary *s in self.puzzleConfig) {
        for (NSDictionary *p in s[kPuzzles]) {
            if ([p[kID] isEqualToNumber:@(puzzle)]) {
                return p;
            }
        }
    }
    CCLOG(@"Set not found for puzzle '%ld' in puzzle config file", (long)puzzle);
    return nil;
}

// returns the set of puzzles at specified set index
- (NSDictionary *)puzzleSet:(NSInteger)sIndex
{
    return self.puzzleConfig[sIndex];
}

// returns the set of puzzles that specified puzzle is part of
- (NSDictionary *)puzzleSetForPuzzle:(NSInteger)puzzle
{
    for (NSDictionary *s in self.puzzleConfig) {
        for (NSDictionary *p in s[kPuzzles]) {
            if ([p[kID] isEqualToNumber:@(puzzle)]) {
                return s;
            }
        }
    }
    CCLOG(@"Set not found for puzzle '%ld' in puzzle config file", (long)puzzle);
    return nil;
}

- (NSNumber *)puzzleBpm:(NSInteger)puzzle
{
    return [self puzzleSetForPuzzle:puzzle][kBpm];
}

// length of 1 beat, in seconds { e.g. 120 bpm = 1 second / ( 120 bpm / 60 fps ) = 0.5 seconds }
- (CGFloat)puzzleBeatDuration:(NSInteger)puzzle
{
    return 1.0f / ([[self puzzleBpm:puzzle] floatValue] / 60.0f);
}

- (NSDictionary *)puzzleKeyframes:(NSInteger)puzzle
{
    return [self puzzleMetaData:puzzle][kKeyframes];
}

@end
