//
//  PFLGlyph.h
//  PttrnFlow
//
//  Created by John Saba on 3/16/14.
//
//

#import <Foundation/Foundation.h>

@class Coord;

@interface PFLGlyph : NSObject

@property (strong, nonatomic) NSNumber *audioID;
@property (copy, nonatomic) NSString *arrow;
@property (strong, nonatomic) Coord *cell;
@property (copy, nonatomic) NSString *entry;
@property (assign) BOOL isStatic;

- (id)initWithObject:(NSDictionary *)object;

@end
