//
//  PathUtils.h
//  SequencerGame
//
//  Created by John Saba on 4/17/13.
//
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const kCell;
FOUNDATION_EXPORT NSString *const kSynth;
FOUNDATION_EXPORT NSString *const kMidi;
FOUNDATION_EXPORT NSString *const kArrow;
FOUNDATION_EXPORT NSString *const kEntry;
FOUNDATION_EXPORT NSString *const kSample;

@interface PathUtils : NSObject

//+ (NSArray *)tileMapNames;

+ (NSArray *)puzzleFileNames;
+ (NSDictionary *)puzzle:(NSInteger)number;
+ (NSInteger)puzzleBpm:(NSInteger)number;
+ (NSDictionary *)puzzleInventory:(NSInteger)number;
+ (NSArray *)puzzleAudioPads:(NSInteger)number;

@end
