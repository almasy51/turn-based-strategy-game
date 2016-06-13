//
//  Mech.m
//  Mech Strike
//
//  Created by Russell Stephenson on 2/5/15.
//  Copyright (c) 2015 Strikerware. All rights reserved.
//

#import "Mech.h"

@implementation Mech
- (NSString *)spriteName {
    static NSString * const spriteNames[] = {
        @"Player",
        @"EnemySniper",
        @"EnemyRifle",
        @"EnemySaber",
        @"NoMech",
    };
    
    return spriteNames[self.mechType - 1];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"type:%ld square:(%ld,%ld)", (long)self.mechType, (long)self.column, (long)self.row];
}

- (BOOL)enemyMech {
    return _mechType == 2 || _mechType == 3 || _mechType == 4;
}
@end
