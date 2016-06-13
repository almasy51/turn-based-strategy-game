//
//  Attack.m
//  Mech Strike
//
//  Created by Russell Stephenson on 2/6/15.
//  Copyright (c) 2015 Strikerware. All rights reserved.
//

#import "Attack.h"
#import "Tile.h"
#import "Mech.h"
#import "Level.h"
#import "GameScene.h"

@implementation Attack {
    NSMutableArray * openSet;
    NSMutableArray * eligibleAttacks;
    BOOL attackTilesUp;
}

- (void)tileTouched {
    if (attackTilesUp == NO) {
        [self validAttacks];
        _gameScene.colorTiles.tilesToColor = eligibleAttacks;
        _gameScene.colorTiles.selectedColor = @"attack";
        [_gameScene.colorTiles colorTiles];
    } else {
        [self attack];
    }
    
}

- (void)validAttacks {
    Tile * currentTile = [_gameScene.level tileAtColumn:_gameScene.level.playerMech.column row:_gameScene.level.playerMech.row];
    currentTile.weight = 0;
    
    [self addAttackTiles:currentTile];
    
    while (openSet.count != 0) {
        currentTile = [openSet objectAtIndex:0];
        [openSet removeObjectAtIndex:0];
        [self addAttackTiles:currentTile];
    }
    
    if (eligibleAttacks.count == 0) {
        _attacked = YES;
    }
    
    attackTilesUp = YES;
}

- (void)addAttackTiles:(Tile *)tile {
    [self addAttackTile:tile withColumn:tile.column-1 withRow:tile.row];
    [self addAttackTile:tile withColumn:tile.column+1 withRow:tile.row];
    [self addAttackTile:tile withColumn:tile.column withRow:tile.row-1];
    [self addAttackTile:tile withColumn:tile.column withRow:tile.row+1];
}

- (void)addAttackTile:(Tile *)tile withColumn:(NSInteger)column withRow:(NSInteger)row {
    if ((column >= 0 && column < NumColumns) && (row >= 0 && row < NumRows)){
        Tile * nextTile = [_gameScene.level tileAtColumn:column row:row];
        Mech * possibleEnemyMech = [_gameScene.level mechAtColumn:column row:row];
        if (nextTile != nil) {
            if ((tile.weight <= _gameScene.level.playerMech.attackRadius) && ![openSet containsObject:nextTile]) {
                nextTile.weight = tile.weight + nextTile.tileType;
                [openSet addObject:nextTile];
                if ([possibleEnemyMech enemyMech] && ![eligibleAttacks containsObject:nextTile]) {
                    [eligibleAttacks addObject:nextTile];
                }
            }
        }
    }
}

- (void)attack {
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"column == %d AND row == %d", _selectedMech.column, _selectedMech.row];
    
    BOOL ok = ([eligibleAttacks filteredArrayUsingPredicate:predicate].count != 0);
    
    if (ok) {
        [self initateAttack:_gameScene.level.playerMech againstEnemy:_selectedMech];
    }
    attackTilesUp = NO;
}

- (void)initateAttack:(Mech *)playerMech againstEnemy:(Mech *)enemyMech {
    int hitCount = [self rollTwentySidedDie];
    enemyMech.health -= hitCount * playerMech.attackPower;
    if (enemyMech.health <= 0) {
        SKNode * node = [_gameScene.mechsLayer nodeAtPoint:[_gameScene pointForColumn:enemyMech.column row:enemyMech.row]];
        [node removeFromParent];
        
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"column == %d AND row == %d", enemyMech.column, enemyMech.row];

        [_gameScene.level.enemies removeObjectsInArray:[_gameScene.level.enemies filteredArrayUsingPredicate:predicate]];
        
        SKSpriteNode * tileNode = [SKSpriteNode spriteNodeWithImageNamed:@"NoMech"];
        tileNode.position = [_gameScene pointForColumn:enemyMech.column row:enemyMech.row];
        [_gameScene.mechsLayer addChild:tileNode];
        enemyMech.mechType = 5;
    }
    _gameScene.colorTiles.tilesToColor = eligibleAttacks;
    _gameScene.colorTiles.selectedColor = @"original";
    [_gameScene.colorTiles colorTiles];
    _attacked = YES;
    [eligibleAttacks removeAllObjects];
}

- (int)rollTwentySidedDie {
    int numberOfHits = 0;
    
    for (int i = 0; i < _gameScene.level.playerMech.numberOfAttacks; i++) {
        int diceRoll = arc4random_uniform(20) + 1;
        if (diceRoll >= _selectedMech.evasion) {
            numberOfHits++;
            if (diceRoll == 20) {
                numberOfHits++;
            }
        }
        
    }
    return numberOfHits;
}

- (instancetype)init{
    if (self = [super init]) {
        openSet = [[NSMutableArray alloc] init];
        eligibleAttacks = [[NSMutableArray alloc] init];
        attackTilesUp = NO;
        _attacked = NO;
    }
    return self;
}

@end
