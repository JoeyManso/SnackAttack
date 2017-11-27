//
//  Map1.m
//  towerDefense
//
//  Created by Joey Manso on 7/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Map3.h"
#import "TowerFactory.h"
#import "BaseView.h"

@implementation Map3

-(id)init
{
    if(self = [super init])
    {
        [self initMap:@"map3.png" tiledFile:@"Map3TileMap"];
    }
    return self;
}

-(void)initRounds
{
    [super initRounds];
    
	// declare our nodes backwards
	PathNode *node06 = [[PathNode alloc] initWithPosition:[[Point2D alloc]
                                                           initWithX:mapOffset.x + 340.0f
                                                           y:mapOffset.y + 444.0f]
                                                     next:nil value:6];
    
	PathNode *node05 = [[PathNode alloc] initWithPosition:[[Point2D alloc]
                                                           initWithX:mapOffset.x + 16.0f
                                                           y:mapOffset.y + 444.0f]
                                                     next:node06 value:5];
    
	PathNode *node04 = [[PathNode alloc] initWithPosition:[[Point2D alloc]
                                                           initWithX:mapOffset.x + 16.0f
                                                           y:mapOffset.y + 248.0f]
                                                     next:node05 value:4];
    
	PathNode *node03 = [[PathNode alloc] initWithPosition:[[Point2D alloc]
                                                           initWithX:mapOffset.x + 124.0f
                                                           y:mapOffset.y + 248.0f]
                                                      next:node04 value:3];
    
	PathNode *node02 = [[PathNode alloc] initWithPosition:[[Point2D alloc]
                                                           initWithX:mapOffset.x + 124.0f
                                                           y:mapOffset.y + 108.0f]
                                                     next:node03 value:2];
    
	spawnNode = [[EnemySpawner alloc] initWithPath:self position:[[Point2D alloc]
                                                                  initWithX:-20.0f
                                                                  y:mapOffset.y + 108.0f]
                                              next:node02];
}
@end
