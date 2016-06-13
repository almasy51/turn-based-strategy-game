//
//  EnemyAI.m
//  Mech Strike
//
//  Created by Russell Stephenson on 2/6/15.
//  Copyright (c) 2015 Strikerware. All rights reserved.
//

#import "EnemyAI.h"
#import "Mech.h"
#import "Level.h"
#import "GameScene.h"
#import "Tile.h"
#import "Swap.h"

@implementation EnemyAI {
    Mech * enemyMech;
    NSMutableArray * openSet;
    NSMutableArray * eligibleMoves;
    NSMutableArray * eligibleAttacks;
    NSMutableArray * tilesFromPlayer;
    NSMutableArray * closedSet;
    BOOL gettingTilesFromPlayer;
}

- (void)enemyAttackPhase {
    NSLog(@"Player: %@", _gameScene.level.playerMech);
    NSLog(@"Enemies: %@", _gameScene.level.enemies);
    for (Mech * mech in _gameScene.level.enemies) {
        enemyMech = mech;
        [self singleEnemyMovement];
        [eligibleMoves removeAllObjects];
        [eligibleAttacks removeAllObjects];
        [tilesFromPlayer removeAllObjects];
        [closedSet removeAllObjects];
    }
    NSLog(@"Player: %@", _gameScene.level.playerMech);
    NSLog(@"Enemies: %@", _gameScene.level.enemies);
}

- (void)singleEnemyMovement {
    [self findShortestPathToPlayer];
    int randomIndex = arc4random_uniform((UInt32)[eligibleAttacks count]);
    Tile * randomTile = eligibleAttacks[randomIndex];
    [self moveEnemyMech:enemyMech toTile:[_gameScene.level mechAtColumn:randomTile.column row:randomTile.row]];
}

- (void)findShortestPathToPlayer {
    [self validMoves:enemyMech withIndex:(int)enemyMech.movement];
    gettingTilesFromPlayer = YES;
    [closedSet removeAllObjects];
    [self validMoves:_gameScene.level.playerMech withIndex:(int)enemyMech.attackRadius];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"column == %d AND row == %d", _gameScene.level.playerMech.column, _gameScene.level.playerMech.row];
    [tilesFromPlayer removeObjectsInArray:[tilesFromPlayer filteredArrayUsingPredicate:predicate]];
    
    [self calculateBestMove];
    
    gettingTilesFromPlayer = NO;
}

- (void)calculateBestMove {
    NSMutableArray * bestMoves = [[NSMutableArray alloc] init];
    
    for (Tile * tile in tilesFromPlayer) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"column == %d AND row == %d", tile.column, tile.row];
            
        BOOL ok = ([eligibleMoves filteredArrayUsingPredicate:predicate].count != 0);
        if (ok && tile.weight == enemyMech.attackRadius) {
            [bestMoves addObject:tile];
        }
    }
    if (bestMoves.count != 0) {
        eligibleAttacks = bestMoves;
    } else {
        [self playerOutOfRangeBestMoves];
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"column == %d AND row == %d", enemyMech.column, enemyMech.row];
        [eligibleMoves removeObjectsInArray:[eligibleMoves filteredArrayUsingPredicate:predicate]];
    }
}

- (void)playerOutOfRangeBestMoves {
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"column BETWEEN %@ AND row BETWEEN %@", @[@(enemyMech.column), @(_gameScene.level.playerMech.column)], @[@(enemyMech.row), @(_gameScene.level.playerMech.row)]];
    [eligibleAttacks addObjectsFromArray:[eligibleMoves filteredArrayUsingPredicate:predicate]];
    predicate = [NSPredicate predicateWithFormat:@"column == %d AND row == %d", enemyMech.column, enemyMech.row];
    [eligibleAttacks removeObjectsInArray:[eligibleAttacks filteredArrayUsingPredicate:predicate]];
}

- (void)moveEnemyMech:(Mech *)mechA toTile:(Mech *)mechB {
    if (self.movementHandler != nil) {
        Swap * swap = [[Swap alloc] init];
        swap.mechA = mechA;
        swap.mechB = mechB;
        
        self.movementHandler(swap);
    }
}

- (void)validMoves:(Mech *)mech withIndex:(int)index {
    Tile * currentTile = [_gameScene.level tileAtColumn:mech.column row:mech.row];
    currentTile.weight = 0;
    [openSet addObject:currentTile];
    [closedSet addObject:currentTile];
    if (!gettingTilesFromPlayer) {
        [eligibleMoves addObject:currentTile];
    } else {
        [tilesFromPlayer addObject:currentTile];
    }
    [self addNeighbors:currentTile withIndex:index];
    while (openSet.count != 0) {
        currentTile = [openSet objectAtIndex:0];
        [self addNeighbors:currentTile withIndex:index];
        [openSet removeObjectAtIndex:0];
    }
    
}

- (void)addNeighbors:(Tile *)tile withIndex:(int)index {
    [self addNeighbor:tile withColumn:tile.column-1 withRow:tile.row withIndex:index];
    [self addNeighbor:tile withColumn:tile.column+1 withRow:tile.row withIndex:index];
    [self addNeighbor:tile withColumn:tile.column withRow:tile.row-1 withIndex:index];
    [self addNeighbor:tile withColumn:tile.column withRow:tile.row+1 withIndex:index];
}

- (void)addNeighbor:(Tile *)tile withColumn:(NSInteger)column withRow:(NSInteger)row withIndex:(int)index {
    if ((column >= 0 && column < NumColumns) && (row >= 0 && row < NumRows)){
        Tile * nextTile = [_gameScene.level tileAtColumn:column row:row];
        if (nextTile != nil) {
            
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"column == %d AND row == %d", nextTile.column, nextTile.row];
            
            BOOL ok = ([closedSet filteredArrayUsingPredicate:predicate].count != 0);
            
            if ((tile.weight + nextTile.tileType <= index) && ![openSet containsObject:nextTile] && !ok && [_gameScene.level mechAtColumn:nextTile.column row:nextTile.row].mechType == 5) {
                nextTile.weight = tile.weight + nextTile.tileType;
                [openSet addObject:nextTile];
                [closedSet addObject:nextTile];
                if (!gettingTilesFromPlayer && [_gameScene.level mechAtColumn:nextTile.column row:nextTile.row].mechType == 5) {
                    [eligibleMoves addObject:nextTile];
                } else {
                    [tilesFromPlayer addObject:nextTile];
                }
            }
        }
    }
}

- (void)colorTiles:(NSString *)color withTiles:(NSArray *)tiles {
    _gameScene.colorTiles.tilesToColor = tiles;
    _gameScene.colorTiles.selectedColor = color;
    [_gameScene.colorTiles colorTiles];
}

- (instancetype)init{
    if (self = [super init]) {
        openSet = [[NSMutableArray alloc] init];
        eligibleMoves = [[NSMutableArray alloc] init];
        eligibleAttacks = [[NSMutableArray alloc] init];
        tilesFromPlayer = [[NSMutableArray alloc] init];
        closedSet = [[NSMutableArray alloc] init];
        gettingTilesFromPlayer = NO;
    }
    return self;
}

@end
