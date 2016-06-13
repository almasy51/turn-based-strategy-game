//
//  Swap.h
//  Mech Strike
//
//  Created by Russell Stephenson on 2/5/15.
//  Copyright (c) 2015 Strikerware. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Mech;

@interface Swap : NSObject

@property (strong, nonatomic) Mech * mechA;
@property (strong, nonatomic) Mech * mechB;

@end
