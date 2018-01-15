//
//  Map1.m
//  towerDefense
//
//  Created by Joey Manso on 7/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Map1.h"
#import "BaseView.h"

@implementation Map1

-(id)init
{
    if(self = [super init])
    {
        [self initMap:@"map1.png" tiledFile:@"Map1TileMap"];
    }
    return self;
}

-(void)initRounds
{
    [super initRounds];
    
	// declare our nodes backwards
	PathNode *node11 = [[PathNode alloc] initWithPosition:[[Point2D alloc]
                                                           initWithX:mapOffset.x - 20.0f
                                                           y:mapOffset.y + 412.0f]
                                                     next:nil value:11];
    
	PathNode *node10 = [[PathNode alloc] initWithPosition:[[Point2D alloc]
                                                           initWithX:mapOffset.x + 112.0f
                                                           y:mapOffset.y + 412.0f]
                                                     next:node11 value:10];
    
	PathNode *node09 = [[PathNode alloc] initWithPosition:[[Point2D alloc]
                                                           initWithX:mapOffset.x + 112.0f
                                                           y:mapOffset.y + 444.0f]
                                                     next:node10 value:9];
    
	PathNode *node08 = [[PathNode alloc] initWithPosition:[[Point2D alloc]
                                                           initWithX:mapOffset.x + 304.0f
                                                           y:mapOffset.y + 444.0f]
                                                     next:node09 value:8];
    
	PathNode *node07 = [[PathNode alloc] initWithPosition:[[Point2D alloc]
                                                           initWithX:mapOffset.x + 304.0f
                                                           y:mapOffset.y + 220.0f]
                                                     next:node08 value:7];
    
	PathNode *node06 = [[PathNode alloc] initWithPosition:[[Point2D alloc]
                                                           initWithX:mapOffset.x + 176.0f
                                                           y:mapOffset.y + 220.0f]
                                                     next:node07 value:6];
    
	PathNode *node05 = [[PathNode alloc] initWithPosition:[[Point2D alloc]
                                                           initWithX:mapOffset.x + 176.0f
                                                           y:mapOffset.y + 284.0f]
                                                     next:node06 value:5];
    
	PathNode *node04 = [[PathNode alloc] initWithPosition:[[Point2D alloc]
                                                           initWithX:mapOffset.x + 16.0f
                                                           y:mapOffset.y + 284.0f]
                                                     next:node05 value:4];
    
	PathNode *node03 = [[PathNode alloc] initWithPosition:[[Point2D alloc]
                                                           initWithX:mapOffset.x + 16.0f
                                                           y:mapOffset.y + 124.0f]
                                                      next:node04 value:3];
    
	PathNode *node02 = [[PathNode alloc] initWithPosition:[[Point2D alloc]
                                                           initWithX:mapOffset.x + 240.0f
                                                           y:mapOffset.y + 124.0f]
                                                     next:node03 value:2];
    
    [spawnNodes addObject:[[PathNode alloc] initWithPosition:[[Point2D alloc]
                                                              initWithX:mapOffset.x + 240.0f
                                                              y:-20.0f]
                                                        next:node02 value:1]];
}
@end
