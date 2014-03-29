//
//  PFLGlyph.h
//  PttrnFlow
//
//  Created by John Saba on 3/16/14.
//
//

#import <Foundation/Foundation.h>

@class PFLCoord, PFLPuzzle;

@interface PFLGlyph : NSObject

@property (strong, nonatomic) NSNumber *audioID;
@property (copy, nonatomic) NSString *arrow;
@property (strong, nonatomic) PFLCoord *cell;
@property (copy, nonatomic) NSString *entry;
@property (assign) BOOL isStatic;
@property (weak, nonatomic) PFLPuzzle *puzzle;

- (id)initWithObject:(NSDictionary *)object puzzle:(PFLPuzzle *)puzzle;

@end
