//
//  PFLPuzzle.h
//  PttrnFlow
//
//  Created by John Saba on 3/15/14.
//
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const kPFLPuzzleArrow;
FOUNDATION_EXPORT NSString *const kPFLPuzzleAudio;
FOUNDATION_EXPORT NSString *const kPFLPuzzleCell;
FOUNDATION_EXPORT NSString *const kPFLPuzzleEntry;
FOUNDATION_EXPORT NSString *const kPFLPuzzleFile;
FOUNDATION_EXPORT NSString *const kPFLPuzzleImage;
FOUNDATION_EXPORT NSString *const kPFLPuzzleMidi;
FOUNDATION_EXPORT NSString *const kPFLPuzzleStatic;
FOUNDATION_EXPORT NSString *const kPFLPuzzleSamples;
FOUNDATION_EXPORT NSString *const kPFLPuzzleSynth;
FOUNDATION_EXPORT NSString *const kPFLPuzzleTime;

@interface PFLPuzzle : NSObject

@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *area;
@property (strong, nonatomic) NSArray *audio;
@property (strong, nonatomic) NSArray *glyphs;
@property (strong, nonatomic) NSArray *solution;

+ (PFLPuzzle *)puzzleFromResource:(NSString *)resource;
- (id)initWithJson:(NSDictionary *)json;

@end
