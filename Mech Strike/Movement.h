//
//  Movement.h
//  Mech Strike
//
//  Created by Russell Stephenson on 2/6/15.
//  Copyright (c) 2015 Strikerware. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Mech,Level,GameScene,Swap;

@interface Movement : NSObject

@property (strong, nonatomic) Mech * mech;
@property (copy, nonatomic) void (^movementHandler)(Swap * swap);
@property (assign, nonatomic) BOOL mechClicked;
@property (assign, nonatomic) BOOL playerMovement;
@property (strong, nonatomic) GameScene * gameScene;

- (void)tileTouched;

@end
