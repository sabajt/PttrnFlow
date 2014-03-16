//
//  PFLPuzzleSet.h
//  PttrnFlow
//
//  Created by John Saba on 3/16/14.
//
//

#import <Foundation/Foundation.h>

NSString *const kPFLPuzzleSetBpm = @"bpm";
NSString *const kPFLPuzzleSetFile = @"file";
NSString *const kPFLPuzzleSetKeyframes = @"keyframes";
NSString *const kPFLPuzzleSetLength = @"length";
NSString *const kPFLPuzzleSetName = @"name";
NSString *const kPFLPuzzleSetPuzzles = @"puzzles";
NSString *const kPFLPuzzleSetRange = @"range";
NSString *const kPFLPuzzleSetSourceIndex = @"source_index";
NSString *const kPFLPuzzleSetTargetIndex = @"target_index";

@interface PFLPuzzleSet : NSObject

@property (assign) NSInteger bpm;
@property (assign) NSInteger length;
@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *puzzles;

+ (PFLPuzzleSet *)puzzleSetFromResource:(NSString *)resource;
- (id)initWithJson:(NSDictionary *)json;

@end
