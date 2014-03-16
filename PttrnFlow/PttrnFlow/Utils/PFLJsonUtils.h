//
//  PFLJsonUtils.h
//  PttrnFlow
//
//  Created by John Saba on 3/16/14.
//
//

#import <Foundation/Foundation.h>

@interface PFLJsonUtils : NSObject

+ (NSDictionary *)deserializeJsonObjectResource:(NSString *)resource;
+ (NSDictionary *)deserializeJsonObjectResource:(NSString *)resource bundle:(NSBundle *)bundle;
+ (NSArray *)deserializeJsonArrayResource:(NSString *)resource;
+ (NSArray *)deserializeJsonArrayResource:(NSString *)resource bundle:(NSBundle *)bundle;

@end
