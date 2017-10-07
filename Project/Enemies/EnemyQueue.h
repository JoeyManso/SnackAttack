//
//  EnemyQueue.h
//  towerDefense
//
//  Created by Joey Manso on 10/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

// this class creates a priority Queue for enemies

#import <Foundation/Foundation.h>

@class Enemy;
@class Vector2D;
@class Point2D;

@interface EnemyQueue : NSObject 
{
	@private
	NSMutableArray *priorityQueue;
	Vector2D *dirEnemy1ToEnemy2;
}
-(void)addEnemy:(Enemy*)e;
-(void)removeEnemy:(Enemy*)e;
-(void)removeAllEnemies;
-(Enemy*)getClosestEnemyFromPoint:(Point2D*)p radius:(float)r towerType:(uint)tt projectileType:(uint)pt;
-(void)sort;

@end
