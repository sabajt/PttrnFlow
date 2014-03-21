//
//  PFLPuzzleSet.h
//  PttrnFlow
//
//  Created by John Saba on 3/16/14.
//
//

#import <Foundation/Foundation.h>

@interface PFLPuzzleSet : NSObject

@property (assign) NSInteger bpm;
@property (assign) CGFloat beatDuration;
@property (strong, nonatomic) NSArray *keyframeSets;
@property (assign) NSInteger length;
@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *puzzles;
@property (copy, nonatomic) NSString *theme;

+ (PFLPuzzleSet *)puzzleSetFromResource:(NSString *)resource;
- (id)initWithJson:(NSDictionary *)json;
- (NSArray *)combinedSolutionEvents;

@end
