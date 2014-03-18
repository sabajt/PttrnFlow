//
//  PFLPuzzleSet.h
//  PttrnFlow
//
//  Created by John Saba on 3/16/14.
//
//

#import <Foundation/Foundation.h>

@interface PFLPuzzleSet : NSObject

@property (assign) CGFloat beatDuration;
@property (assign) NSInteger bpm;
@property (strong, nonatomic) NSArray *combinedSolutionEvents;
@property (assign) NSInteger length;
@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *puzzles;
@property (strong, nonatomic) NSArray *keyframeSets;

+ (PFLPuzzleSet *)puzzleSetFromResource:(NSString *)resource;
- (id)initWithJson:(NSDictionary *)json;

@end
