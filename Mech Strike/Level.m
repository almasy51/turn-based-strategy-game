//
//  Level.m
//  Mech Strike
//
//  Created by Russell Stephenson on 2/5/15.
//  Copyright (c) 2015 Strikerware. All rights reserved.
//

#import "Level.h"
#import "Mech.h"
#import "Swap.h"
#import "Tile.h"

@implementation Level {
    Mech * mechs[NumColumns][NumRows];
    Tile * tiles[NumColumns][NumRows];
}

- (Mech *)mechAtColumn:(NSInteger)column row:(NSInteger)row {
    assert(column >= 0 && column < NumColumns);
    assert(row >= 0 && row < NumRows);
    return mechs[column][row];
}

- (Tile *)tileAtColumn:(NSInteger)column row:(NSInteger)row {
    assert(column >= 0 && column < NumColumns);
    assert(row >= 0 && row < NumRows);
    return tiles[column][row];
}

- (NSSet *) setUpBattleField {
    NSMutableSet * set = [NSMutableSet set];
    NSUInteger noMech = 5;
    
    for (NSInteger row = 0; row < NumRows; row++) {
        for (NSInteger column = 0; column < NumColumns; column++) {
            if (tiles[column][row] != nil) {
                Mech * mech = [self addMech:column row:row withType:noMech];
            
                [set addObject:mech];
            }
        }
    }
    
    _playerMech = [self addMech:2 row:2 withType:1];
    [set addObject:_playerMech];

    _enemies = [[NSMutableArray alloc] initWithObjects:
                [self addMech:7 row:8 withType:2],
                [self addMech:6 row:2 withType:3],
                [self addMech:4 row:5 withType:4], nil];
    [set addObjectsFromArray:_enemies];
    
    return set;
}

- (Mech *)addMech:(NSInteger)column row:(NSInteger)row withType:(NSUInteger)mechType {
    Mech * mech = [[Mech alloc] init];
    mech.mechType = mechType;
    mech.row = row;
    mech.column = column;
    mechs[column][row] = mech;
    switch (mechType) {
        case 1:
            mech.health = 300;
            mech.attackPower = 20;
            mech.evasion = 14;
            mech.attackRadius = 3;
            mech.movement = 2;
            mech.numberOfAttacks = 5;
            break;
        case 2:
            mech.health = 100;
            mech.attackPower = 50;
            mech.evasion = 12;
            mech.attackRadius = 4;
            mech.movement = 1;
            mech.numberOfAttacks = 1;
            break;
        case 3:
            mech.health = 200;
            mech.attackPower = 10;
            mech.evasion = 10;
            mech.attackRadius = 3;
            mech.movement = 2;
            mech.numberOfAttacks = 3;
            break;
        case 4:
            mech.health = 250;
            mech.attackPower = 30;
            mech.evasion = 8;
            mech.attackRadius = 2;
            mech.movement = 3;
            mech.numberOfAttacks = 1;
            break;
        default:
            mech.health = 0;
            mech.attackPower = 0;
            mech.evasion = 0;
            mech.attackRadius = 0;
            mech.movement = 0;
            break;
    }
    return mech;
}

- (Mech *)getEnemyData:(Mech *) selectedMech completion:(dispatch_block_t)completion {
    Mech * enemy = [[Mech alloc] init];
    NSArray * filterArray = [[NSArray alloc] init];
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"column == %d AND row == %d", selectedMech.column, selectedMech.row];
    [filterArray arrayByAddingObjectsFromArray:[self.enemies filteredArrayUsingPredicate:predicate]];
    if (filterArray != nil) {
        enemy = filterArray[0];
    }
    
    return enemy;
}

- (void)performSwap:(Swap *) swap {
    NSInteger columnA = swap.mechA.column;
    NSInteger rowA = swap.mechA.row;
    NSInteger columnB = swap.mechB.column;
    NSInteger rowB = swap.mechB.row;
    
    mechs[columnA][rowA] = swap.mechB;
    swap.mechB.column = columnA;
    swap.mechB.row = rowA;
    
    mechs[columnB][rowB] = swap.mechA;
    swap.mechA.column = columnB;
    swap.mechA.row = rowB;
}

- (instancetype)initWithFile:(NSString *)filename {
    self = [super init];
    if (self != nil) {
        NSDictionary *dictionary = [self loadJSON:filename];
        [dictionary[@"tiles"] enumerateObjectsUsingBlock:^(NSArray *array, NSUInteger row, BOOL *stop) {
            [array enumerateObjectsUsingBlock:^(NSNumber *value, NSUInteger column, BOOL *stop) {
                NSInteger tileRow = NumRows - row - 1;
                
                if ([value integerValue] == 1) {
                    Tile * tile = [[Tile alloc]init];
                    tile.column = column;
                    tile.row = tileRow;
                    tile.tileType = [value integerValue];
                    tiles[column][tileRow] = tile;
                }
            }];
        }];
        //self.title = [dictionary[@"title"] string];
    }
    return self;
}

- (NSDictionary *)loadJSON:(NSString *)filename {
    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:@"json"];
    if (path == nil) {
        NSLog(@"Could not find level file: %@", filename);
        return nil;
    }
    
    NSError *error;
    NSData *data = [NSData dataWithContentsOfFile:path options:0 error:&error];
    if (data == nil) {
        NSLog(@"Could not load level file: %@, error: %@", filename, error);
        return nil;
    }
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (dictionary == nil || ![dictionary isKindOfClass:[NSDictionary class]]) {
        NSLog(@"Level file '%@' is not valid JSON: %@", filename, error);
        return nil;
    }
    
    return dictionary;
}

@end
