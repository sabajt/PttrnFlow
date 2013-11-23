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

#pragma mark - private

@interface CCNode (GridPrivate)

@property (strong, nonatomic) NSValue *cellValue;
@property (strong, nonatomic) NSValue *cellSizeValue;

@end

@implementation CCNode (GridPrivate)

- (void)setCellValue:(NSValue *)cellValue
{
    objc_setAssociatedObject(self, &kCellValue, cellValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSValue *)cellValue
{
    return objc_getAssociatedObject(self, &kCellValue);
}

- (void)setCellSizeValue:(NSValue *)cellSizeValue
{
    objc_setAssociatedObject(self, &kCellSizeValue, cellSizeValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSValue *)cellSizeValue
{
    return objc_getAssociatedObject(self, &kCellSizeValue);
}

@end

#pragma mark - public

@implementation CCNode (Grid)

@dynamic cell;
@dynamic cellSize;

- (void)setCell:(GridCoord)cell
{
    NSValue *value = [NSValue valueWithCGPoint:ccp(cell.x, cell.y)];
    [self setCellValue:value];
}

- (GridCoord)cell
{
    NSValue *value = [self cellValue];
    CGPoint point = [value CGPointValue];
    return GridCoordMake((int)point.x, (int)point.y);
}

- (void)setCellSize:(CGSize)cellSize
{
    NSValue *value = [NSValue valueWithCGSize:cellSize];
    [self setCellSizeValue:value];
}

- (CGSize)cellSize
{
    NSValue *value = [self cellSizeValue];
    return [value CGSizeValue];
}

@end
