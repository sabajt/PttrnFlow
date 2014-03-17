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

@implementation PFLPuzzleSet

+ (PFLPuzzleSet *)puzzleSetFromResource:(NSString *)resource;
{
    return [[PFLPuzzleSet alloc] initWithJson:[PFLJsonUtils deserializeJsonObjectResource:resource]];
}

- (id)initWithJson:(NSDictionary *)json
{
    self = [super init];
    if (self) {
        self.bpm = [json[kBpm] integerValue];
        self.length = [json[kLength] integerValue];
        self.name = json[kName];
        
        NSArray *puzzleMetaData = json[kPuzzles];
        NSMutableArray *puzzles = [NSMutableArray array];
        NSMutableArray *keyframeSets = [NSMutableArray array];
        
        for (NSDictionary *meta in puzzleMetaData) {
            PFLPuzzle *puzzle = [PFLPuzzle puzzleFromResource:meta[kFile]];
            [puzzles addObject:puzzle];
            
            NSArray *keyframes = [PFLKeyframe keyframesFromArray:meta[kKeyframes]];
            [keyframeSets addObject:keyframes];
        }
        self.puzzles = [NSArray arrayWithArray:puzzles];
        self.keyframeSets = [NSArray arrayWithArray:keyframeSets];
    }
    return self;
}

@end
