//
//  Puzzle.h
//  PttrnFlow
//
//  Created by John Saba on 3/15/14.
//
//

#import <Foundation/Foundation.h>

@interface Puzzle : NSObject

@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *area;
@property (strong, nonatomic) NSArray *audio;
@property (strong, nonatomic) NSArray *glyphs;
@property (strong, nonatomic) NSArray *solution;

+ (Puzzle *)puzzleFromResource:(NSString *)resource;
- (id)initWithJson:(NSDictionary *)json;

@end
