//
//  PFLPuzzleSet.m
//  PttrnFlow
//
//  Created by John Saba on 3/16/14.
//
//

#import "PFLPuzzleSet.h"
#import "PFLJsonUtils.h"

FOUNDATION_EXPORT NSString *const kPFLPuzzleSetName;
FOUNDATION_EXPORT NSString *const kPFLPuzzleSetBpm;
FOUNDATION_EXPORT NSString *const kPFLPuzzleSetLength;
FOUNDATION_EXPORT NSString *const kPFLPuzzleSetPuzzles;
FOUNDATION_EXPORT NSString *const kPFLPuzzleSetFile;
FOUNDATION_EXPORT NSString *const kPFLPuzzleSetKeyframes;
FOUNDATION_EXPORT NSString *const kPFLPuzzleSetSourceIndex;
FOUNDATION_EXPORT NSString *const kPFLPuzzleSetTargetIndex;
FOUNDATION_EXPORT NSString *const kPFLPuzzleSetRange;

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
        self.puzzles = json[kPFLPuzzleSetPuzzles];
    }
    return self;
}

@end
