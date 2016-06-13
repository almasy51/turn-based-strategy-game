//
//  Attack.h
//  Mech Strike
//
//  Created by Russell Stephenson on 2/6/15.
//  Copyright (c) 2015 Strikerware. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Mech,Level,GameScene;

@interface Attack : NSObject

@property (weak, nonatomic) Mech * selectedMech;
@property (weak, nonatomic) GameScene * gameScene;
@property (assign, nonatomic) BOOL attacked;

- (void)tileTouched;

@end
