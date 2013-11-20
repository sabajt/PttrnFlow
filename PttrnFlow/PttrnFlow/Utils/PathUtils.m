//
//  PathUtils.m
//  SequencerGame
//
//  Created by John Saba on 4/17/13.
//
//

#import "PathUtils.h"

NSString *const kCell = @"cell";
NSString *const kSynth = @"synth";
NSString *const kMidi = @"midi";
NSString *const kArrow = @"arrow";
NSString *const kEntry = @"entry";
NSString *const kSample = @"sample";

static NSString *const kPuzzle = @"puzzle";
static NSString *const kBpm = @"bpm";
static NSString *const kInventory = @"inventory";
static NSString *const kAudioPads = @"audio_pads";

@implementation PathUtils

//// array of strings for all .tmx files, strings formatted without the .tmx extensions
//+ (NSArray *)tileMapNames
//{    
//    NSError *error = nil;
//    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[[NSBundle mainBundle] resourcePath] error:&error];
//    if (error) {
//        NSLog(@"error: %@", error);
//    }
//    NSMutableArray *maps = [NSMutableArray array];
//    for (id c in contents) {
//        NSString *name = (NSString *)c;
//        if ([[name substringFromIndex:name.length - kTmx.length] isEqualToString:kTmx]) {
//            [maps addObject:[name substringToIndex:name.length - kTmx.length]];
//        }
//    }    
//    return maps;
//}

+ (NSArray *)puzzleFileNames
{
    NSError *error = nil;
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[[NSBundle mainBundle] resourcePath] error:&error];
    if (error) {
        NSLog(@"error: %@", error);
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH 'puzzle' AND pathExtension ENDSWITH 'json'"];
    return [contents filteredArrayUsingPredicate:predicate];
}

+ (NSDictionary *)puzzle:(NSInteger)number
{
    NSString *resource = [NSString stringWithFormat:@"%@%i", kPuzzle, number];
    NSString *path = [[NSBundle mainBundle] pathForResource:resource ofType:@".json"];
    NSData* data = [NSData dataWithContentsOfFile:path];
    NSError *error = nil;
    NSDictionary *puzzle = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error != nil) {
        NSLog(@"error creating puzzle from json: %@", error);
    }
    return puzzle;
}

+ (NSInteger)puzzleBpm:(NSInteger)number
{
    NSDictionary *puzzle = [PathUtils puzzle:number];
    return [puzzle[kBpm] integerValue];
}

+ (NSDictionary *)puzzleInventory:(NSInteger)number
{
    NSDictionary *puzzle = [PathUtils puzzle:number];
    return puzzle[kInventory];
}

+ (NSArray *)puzzleAudioPads:(NSInteger)number
{
    NSDictionary *puzzle = [PathUtils puzzle:number];
    return puzzle[kAudioPads];
}

@end
