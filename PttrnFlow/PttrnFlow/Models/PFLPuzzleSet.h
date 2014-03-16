//
//  PFLPuzzleSet.h
//  PttrnFlow
//
//  Created by John Saba on 3/16/14.
//
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const kPFLPuzzleSetName;
FOUNDATION_EXPORT NSString *const kPFLPuzzleSetBpm;
FOUNDATION_EXPORT NSString *const kPFLPuzzleSetLength;
FOUNDATION_EXPORT NSString *const kPFLPuzzleSetPuzzles;
FOUNDATION_EXPORT NSString *const kPFLPuzzleSetFile;
FOUNDATION_EXPORT NSString *const kPFLPuzzleSetKeyframes;

@interface PFLPuzzleSet : NSObject

@property (assign) NSInteger bpm;
@property (assign) NSInteger length;
@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *puzzles;
@property (strong, nonatomic) NSArray *keyframeSets;

+ (PFLPuzzleSet *)puzzleSetFromResource:(NSString *)resource;
- (id)initWithJson:(NSDictionary *)json;

@end
