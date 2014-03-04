//
//  PuzzleDataManager.h
//  SequencerGame
//
//  Created by John Saba on 4/17/13.
//
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const kCell;
FOUNDATION_EXPORT NSString *const kStatic;
FOUNDATION_EXPORT NSString *const kArrow;
FOUNDATION_EXPORT NSString *const kEntry;
FOUNDATION_EXPORT NSString *const kAudio;

FOUNDATION_EXPORT NSString *const kTone;
FOUNDATION_EXPORT NSString *const kDrums;

FOUNDATION_EXPORT NSString *const kSynth;
FOUNDATION_EXPORT NSString *const kMidi;
FOUNDATION_EXPORT NSString *const kFile;
FOUNDATION_EXPORT NSString *const kImage;
FOUNDATION_EXPORT NSString *const kDecorator;
FOUNDATION_EXPORT NSString *const kTime;

@interface PuzzleDataManager : NSObject

+ (PuzzleDataManager *)sharedManager;
+ (NSArray *)puzzleFileNames;
- (NSDictionary *)puzzleConfig;
- (NSDictionary *)puzzleSet:(NSInteger)number;
- (NSNumber *)puzzleBpm:(NSInteger)number;
- (CGFloat)puzzleBeatDuration:(NSInteger)number;
- (NSArray *)puzzleArea:(NSInteger)number;
- (NSDictionary *)puzzle:(NSInteger)number audioID:(NSInteger)audioID;
- (NSArray *)puzzleGlyphs:(NSInteger)number;
- (NSArray *)puzzleSolution:(NSInteger)number;

@end
