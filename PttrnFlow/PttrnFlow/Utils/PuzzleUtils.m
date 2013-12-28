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
NSString *const kDrumPrimary = @"drum_primary";
NSString *const kDrumSecondary = @"drum_secondary";

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

 image_set determines the sequence of images that will be used, (kTonePrimary, kToneSecondary, kDrumPrimary, kDrumSecondary)
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
            else if ([imageSet isEqualToString:kDrumPrimary]) {
                [beatPrimaryValues addObject:sample];
            }
            else if ([imageSet isEqualToString:kDrumSecondary]) {
                [beatSecondaryValues addObject:sample];
            }
        }
    }
    
    NSMutableDictionary *imageSequenceKey = [NSMutableDictionary dictionary];
    
    if (tonePrimaryValues.count > 0) {
        NSDictionary *mappedSet = [self mappedImageSetForAudioValues:[NSSet setWithSet:tonePrimaryValues] rootName:kTonePrimary];
        [imageSequenceKey setObject:mappedSet forKey:kTonePrimary];
    }
    if (toneSecondaryValues.count > 0) {
        NSDictionary *mappedSet = [self mappedImageSetForAudioValues:[NSSet setWithSet:toneSecondaryValues] rootName:kToneSecondary];
        [imageSequenceKey setObject:mappedSet forKey:kToneSecondary];    }
    if (beatPrimaryValues.count > 0) {
        NSDictionary *mappedSet = [self mappedImageSetForAudioValues:[NSSet setWithSet:beatPrimaryValues] rootName:kDrumPrimary];
        [imageSequenceKey setObject:mappedSet forKey:kDrumPrimary];
    }
    if (beatSecondaryValues.count > 0) {
        NSDictionary *mappedSet = [self mappedImageSetForAudioValues:[NSSet setWithSet:beatSecondaryValues] rootName:kDrumSecondary];
        [imageSequenceKey setObject:mappedSet forKey:kDrumSecondary];
    }
    
    NSLog(@"image seq: %@", imageSequenceKey);
    return [NSDictionary dictionaryWithDictionary:imageSequenceKey];
}

// create a mapping of sequence image set consisting of audio value (key) and frame name (value)
+ (NSDictionary *)mappedImageSetForAudioValues:(NSSet *)audioValues rootName:(NSString *)rootName
{
    // sort audio values if needed
    NSArray *sortedAudioValues;
    if ([rootName isEqualToString:kTonePrimary]) {
        NSSortDescriptor *ascendingNumbers = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
        sortedAudioValues = [audioValues sortedArrayUsingDescriptors:@[ascendingNumbers]];
    }
    else {
        sortedAudioValues  = [audioValues allObjects];
    }

    // create mapped image set
    NSMutableDictionary *mappedImageSet = [NSMutableDictionary dictionary];
    NSInteger i = 1;
    for (NSNumber *value in sortedAudioValues) {
        NSString *frameName;
        if ((i == sortedAudioValues.count) && ([rootName isEqualToString:kTonePrimary] || [rootName isEqualToString:kToneSecondary])) {
            frameName = [NSString stringWithFormat:@"%@_full.png", rootName];
        }
        else if ((i == 1) && ([rootName isEqualToString:kDrumPrimary] || [rootName isEqualToString:kDrumSecondary])) {
            frameName = [NSString stringWithFormat:@"%@_1.png", rootName];
        }
        else {
            frameName = [NSString stringWithFormat:@"%@_%i_%i.png", rootName, i, sortedAudioValues.count];
        }
        [mappedImageSet setObject:frameName forKey:value];
        i++;
    }

    return [NSDictionary dictionaryWithDictionary:mappedImageSet];
}

@end
