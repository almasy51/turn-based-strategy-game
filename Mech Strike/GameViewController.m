//
//  GameViewController.m
//  Mech Strike
//
//  Created by Russell Stephenson on 2/5/15.
//  Copyright (c) 2015 Strikerware. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"
#import "Level.h"
#import "Mech.h"

@interface GameViewController()

@property (strong, nonatomic) Level * level;
@property (strong, nonatomic) GameScene * scene;

@property (weak, nonatomic) IBOutlet UILabel *levelName;
@property (weak, nonatomic) IBOutlet UILabel *playerName;
@property (weak, nonatomic) IBOutlet UILabel *playerHealth;
@property (weak, nonatomic) IBOutlet UILabel *enemyName;
@property (weak, nonatomic) IBOutlet UILabel *enemyHealth;

@property (weak, nonatomic) IBOutlet UIImageView *playerMechImageView;
@property (weak, nonatomic) IBOutlet UIImageView *enemyMechImageView;
@property (weak, nonatomic) IBOutlet UIImageView *gameBackgroundImageView;

@end

@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    return scene;
}

@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Configure the view.
    SKView *skView = (SKView *)self.view;
    skView.multipleTouchEnabled = NO;
    
    // Create and configure the scene.
    self.scene = [GameScene sceneWithSize:skView.bounds.size];
    self.scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Load the level.
    self.level = [[Level alloc] initWithFile:@"Level_1"];
    self.scene.level = self.level;
    [self.scene addTiles];
    
    id block = ^(Swap *swap) {
        self.view.userInteractionEnabled = NO;
        
        [self.level performSwap:swap];
        [self.scene animateSwap:swap completion:^{
            self.view.userInteractionEnabled = YES;
        }];
    };
    
    self.scene.movementHandler = block;
    
    // Present the scene.
    [skView presentScene:self.scene];
    
    

    [self updateLabels];
    
    [self beginGame];
}

- (void)beginGame {
    [self setUpTiles];
}

- (void) setUpTiles {
    NSSet * newTiles = [_level setUpBattleField];
    [_scene addSpritesForMechs:newTiles];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)updateLabels {
    self.levelName.text = [NSString stringWithFormat:@"%@", self.level.title];
    self.playerName.text = @"Player 1";
    self.playerHealth.text = [NSString stringWithFormat:@"%lu", self.level.playerMech.health];
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
