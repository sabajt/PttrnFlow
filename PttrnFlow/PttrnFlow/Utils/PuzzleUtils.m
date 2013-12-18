//
//  PathUtils.m
//  SequencerGame
//
//  Created by John Saba on 4/17/13.
//
//

#import "PuzzleUtils.h"

NSString *const kCell = @"cell";
NSString *const kSynth = @"synth";
NSString *const kMidi = @"midi";
NSString *const kArrow = @"arrow";
NSString *const kEntry = @"entry";
NSString *const kSample = @"sample";
NSString *const kStatic = @"static";
NSString *const kGlyphs = @"glyphs";
NSString *const kImageSet = @"image_set";

NSString *const kTonePrimary = @"tone_primary";
NSString *const kToneSecondary = @"tone_secondary";
NSString *const kBeatPrimary = @"beat_primary";
NSString *const kBeatSecondary = @"beat_secondary";

static NSString *const kPuzzle = @"puzzle";
static NSString *const kBpm = @"bpm";
static NSString *const kArea = @"area";
static NSString *const kPads = @"pads";

@implementation PuzzleUtils

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
    NSDictionary *puzzle = [PuzzleUtils puzzle:number];
    return [puzzle[kBpm] integerValue];
}

+ (NSArray *)puzzleArea:(NSInteger)number
{
    NSDictionary *puzzle = [PuzzleUtils puzzle:number];
    return puzzle[kArea];
}

+ (NSArray *)puzzleAudioPads:(NSInteger)number
{
    NSDictionary *puzzle = [PuzzleUtils puzzle:number];
    return puzzle[kPads];
}

/* image sequence keys take the following form:

 {
    image_set : 
    {
        audio_value : frame_name,
        ...
    },
    ...
 }

 image_set determines the sequence of images that will be used, (kTonePrimary, kToneSecondary, kBeatPrimary, kBeatSecondary)
 audio_value is the unique identifier for sequence based glyphs
 frame_name is the image frame name derived from 0 based indexing NSNumber that uniques each glyph value providing a key to a unique image

 value for synths are midi values (NSNumber)
 values for samples are unique id's (NSStrings)
 order for synths ascends from lower to higher frequencies.
 order for tonal sample collections ascends in the same way.
 order for pattern based samples is arbirary, but consistent for each puzzle
 
*/
+ (NSDictionary *)puzzleImageSequenceKey:(NSInteger)number
{
    // extract glyph audio value and add to temporary collections
    NSMutableSet *tonePrimaryValues = [NSMutableSet set];
    NSMutableSet *toneSecondaryValues = [NSMutableSet set];
    NSMutableSet *beatPrimaryValues = [NSMutableSet set];
    NSMutableSet *beatSecondaryValues = [NSMutableSet set];
    
    NSArray *audioPads = [PuzzleUtils puzzleAudioPads:number];
    for (NSDictionary *pad in audioPads) {
        NSArray *glyphs = pad[kGlyphs];
        
        for (NSDictionary *glyph in glyphs) {
            
            NSString *imageSet = glyph[kImageSet];
            NSString *synth = glyph[kSynth];
            NSNumber *midi = glyph[kMidi];
            NSString *sample = glyph[kSample];
            
            if ([imageSet isEqualToString:kTonePrimary]) {
                // tone image sequence can be used with either PD synths or tonal samples that follow naming format like: @"name_1";
                if (synth != nil && midi != nil) {
                    [tonePrimaryValues addObject:midi];
                }
                if (sample != nil) {
                    NSString *value = [[sample componentsSeparatedByString:@"_"] lastObject];
                    NSNumber *numberValue = @([value integerValue]);
                    [tonePrimaryValues addObject:numberValue];
                }
            }
            else if ([imageSet isEqualToString:kToneSecondary]) {
                // tone image sequence can be used with either PD synths or tonal samples that follow naming format like: @"name_1";
                if (synth != nil && midi != nil) {
                    [toneSecondaryValues addObject:midi];
                }
                if (sample != nil) {
                    NSString *value = [[sample componentsSeparatedByString:@"_"] lastObject];
                    NSNumber *numberValue = @([value integerValue]);
                    [toneSecondaryValues addObject:numberValue];
                }
            }
            else if ([imageSet isEqualToString:kBeatPrimary]) {
                [beatPrimaryValues addObject:sample];
            }
            else if ([imageSet isEqualToString:kBeatSecondary]) {
                [beatSecondaryValues addObject:sample];
            }
        }
    }
    
    // construct image set collections
    NSMutableDictionary *tonePrimary = [NSMutableDictionary dictionary];
    NSMutableDictionary *toneSecondary = [NSMutableDictionary dictionary];
    NSMutableDictionary *beatPrimary = [NSMutableDictionary dictionary];
    NSMutableDictionary *beatSecondary = [NSMutableDictionary dictionary];

    NSSortDescriptor *ascendingNumbers = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
    NSArray *sortedTonePrimaryValues = [tonePrimaryValues sortedArrayUsingDescriptors:@[ascendingNumbers]];
    NSArray *sortedToneSecondaryValues = [toneSecondaryValues sortedArrayUsingDescriptors:@[ascendingNumbers]];
    
    NSMutableDictionary *imageSequence = [NSMutableDictionary dictionary];
    
    // sequence image frame naming convention:
    // 'base name' + 'order' + 'total number', delineated by "_"
    // example: the 3rd primary tone in a series of 5 would be "tone_primary_3_5"
    
    if (sortedTonePrimaryValues.count > 0) {
        NSInteger i = 1;
        for (NSNumber *value in sortedTonePrimaryValues) {
            NSString *frameName = [NSString stringWithFormat:@"%@_%i_%i.png", kTonePrimary, i, sortedTonePrimaryValues.count];
            [tonePrimary setObject:frameName forKey:value];
            i++;
        }
        [imageSequence setObject:tonePrimary forKey:kTonePrimary];
    }
    if (sortedToneSecondaryValues.count > 0) {
        NSInteger i = 1;
        for (NSNumber *value in sortedToneSecondaryValues) {
            NSString *frameName = [NSString stringWithFormat:@"%@_%i_%i.png", kToneSecondary, i, sortedToneSecondaryValues.count];
            [toneSecondary setObject:frameName forKey:value];
            i++;
        }
        [imageSequence setObject:toneSecondary forKey:kToneSecondary];
    }
    if (beatPrimaryValues.count > 0) {
        NSInteger i = 1;
        for (NSNumber *value in beatPrimaryValues) {
            NSString *frameName = [NSString stringWithFormat:@"%@_%i_%i.png", kBeatPrimary, i, beatPrimaryValues.count];
            [beatPrimary setObject:frameName forKey:value];
            i++;
        }
        [imageSequence setObject:beatPrimary forKey:kBeatPrimary];
    }
    if (beatSecondaryValues.count > 0) {
        NSInteger i = 1;
        for (NSNumber *value in beatSecondaryValues) {
            NSString *frameName = [NSString stringWithFormat:@"%@_%i_%i.png", kBeatSecondary, i, beatSecondaryValues.count];
            [beatSecondary setObject:frameName forKey:value];
            i++;
        }
        [imageSequence setObject:beatSecondary forKey:kBeatSecondary];
    }
    
    NSLog(@"image seq: %@", imageSequence);
    
    return [NSDictionary dictionaryWithDictionary:imageSequence];
}

@end
