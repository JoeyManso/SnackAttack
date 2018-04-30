//
//  Map1.m
//  towerDefense
//
//  Created by Joey Manso on 7/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Map3.h"
#import "BaseView.h"

@implementation Map3

-(id)init
{
    if(self = [super init])
    {
        [self initMap:@"map3.png" tiledFile:@"Map3TileMap" mapSpawn:MS_LOW];
    }
    return self;
}

-(void)initRounds
{
    [super initRounds];
    
	// declare our nodes backwards
	PathNode *nodeEnd = [[PathNode alloc] initWithPosition:[[Point2D alloc]
                                                           initWithX:mapOffset.x + 340.0f
                                                           y:mapOffset.y + 444.0f]
                                                     next:nil value:13];
    
	PathNode *node05_l = [[PathNode alloc] initWithPosition:[[Point2D alloc]
                                                           initWithX:mapOffset.x + 16.0f
                                                           y:mapOffset.y + 444.0f]
                                                     next:nodeEnd value:11];
    
	PathNode *node04_l = [[PathNode alloc] initWithPosition:[[Point2D alloc]
                                                           initWithX:mapOffset.x + 16.0f
                                                           y:mapOffset.y + 252.0f]
                                                     next:node05_l value:8];
    
	PathNode *node03_l = [[PathNode alloc] initWithPosition:[[Point2D alloc]
                                                           initWithX:mapOffset.x + 112.0f
                                                           y:mapOffset.y + 252.0f]
                                                      next:node04_l value:6];
    
	PathNode *node02_l = [[PathNode alloc] initWithPosition:[[Point2D alloc]
                                                           initWithX:mapOffset.x + 112.0f
                                                           y:mapOffset.y + 124.0f]
                                                     next:node03_l value:4];
    
    [spawnNodes addObject:[[PathNode alloc] initWithPosition:[[Point2D alloc]
                                                              initWithX:-20.0f
                                                              y:mapOffset.y + 124.0f]
                                                        next:node02_l value:2]];
    
    
    PathNode *node07_r = [[PathNode alloc] initWithPosition:[[Point2D alloc]
                                                           initWithX:mapOffset.x + 144.0f
                                                           y:mapOffset.y + 444.0f]
                                                     next:nodeEnd value:12];
    
    PathNode *node06_r = [[PathNode alloc] initWithPosition:[[Point2D alloc]
                                                           initWithX:mapOffset.x + 144.0f
                                                           y:mapOffset.y + 348.0f]
                                                     next:node07_r value:10];
    
    PathNode *node05_r = [[PathNode alloc] initWithPosition:[[Point2D alloc]
                                                           initWithX:mapOffset.x + 304.0f
                                                           y:mapOffset.y + 348.0f]
                                                     next:node06_r value:9];
    
    PathNode *node04_r = [[PathNode alloc] initWithPosition:[[Point2D alloc]
                                                           initWithX:mapOffset.x + 304.0f
                                                           y:mapOffset.y + 252.0f]
                                                     next:node05_r value:7];
    
    PathNode *node03_r = [[PathNode alloc] initWithPosition:[[Point2D alloc]
                                                           initWithX:mapOffset.x + 208.0f
                                                           y:mapOffset.y + 252.0f]
                                                     next:node04_r value:5];
    
    PathNode *node02_r = [[PathNode alloc] initWithPosition:[[Point2D alloc]
                                                           initWithX:mapOffset.x + 208.0f
                                                           y:mapOffset.y + 124.0f]
                                                     next:node03_r value:3];
    
    [spawnNodes addObject:[[PathNode alloc] initWithPosition:[[Point2D alloc]
                                                              initWithX:mapOffset.x + 340.0f
                                                              y:mapOffset.y + 124.0f]
                                                        next:node02_r value:1]];
}
@end
