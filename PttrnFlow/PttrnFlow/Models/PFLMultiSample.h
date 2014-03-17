//
//  PFLMultiSample.h
//  PttrnFlow
//
//  Created by John Saba on 3/16/14.
//
//

#import <Foundation/Foundation.h>

@interface PFLMultiSample : NSObject

@property (strong, nonatomic) NSArray *samples;

- (id)initWithSamples:(NSArray *)samples;

@end
