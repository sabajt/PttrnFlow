//
//  CellNode.m
//  FishSet
//
//  Created by John Saba on 2/3/13.
//
//

#import "CellNode.h"
#import "GameConstants.h"
#import "SpriteUtils.h"
#import "SGTiledUtils.h"
#import "CellObjectLibrary.h"
#import "CCNode+Touch.h"

@implementation CellNode

-(id) init
{
    self = [super init];
    if (self) {
        self.contentSize = CGSizeMake(kSizeGridUnit, kSizeGridUnit);
    }
    return self;
}

-(BOOL) shouldBlockMovement
{
    return NO;
}

-(CCSprite *) createAndCenterSpriteNamed:(NSString *)name
{
    CCSprite *sprite = [SpriteUtils spriteWithTextureKey:name];
    sprite.position = CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
    return sprite;
}

-(void) moveTo:(GridCoord)cell gridOrigin:(CGPoint)origin
{
    GridCoord moveFrom = self.cell;
    self.cell = cell;
    self.position = [GridUtils relativePositionForGridCoord:cell unitSize:kSizeGridUnit];
    [self.transferResponder transferNode:self toCell:cell fromCell:moveFrom];
}

- (void)alignSprite:(kDirection)direction
{
    switch (direction) {
        case kDirectionUp:
            [self topAlignSprite];
            break;
        case kDirectionRight:
            [self rightAlignSprite];
            break;
        case kDirectionDown:
            [self bottomAlignSprite];
            break;
        case kDirectionLeft:
            [self leftAlignSprite];
            break;
        default:
            NSLog(@"warning: invalid direction, can't align sprite");
            break;
    }
}

- (void)leftAlignSprite
{
    self.sprite.position = CGPointMake(self.sprite.contentSize.width/2, self.contentSize.height/2);
}

- (void)rightAlignSprite
{
    self.sprite.position = CGPointMake(self.contentSize.width - self.sprite.contentSize.width/2, self.contentSize.height/2);
}

- (void)topAlignSprite
{
    self.sprite.position = CGPointMake(self.contentSize.width/2, self.contentSize.height - self.sprite.contentSize.height/2);
}

- (void)bottomAlignSprite
{
    self.sprite.position = CGPointMake(self.contentSize.width/2, self.sprite.contentSize.height/2);
}
#pragma mark - scene management

- (void)onEnter
{
    if ([self needsTouchDelegate]) {        
        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];
    }
	[super onEnter];
}

- (void)onExit
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if ([self needsTouchDelegate]) {
        [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    }
	[super onExit];
}


#pragma mark - standard touch delegate

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ((self.pgNotificationTouchBegan != nil) && [self containsTouch:touch]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:self.pgNotificationTouchBegan object:self];
        return YES;
    }
    return NO;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ((self.pgNotificationTouchMoved != nil) && [self containsTouch:touch]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:self.pgNotificationTouchMoved object:self];
    }
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ((self.pgNotificationTouchEnded != nil) && [self containsTouch:touch]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:self.pgNotificationTouchEnded object:self];
    }
}

#pragma mark - touch utils

- (BOOL)needsTouchDelegate
{
    return ((self.pgNotificationTouchBegan != nil) || (self.pgNotificationTouchEnded != nil) || (self.pgNotificationTouchMoved != nil));
}

@end
