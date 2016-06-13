//
//  GameScene.h
//  Mech Strike
//

//  Copyright (c) 2015 Strikerware. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ColorTiles.h"
@class Swap;
@class Level;

@interface GameScene : SKScene

@property (strong, nonatomic) Level * level;
@property (strong, nonatomic) ColorTiles * colorTiles;
@property (strong, nonatomic) SKNode * tilesLayer;
@property (strong, nonatomic) SKNode * mechsLayer;
@property (copy, nonatomic) void (^movementHandler)(Swap * swap);

- (void)animateSwap:(Swap *)swap completion:(dispatch_block_t)completion;
- (CGPoint)pointForColumn:(NSInteger)column row:(NSInteger)row;

- (void)addSpritesForMechs:(NSSet *)mechs;
- (void)addTiles;

@end
