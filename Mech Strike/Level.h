//
//  Level.h
//  Mech Strike
//
//  Created by Russell Stephenson on 2/5/15.
//  Copyright (c) 2015 Strikerware. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Mech,Swap,Tile;

static const NSInteger NumColumns = 9;
static const NSInteger NumRows = 9;

@interface Level : NSObject

@property (strong, nonatomic) NSMutableArray * enemies;
@property (strong, nonatomic) Mech * playerMech;
@property (strong, nonatomic) NSString * title;

- (instancetype)initWithFile:(NSString *)filename;

- (Tile *)tileAtColumn:(NSInteger)column row:(NSInteger)row;
- (Mech *)mechAtColumn:(NSInteger)column row:(NSInteger)row;
- (Mech *)getEnemyData:(Mech *) selectedMech completion:(dispatch_block_t)completion;

- (NSSet *) setUpBattleField;
- (void)performSwap:(Swap *)swap;

@end
