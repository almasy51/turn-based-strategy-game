//
//  ColorTiles.m
//  Mech Strike
//
//  Created by Russell Stephenson on 2/6/15.
//  Copyright (c) 2015 Strikerware. All rights reserved.
//

#import "ColorTiles.h"
#import "Level.h"
#import "GameScene.h"
#import "Tile.h"
#import "Mech.h"

@implementation ColorTiles

- (void)colorTiles {
    if ([_selectedColor isEqualToString:@"move"]) {
        for (Tile * tile in _tilesToColor) {
            if ([_gameScene.level mechAtColumn:tile.column row:tile.row].mechType != 5) {
                [self colorTile:tile withTileType:@"AttackTile"];
            } else {
                [self colorTile:tile withTileType:@"MovementTile"];
            }
        }
    } else if ([_selectedColor isEqualToString:@"attack"]) {
        for (Tile * tile in _tilesToColor) {
            [self colorTile:tile withTileType:@"AttackTile"];
        }
    } else if ([_selectedColor isEqualToString:@"original"]) {
        for (Tile * tile in _tilesToColor) {
            [self colorTile:tile withTileType:@"Tile"];
        }
    }
}

- (void)colorTile:(Tile *)tile withTileType:(NSString *)tileType{
    SKNode * node = [_gameScene.tilesLayer nodeAtPoint:[_gameScene pointForColumn:tile.column row:tile.row]];
    [node removeFromParent];
    
    SKSpriteNode * tileNode = [SKSpriteNode spriteNodeWithImageNamed:tileType];
    tileNode.position = [_gameScene pointForColumn:tile.column row:tile.row];
    [_gameScene.tilesLayer addChild:tileNode];
}



@end
