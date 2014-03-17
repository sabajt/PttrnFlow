//
//  PFLSample.h
//  PttrnFlow
//
//  Created by John Saba on 3/16/14.
//
//

#import <Foundation/Foundation.h>

@interface PFLSample : NSObject

@property (copy, nonatomic) NSString *file;
@property (copy, nonatomic) NSString *image;
@property (strong, nonatomic) NSNumber *time;

+ (NSArray *)samplesFromArray:(NSArray *)array;
- (id)initWithObject:(NSDictionary *)object;

@end
