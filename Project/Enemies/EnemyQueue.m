//
//  EnemyQueue.m
//  towerDefense
//
//  Created by Joey Manso on 10/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "EnemyQueue.h"
#import "Enemy.h"

@interface EnemyQueue()

-(BOOL)shouldSwapEnemy1:(Enemy*)e1 Enemy2:(Enemy*)e2;

@end

@implementation EnemyQueue

-(id)init
{
	if(self = [super init])
	{
		priorityQueue = [[NSMutableArray alloc] init];
		dirEnemy1ToEnemy2 = [[Vector2D alloc] init];
	}
	return self;
}
-(void)addEnemy:(Enemy*)e
{
	[priorityQueue addObject:e];
	[self sort];
}
-(void)removeEnemy:(Enemy*)e
{
	[priorityQueue removeObject:e];
}
-(void)removeAllEnemies
{
	[priorityQueue removeAllObjects];
}
-(Enemy*)getClosestEnemyFromPoint:(Point2D*)p radius:(float)r towerType:(uint)tt projectileType:(uint)pt
{
	 Enemy *enemyWithKernel = nil;
	for(Enemy *e in priorityQueue)
	{
		if(tt >= [e enemyType] && pt != [e enemyImmunity] && [Math distance:p :[e objectPosition]] <= r)
		{
			if(enemyWithKernel == nil && pt == KERNEL && [e kernelCount] > 0)
			{
				enemyWithKernel = e;
			}
			else
				return e;
		}
	}
	if(enemyWithKernel)
		return enemyWithKernel;
	return nil;
}
-(BOOL)shouldSwapEnemy1:(Enemy*)e1 Enemy2:(Enemy*)e2
{
	// checks if enemy1 should be a higher priority than enemy2
	if([e1 getTargetNodeValue] > [e2 getTargetNodeValue])
		return YES;
	if([e1 getTargetNodeValue] == [e2 getTargetNodeValue])
	{
		// dot product to see if enemy1 is ahead of enemy2
		[dirEnemy1ToEnemy2 setToPointSubtraction:[e2 objectPosition] :[e1 objectPosition]];
		if([Vector2D dot:dirEnemy1ToEnemy2 :[e1 objectDirection]] < 0) // e1 ahead of e2
			return YES;
	}
	return NO;
}
-(void)sort
{
	for(int i=0; i<[priorityQueue count]; ++i)
	{
		for(int j=0; j<[priorityQueue count]; ++j)
		{
			Enemy *e1 = [priorityQueue objectAtIndex:i];
			Enemy *e2 = [priorityQueue objectAtIndex:j];
			if(j < i && [self shouldSwapEnemy1:e1 Enemy2:e2])
			{
				[priorityQueue exchangeObjectAtIndex:i withObjectAtIndex:j];
				j--;
			}
		}
	}
}
-(void)dealloc
{
	[dirEnemy1ToEnemy2 dealloc];
	[priorityQueue removeAllObjects];
	[priorityQueue release];
	[super dealloc];
}

@end
