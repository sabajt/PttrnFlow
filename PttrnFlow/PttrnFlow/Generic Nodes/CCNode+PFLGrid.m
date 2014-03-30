//
//  CCNode+Grid.m
//  PttrnFlow
//
//  Created by John Saba on 11/23/13.
//
//

#import "CCNode+PFLGrid.h"
#import <objc/runtime.h>

static char kCellValue;
static char kCellSizeValue;

#pragma mark - public

@implementation CCNode (PFLGrid)

@dynamic cell;
@dynamic cellSize;

- (void)setCell:(PFLCoord *)cell
{
    objc_setAssociatedObject(self, &kCellValue, cell, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (PFLCoord *)cell
{
    return objc_getAssociatedObject(self, &kCellValue);
}

- (void)setCellSize:(CGSize)cellSize
{
    NSValue *value = [NSValue valueWithCGSize:cellSize];
    objc_setAssociatedObject(self, &kCellSizeValue, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGSize)cellSize
{
    NSValue *value = objc_getAssociatedObject(self, &kCellSizeValue);;
    return [value CGSizeValue];
}

@end
