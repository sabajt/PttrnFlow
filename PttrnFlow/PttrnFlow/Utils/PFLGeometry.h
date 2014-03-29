//
//  PFGeometry.h
//  PttrnFlow
//
//  Created by John Saba on 1/5/14.
//
//

#import <Foundation/Foundation.h>

@interface PFLGeometry : NSObject

CGPoint CGMidPointMake(CGPoint p1, CGPoint p2);
CGSize CGContainingSize(CGSize s1, CGSize s2);

@end
