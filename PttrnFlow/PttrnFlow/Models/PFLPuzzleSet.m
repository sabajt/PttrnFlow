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

NSString *const kPFLPuzzleSetBpm = @"bpm";
NSString *const kPFLPuzzleSetFile = @"file";
NSString *const kPFLPuzzleSetKeyframes = @"keyframes";
NSString *const kPFLPuzzleSetLength = @"length";
NSString *const kPFLPuzzleSetName = @"name";
NSString *const kPFLPuzzleSetPuzzles = @"puzzles";

@implementation PFLPuzzleSet

+ (PFLPuzzleSet *)puzzleSetFromResource:(NSString *)resource;
{
    return [[PFLPuzzleSet alloc] initWithJson:[PFLJsonUtils deserializeJsonObjectResource:resource]];
}

- (id)initWithJson:(NSDictionary *)json
{
    self = [super init];
    if (self) {
        self.bpm = [json[kPFLPuzzleSetBpm] integerValue];
        self.length = [json[kPFLPuzzleSetLength] integerValue];
        self.name = json[kPFLPuzzleSetName];
        
        NSArray *puzzleMetaData = json[kPFLPuzzleSetPuzzles];
        NSMutableArray *puzzles = [NSMutableArray array];
        NSMutableArray *keyframeSets = [NSMutableArray array];
        
        for (NSDictionary *meta in puzzleMetaData) {
            PFLPuzzle *puzzle = [PFLPuzzle puzzleFromResource:meta[kPFLPuzzleSetFile]];
            [puzzles addObject:puzzle];
            
            NSArray *keyframes = [PFLKeyframe keyframesFromArray:meta[kPFLPuzzleSetKeyframes]];
            [keyframeSets addObject:keyframes];
        }
        self.puzzles = [NSArray arrayWithArray:puzzles];
        self.keyframeSets = [NSArray arrayWithArray:keyframeSets];
    }
    return self;
}

@end
