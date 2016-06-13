//
//  ColorTiles.h
//  Mech Strike
//
//  Created by Russell Stephenson on 2/6/15.
//  Copyright (c) 2015 Strikerware. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GameScene,Level;

@interface ColorTiles : NSObject

@property (weak, nonatomic) NSString * selectedColor;
@property (weak, nonatomic) NSArray * tilesToColor;
@property (weak, nonatomic) GameScene * gameScene;

- (void)colorTiles;

@end
