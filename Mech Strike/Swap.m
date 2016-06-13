//
//  Swap.m
//  Mech Strike
//
//  Created by Russell Stephenson on 2/5/15.
//  Copyright (c) 2015 Strikerware. All rights reserved.
//

#import "Swap.h"
#import "Mech.h"

@implementation Swap

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ swap %@ with %@", [super description], self.mechA, self.mechB];
}

@end
