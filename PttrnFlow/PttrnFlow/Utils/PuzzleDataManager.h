//
//  PuzzleDataManager.h
//  SequencerGame
//
//  Created by John Saba on 4/17/13.
//
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const kPuzzleDataManagerSourceIndex;
FOUNDATION_EXPORT NSString *const kPuzzleDataManagerTargetIndex;
FOUNDATION_EXPORT NSString *const kPuzzleDataManagerRange;
FOUNDATION_EXPORT NSString *const kPuzzleDataManagerStart;
FOUNDATION_EXPORT NSString *const kPuzzleDataManagerLength;

@interface PuzzleDataManager : NSObject

@property (strong, nonatomic) NSArray *puzzleConfig;

+ (PuzzleDataManager *)sharedManager;
+ (NSArray *)puzzleFileNames;

#pragma mark - main puzzle data

- (NSArray *)puzzleArea:(NSInteger)number;
- (NSDictionary *)puzzle:(NSInteger)number audioID:(NSInteger)audioID;
- (NSArray *)puzzleGlyphs:(NSInteger)number;
- (NSArray *)puzzleSolution:(NSInteger)number;

#pragma mark - puzzle config

- (NSDictionary *)puzzleSet:(NSInteger)number;
- (NSNumber *)puzzleBpm:(NSInteger)number;
- (CGFloat)puzzleBeatDuration:(NSInteger)number;
- (NSArray *)puzzleKeyframes:(NSInteger)puzzle;

- (NSInteger)puzzleSetStart:(NSInteger)puzzleSet;
- (NSInteger)puzzleSetLength:(NSInteger)puzzleSet;

@end
