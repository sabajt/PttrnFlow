//
//  PFLPuzzle.h
//  PttrnFlow
//
//  Created by John Saba on 3/15/14.
//
//

#import <Foundation/Foundation.h>

@class PFLPuzzleSet;

@interface PFLPuzzle : NSObject

@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *area;
@property (strong, nonatomic) NSArray *audio;
@property (strong, nonatomic) NSArray *glyphs;
@property (weak, nonatomic) PFLPuzzleSet *puzzleSet;
@property (strong, nonatomic) NSArray *solution;
@property (strong, nonatomic) NSArray *solutionEvents;

+ (PFLPuzzle *)puzzleFromResource:(NSString *)resource puzzleSet:(PFLPuzzleSet *)puzzleSet;
- (id)initWithJson:(NSDictionary *)json puzzleSet:(PFLPuzzleSet *)puzzleSet;

@end
