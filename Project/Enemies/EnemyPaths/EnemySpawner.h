//
//  EnemySpawner.h
//  towerDefense
//
//  Created by Joey Manso on 8/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PathNode.h"

@class Round;

@interface EnemySpawner : PathNode 
{
	float maxDelay; // maximum time between enemy spawns
}
-(id)initWithPath:(id)p position:(Point2D*)pos next:(PathNode*)n;
-(void)setCurrentRoundInfo:(Round*)r;
-(void)update:(float)deltaT;

@end
