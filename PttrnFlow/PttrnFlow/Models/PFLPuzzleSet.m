//
//  PFLPuzzleSet.m
//  PttrnFlow
//
//  Created by John Saba on 3/16/14.
//
//

#import "PFLJsonUtils.h"
#import "PFLKeyframe.h"
#import "PFLPuzzle.h"
#import "PFLPuzzleSet.h"

static NSString *const kBpm = @"bpm";
static NSString *const kFile = @"file";
static NSString *const kKeyframes = @"keyframes";
static NSString *const kLength = @"length";
static NSString *const kName = @"name";
static NSString *const kPuzzles = @"puzzles";
static NSString *const kTheme = @"theme";

@interface PFLPuzzleSet ()

@property (strong, nonatomic) NSArray *combinedSolutionEvents;

@end

@implementation PFLPuzzleSet

+ (PFLPuzzleSet *)puzzleSetFromResource:(NSString *)resource;
{
    return [[PFLPuzzleSet alloc] initWithJson:[PFLJsonUtils deserializeJsonObjectResource:resource]];
}

- (id)initWithJson:(NSDictionary *)json
{
    self = [super init];
    if (self) {
        self.beatDuration = (1.0f / ([json[kBpm] floatValue] / 60.0f));
        self.bpm = [json[kBpm] integerValue];
        self.length = [json[kLength] integerValue];
        self.name = json[kName];
        self.theme = json[kTheme];
        
        NSArray *puzzleMetaData = json[kPuzzles];
        NSMutableArray *puzzles = [NSMutableArray array];
        NSMutableArray *keyframeSets = [NSMutableArray array];
        
        for (NSDictionary *meta in puzzleMetaData) {
            PFLPuzzle *puzzle = [PFLPuzzle puzzleFromResource:meta[kFile] puzzleSet:self];
            [puzzles addObject:puzzle];
            
            NSArray *keyframes = [PFLKeyframe keyframesFromArray:meta[kKeyframes]];
            [keyframeSets addObject:keyframes];
        }
        self.puzzles = [NSArray arrayWithArray:puzzles];
        self.keyframeSets = [NSArray arrayWithArray:keyframeSets];
    }
    return self;
}

- (NSArray *)combinedSolutionEvents
{
    if (!_combinedSolutionEvents) {
        NSMutableArray *combinedSolutionEvents = [NSMutableArray array];
        for (NSInteger i = 0; i < self.length; i++) {
            [combinedSolutionEvents addObject:[NSArray array]];
        }
        NSInteger i = 0;
        for (PFLPuzzle *puzzle in self.puzzles) {
            NSArray *keyframes = self.keyframeSets[i];
            for (PFLKeyframe *keyframe in keyframes) {
                NSInteger s = keyframe.sourceIndex;
                for (NSInteger r = 0; r < keyframe.range; r++) {
                    NSArray *events = [puzzle solutionEvents][s];
                    NSInteger t = keyframe.targetIndex + r;
                    combinedSolutionEvents[t] = [combinedSolutionEvents[t] arrayByAddingObjectsFromArray:events];
                    s++;
                }
            }
            i++;
        }
        _combinedSolutionEvents = [NSArray arrayWithArray:combinedSolutionEvents];
    }
    return _combinedSolutionEvents;
}

@end
