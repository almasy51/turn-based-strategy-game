//
//  GameScene.m
//  Mech Strike
//
//  Created by Russell Stephenson on 2/5/15.
//  Copyright (c) 2015 Strikerware. All rights reserved.
//

#import "GameScene.h"
#import "Mech.h"
#import "Level.h"
#import "Swap.h"
#import "Movement.h"
#import "Attack.h"
#import "EnemyAI.h"

static const CGFloat TileWidth = 32.0;
static const CGFloat TileHeight = 36.0;

enum phase {
    PlayerMovement, PlayerAttack
};
enum phase currentPhase;

@interface GameScene ()

@property (strong, nonatomic) SKNode * gameLayer;
@property (assign, nonatomic) NSInteger swipeFromColumn;
@property (assign, nonatomic) NSInteger swipeFromRow;

@end

@implementation GameScene {
    Movement * movement;
    Attack * attack;
    EnemyAI * enemyAI;
}

- (id)initWithSize:(CGSize)size {
    if ((self = [super initWithSize:size])) {
        
        self.anchorPoint = CGPointMake(0.5, 0.5);
        
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"Background"];
        [self addChild:background];
        
        self.gameLayer = [SKNode node];
        [self addChild:self.gameLayer];
        
        CGPoint layerPosition = CGPointMake(-TileWidth*NumColumns/2, -TileHeight*NumRows/2);
        
        self.tilesLayer = [SKNode node];
        self.tilesLayer.position = layerPosition;
        [self.gameLayer addChild:self.tilesLayer];
        
        self.mechsLayer = [SKNode node];
        self.mechsLayer.position = layerPosition;
        
        [self.gameLayer addChild:self.mechsLayer];
    
        self.swipeFromColumn = self.swipeFromRow = NSNotFound;
    }
    return self;
}

- (void)addSpritesForMechs:(NSSet *)mechs {
    for (Mech * mech in mechs) {
        SKSpriteNode * sprite = [SKSpriteNode spriteNodeWithImageNamed:[mech spriteName]];
        sprite.position = [self pointForColumn:mech.column row:mech.row];
        [self.mechsLayer addChild:sprite];
        mech.sprite = sprite;
    }
}

- (CGPoint)pointForColumn:(NSInteger)column row:(NSInteger)row {
    return CGPointMake(column*TileWidth + TileWidth/2, row*TileHeight + TileHeight/2);
}

- (void)addTiles {
    for (NSInteger row = 0; row < NumRows; row++) {
        for (NSInteger column = 0; column < NumColumns; column++) {
            if ([self.level tileAtColumn:column row:row] != nil) {
                SKSpriteNode *tileNode = [SKSpriteNode spriteNodeWithImageNamed:@"Tile"];
                tileNode.position = [self pointForColumn:column row:row];
                [self.tilesLayer addChild:tileNode];
            }
        }
    }
    _colorTiles = [[ColorTiles alloc] init];
    _colorTiles.gameScene = self;
    currentPhase = PlayerMovement;
    movement = [[Movement alloc] init];
    movement.gameScene = self;
    attack = [[Attack alloc] init];
    attack.gameScene = self;
    enemyAI = [[EnemyAI alloc] init];
    enemyAI.gameScene = self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self.mechsLayer];
    
    NSInteger column, row;
    if ([self convertPoint:location toColumn:&column row:&row]) {
        
        Mech * mech = [self.level mechAtColumn:column row:row];
        if (mech != nil) {

            self.swipeFromColumn = column;
            self.swipeFromRow = row;
            
            switch (currentPhase) {
                case PlayerMovement:{
                    movement.mech = mech;
                    [movement tileTouched];
                    if (movement.mechClicked == YES) {
                        movement.movementHandler = self.movementHandler;
                    }
                    if (movement.playerMovement == YES) {
                        currentPhase = PlayerAttack;
                        movement.playerMovement = NO;
                        movement.mechClicked = NO;
                        [attack tileTouched];
                    }
                    break;
                }
                case PlayerAttack:
                    attack.selectedMech = mech;
                    [attack tileTouched];
                    if (attack.attacked) {
                        attack.attacked = NO;
                        enemyAI.movementHandler = self.movementHandler;
                        [enemyAI enemyAttackPhase];
                        currentPhase = PlayerMovement;
                    }
                    break;
                default:
                    break;
            }
        }
    }
}

- (BOOL)convertPoint:(CGPoint)point toColumn:(NSInteger *)column row:(NSInteger *)row {
    NSParameterAssert(column);
    NSParameterAssert(row);
    
    // Is this a valid location within the cookies layer? If yes,
    // calculate the corresponding row and column numbers.
    if (point.x >= 0 && point.x < NumColumns*TileWidth &&
        point.y >= 0 && point.y < NumRows*TileHeight) {
        
        *column = point.x / TileWidth;
        *row = point.y / TileHeight;
        return YES;
        
    } else {
        *column = NSNotFound;  // invalid location
        *row = NSNotFound;
        return NO;
    }
}

- (void)animateSwap:(Swap *)swap completion:(dispatch_block_t)completion {
    // Put the cookie you started with on top.
    swap.mechA.sprite.zPosition = 100;
    swap.mechB.sprite.zPosition = 90;
    
    const NSTimeInterval Duration = 0.3;
    
    SKAction *moveA = [SKAction moveTo:swap.mechB.sprite.position duration:Duration];
    moveA.timingMode = SKActionTimingEaseOut;
    [swap.mechA.sprite runAction:[SKAction sequence:@[moveA, [SKAction runBlock:completion]]]];
    
    SKAction *moveB = [SKAction moveTo:swap.mechA.sprite.position duration:Duration];
    moveB.timingMode = SKActionTimingEaseOut;
    [swap.mechB.sprite runAction:moveB];
}

@end
