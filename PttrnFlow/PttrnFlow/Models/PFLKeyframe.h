//
//  PFLKeyframe.h
//  PttrnFlow
//
//  Created by John Saba on 3/16/14.
//
//

#import <Foundation/Foundation.h>

@interface PFLKeyframe : NSObject

@property (assign) NSInteger range;
@property (assign) NSInteger sourceIndex;
@property (assign) NSInteger targetIndex;

+ (NSArray *)keyframesFromArray:(NSArray *)array;
- (id)initWithObject:(NSDictionary *)object;

@end
