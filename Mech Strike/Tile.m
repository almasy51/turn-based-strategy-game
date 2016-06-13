//
//  Tile.m
//  Mech Strike
//
//  Created by Russell Stephenson on 2/6/15.
//  Copyright (c) 2015 Strikerware. All rights reserved.
//

#import "Tile.h"

@implementation Tile

- (instancetype)init{
    if (self = [super init]) {
        _column = -1;
        _row = -1;
        _tileType = 0;
        _weight = 0;
    }
    return self;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"%ld, %ld, %ld", (long)_column, (long)_row, (long)_weight];
}

@end
