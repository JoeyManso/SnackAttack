//
//  Map1.m
//  towerDefense
//
//  Created by Joey Manso on 7/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Map1.h"
#import "TowerFactory.h"
#import "BaseView.h"

@implementation Map1

-(id)init
{
    if(self = [super init])
    {
        backgroundMap = [[Image alloc] initWithImage:[UIImage imageNamed:@"map1.png"]];
        
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        mapOffset = CGPointMake(0.0f,0.0f);
        mapOffset.x = (screenBounds.size.width - [backgroundMap imageWidth]) * 0.5f;
        mapOffset.y = (screenBounds.size.height - [backgroundMap imageHeight]) * 0.5f;
        
        tileMap = [[TiledMap alloc] initWithTiledFile:@"Map1TileMap" fileExtension:@"tmx" offset:mapOffset];
    }
    return self;
}

-(void)initRounds
{
    [super initRounds];
    
	// declare our nodes backwards
	PathNode *node11 = [[PathNode alloc] initWithPosition:[[Point2D alloc]
                                                           initWithX:mapOffset.x - 20.0f
                                                           y:mapOffset.y + 368.0f]
                                                     next:nil value:11];
    
	PathNode *node10 = [[PathNode alloc] initWithPosition:[[Point2D alloc]
                                                           initWithX:mapOffset.x + 112.0f
                                                           y:mapOffset.y + 368.0f]
                                                     next:node11 value:10];
    
	PathNode *node09 = [[PathNode alloc] initWithPosition:[[Point2D alloc]
                                                           initWithX:mapOffset.x + 112.0f
                                                           y:mapOffset.y + 400.0f]
                                                     next:node10 value:9];
    
	PathNode *node08 = [[PathNode alloc] initWithPosition:[[Point2D alloc]
                                                           initWithX:mapOffset.x + 304.0f
                                                           y:mapOffset.y +400.0f]
                                                     next:node09 value:8];
    
	PathNode *node07 = [[PathNode alloc] initWithPosition:[[Point2D alloc]
                                                           initWithX:mapOffset.x + 304.0f
                                                           y:mapOffset.y + 176.0f]
                                                     next:node08 value:7];
    
	PathNode *node06 = [[PathNode alloc] initWithPosition:[[Point2D alloc]
                                                           initWithX:mapOffset.x + 176.0f
                                                           y:mapOffset.y + 176.0f]
                                                     next:node07 value:6];
    
	PathNode *node05 = [[PathNode alloc] initWithPosition:[[Point2D alloc]
                                                           initWithX:mapOffset.x + 176.0f
                                                           y:mapOffset.y + 240.0f]
                                                     next:node06 value:5];
    
	PathNode *node04 = [[PathNode alloc] initWithPosition:[[Point2D alloc]
                                                           initWithX:mapOffset.x + 16.0f
                                                           y:mapOffset.y + 240.0f]
                                                     next:node05 value:4];
    
	PathNode *node03 = [[PathNode alloc] initWithPosition:[[Point2D alloc]
                                                           initWithX:mapOffset.x + 16.0f
                                                           y:mapOffset.y + 80.0f]
                                                      next:node04 value:3];
    
	PathNode *node02 = [[PathNode alloc] initWithPosition:[[Point2D alloc]
                                                           initWithX:mapOffset.x + 240.0f
                                                           y:mapOffset.y + 80.0f]
                                                     next:node03 value:2];
    
	spawnNode = [[EnemySpawner alloc] initWithPath:self position:[[Point2D alloc]
                                                                  initWithX:mapOffset.x + 240.0f
                                                                  y:-20.0f]
                                              next:node02];
}
@end
