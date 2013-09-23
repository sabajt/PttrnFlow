//
//  SpritePicker.m
//  PttrnFlow
//
//  Created by John Saba on 7/6/13.
//
//

#import "SpritePicker.h"

@interface SpritePicker ()

@property (strong, nonatomic) NSArray *frameNames;

@end


@implementation SpritePicker

//- (id)initWithFrameNames:(NSArray *)frameNames batchNode:(CCSpriteBatchNode *)batchNode center:(CGPoint)center
//{
//    self = [super initWithBatchNode:batchNode];
//    if (self) {
//        _frameNames = frameNames;
//        
//        
//        self.position = center;
//        [self pickSprite:0];
//    }
//    return self;
//}

- (id)initWithFrameNames:(NSArray *)frameNames center:(CGPoint)center
{
    return [self initWithFrameNames:frameNames center:center batchNode:nil];
}


- (id)initWithFrameNames:(NSArray *)frameNames center:(CGPoint)center batchNode:(CCSpriteBatchNode *)batchNode
{
    self = [super initWithBatchNode:batchNode];
    if (self) {
        self.handleTouches = NO;
        _frameNames = frameNames;
        [self pickSprite:0 center:center];
    }
    return self;
}

- (int)numberOfSprites
{
    return self.frameNames.count;
}

- (void)pickSprite:(int)index center:(CGPoint)center
{
    if (index >= [self numberOfSprites]) {
        NSLog(@"WARNING: picked sprite out of index");
        return;
    }
    
    [self setSpriteForFrameName:self.frameNames[index] position:center];
}

- (void)pickSprite:(int)index
{
    if (self.sprite != nil) {
        [self pickSprite:index center:self.sprite.position];
    }
    else {
        [self pickSprite:index center:CGPointZero];
    }
}

@end
