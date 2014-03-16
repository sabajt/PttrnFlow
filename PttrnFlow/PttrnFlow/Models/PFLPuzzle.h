//
//  Puzzle.h
//  PttrnFlow
//
//  Created by John Saba on 3/15/14.
//
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const kPuzzleArrow;
FOUNDATION_EXPORT NSString *const kPuzzleAudio;
FOUNDATION_EXPORT NSString *const kPuzzleCell;
FOUNDATION_EXPORT NSString *const kPuzzleEntry;
FOUNDATION_EXPORT NSString *const kPuzzleFile;
FOUNDATION_EXPORT NSString *const kPuzzleImage;
FOUNDATION_EXPORT NSString *const kPuzzleMidi;
FOUNDATION_EXPORT NSString *const kPuzzleStatic;
FOUNDATION_EXPORT NSString *const kPuzzleSamples;
FOUNDATION_EXPORT NSString *const kPuzzleSynth;
FOUNDATION_EXPORT NSString *const kPuzzleTime;

@interface PFLPuzzle : NSObject

@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *area;
@property (strong, nonatomic) NSArray *audio;
@property (strong, nonatomic) NSArray *glyphs;
@property (strong, nonatomic) NSArray *solution;

+ (PFLPuzzle *)puzzleFromResource:(NSString *)resource;
- (id)initWithJson:(NSDictionary *)json;

@end
