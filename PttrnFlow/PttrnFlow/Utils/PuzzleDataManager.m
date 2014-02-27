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

static NSString *const kPuzzle = @"puzzle";
static NSString *const kBpm = @"bpm";
static NSString *const kArea = @"area";
static NSString *const kGlyphs = @"glyphs";
static NSString *const kSolution = @"solution";

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
        if (error != nil) {
            CCLOG(@"error creating puzzle from json: %@", error);
        }
        self.puzzles[@(number)] = puzzle;
    }
    return self.puzzles[@(number)];
}

- (NSInteger)puzzleBpm:(NSInteger)number
{
    NSDictionary *puzzle = [self puzzle:number];
    return [puzzle[kBpm] integerValue];
}

- (NSArray *)puzzleArea:(NSInteger)number
{
    NSDictionary *puzzle = [self puzzle:number];
    NSMutableArray *area = [NSMutableArray array];
    for (NSArray *coordArray in puzzle[kArea]) {
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
