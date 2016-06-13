//
//  Movement.m
//  Mech Strike
//
//  Created by Russell Stephenson on 2/6/15.
//  Copyright (c) 2015 Strikerware. All rights reserved.
//

#import "Movement.h"
#import "Tile.h"
#import "Swap.h"
#import "Mech.h"
#import "Level.h"
#import "GameScene.h"

const NSUInteger PLAYERMECH = 1;
const NSUInteger SNIPERMECH = 2;
const NSUInteger RIFLEMECH = 3;
const NSUInteger SABERMECH = 4;

@implementation Movement {
    NSMutableArray * openSet;
    NSMutableArray * eligibleMoves;
}

- (void)tileTouched {
    if (_mechClicked == NO) {
        if (_mech.mechType == PLAYERMECH) {
            _playerMovement = NO;
            [self validMoves];
            _gameScene.colorTiles.tilesToColor = eligibleMoves;
            _gameScene.colorTiles.selectedColor = @"move";
            [_gameScene.colorTiles colorTiles];
            _mechClicked = YES;
        } else {
            
        }
    } else {
        [self moveMech:_mech];
    }
    
}

- (void)validMoves {
    Tile * currentTile = [_gameScene.level tileAtColumn:_mech.column row:_mech.row];
    currentTile.weight = 0;
    [self addNeighbors:currentTile];
    while (openSet.count != 0) {
        currentTile = [openSet objectAtIndex:0];
        [openSet removeObjectAtIndex:0];
        [self addNeighbors:currentTile];
    }
    
}

- (void)addNeighbors:(Tile *)tile {
    [self addNeighbor:tile withColumn:tile.column-1 withRow:tile.row];
    [self addNeighbor:tile withColumn:tile.column+1 withRow:tile.row];
    [self addNeighbor:tile withColumn:tile.column withRow:tile.row-1];
    [self addNeighbor:tile withColumn:tile.column withRow:tile.row+1];
}

- (void)addNeighbor:(Tile *)tile withColumn:(NSInteger)column withRow:(NSInteger)row {
    if ((column >= 0 && column < NumColumns) && (row >= 0 && row < NumRows)){
        Tile * nextTile = [_gameScene.level tileAtColumn:column row:row];
        if (nextTile != nil) {
            if ((tile.weight + nextTile.tileType <= _mech.movement) && ![openSet containsObject:nextTile]) {
                nextTile.weight = tile.weight + nextTile.tileType;
                [openSet addObject:nextTile];
                [eligibleMoves addObject:nextTile];
            }
        }
    }
}

- (void)moveMech:(Mech *) mech {
    Mech * fromTile = _gameScene.level.playerMech;
    Mech * toTile = _mech;
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"column == %d AND row == %d", toTile.column, toTile.row];
    
    BOOL ok = ([eligibleMoves filteredArrayUsingPredicate:predicate].count != 0);
    
    if (!ok) {
        _mechClicked = NO;
        _gameScene.colorTiles.tilesToColor = eligibleMoves;
        _gameScene.colorTiles.selectedColor = @"original";
        [_gameScene.colorTiles colorTiles];
        [eligibleMoves removeAllObjects];
    } else {
        if (toTile.mechType == 5) {
            [self move:fromTile with:toTile];
            [eligibleMoves removeAllObjects];
        }
    }
}

- (void)move:(Mech *)mechA with:(Mech *)mechB{
    if (self.movementHandler != nil) {
        Swap * swap = [[Swap alloc] init];
        swap.mechA = mechA;
        swap.mechB = mechB;
        
        self.movementHandler(swap);
    }
    _gameScene.colorTiles.tilesToColor = eligibleMoves;
    _gameScene.colorTiles.selectedColor = @"original";
    [_gameScene.colorTiles colorTiles];
    _playerMovement = YES;
}

- (instancetype)init{
    if (self = [super init]) {
        openSet = [[NSMutableArray alloc] init];
        eligibleMoves = [[NSMutableArray alloc] init];
        _mechClicked = NO;
    }
    return self;
}

@end
