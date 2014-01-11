//
//  CCNode+Grid.m
//  PttrnFlow
//
//  Created by John Saba on 11/23/13.
//
//

#import "CCNode+Grid.h"
#import <objc/runtime.h>

static char kCellValue;
static char kCellSizeValue;

#pragma mark - public

@implementation CCNode (Grid)

@dynamic cell;
@dynamic cellSize;

- (void)setCell:(GridCoord)cell
{
    NSValue *value = [NSValue valueWithCGPoint:ccp(cell.x, cell.y)];
    objc_setAssociatedObject(self, &kCellValue, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (GridCoord)cell
{
    NSValue *value = objc_getAssociatedObject(self, &kCellValue);
    CGPoint point = [value CGPointValue];
    return GridCoordMake((int)point.x, (int)point.y);
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
