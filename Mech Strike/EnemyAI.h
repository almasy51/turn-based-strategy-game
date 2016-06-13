//
//  EnemyAI.h
//  Mech Strike
//
//  Created by Russell Stephenson on 2/6/15.
//  Copyright (c) 2015 Strikerware. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GameScene,Swap;

@interface EnemyAI : NSObject

@property (weak, nonatomic) GameScene * gameScene;

@property (copy, nonatomic) void (^movementHandler)(Swap * swap);

- (void)enemyAttackPhase;

@end
