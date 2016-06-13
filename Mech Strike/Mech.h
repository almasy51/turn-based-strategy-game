//
//  Mech.h
//  Mech Strike
//
//  Created by Russell Stephenson on 2/5/15.
//  Copyright (c) 2015 Strikerware. All rights reserved.
//

#import <Foundation/Foundation.h>
@import SpriteKit;

static const NSUInteger NumMechTypes = 5;

@interface Mech : NSObject

@property (assign, nonatomic) NSInteger column;
@property (assign, nonatomic) NSInteger row;
@property (assign, nonatomic) NSUInteger mechType;
@property (assign, nonatomic) SKSpriteNode * sprite;

@property (assign, nonatomic) NSInteger health;
@property (assign, nonatomic) NSInteger attackPower;
@property (assign, nonatomic) NSInteger evasion;
@property (assign, nonatomic) NSInteger attackRadius;
@property (assign, nonatomic) NSInteger movement;
@property (assign, nonatomic) NSInteger numberOfAttacks;

- (NSString *) spriteName;
- (BOOL)enemyMech;

@end
