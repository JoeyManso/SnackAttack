//
//  EnemySpawner.m
//  towerDefense
//
//  Created by Joey Manso on 8/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import "EnemySpawner.h"
#import "Enemies.h"
#import "Round.h"

// private stuff
static float spawnDelay = 1.5f; // time between enemy spawns
static float lastSpawnTime; // time at last spawn
static Round *currentRoundInfo;
static SpriteSheet *chubbySpriteSheet; // sprite sheet shared by all chubbies
static SpriteSheet *jeanieSpriteSheet; // sprite sheet shared by all jeanies
static SpriteSheet *lankySpriteSheet; // sprite sheet shared by all lankies
static SpriteSheet *smartySpriteSheet; // sprite sheet shared by all smarties
static SpriteSheet *airplaneSpriteSheet; // sprite sheet shared by all paper airplanes
static SpriteSheet *bannerSpriteSheet; // you get the idea
static SpriteSheet *bandieSpriteSheet;
static SpriteSheet *cheerieSpriteSheet;
static SpriteSheet *punkieSpriteSheet;
static SpriteSheet *mascotSpriteSheet;
static SpriteSheet *queenieSpriteSheet;

@interface EnemySpawner()
@end

@implementation EnemySpawner

-(id)initWithPath:(id)p position:(Point2D*)pos next:(PathNode*)n;
{
	if(self = [super initWithPosition:pos next:n value:1])
	{
		lastSpawnTime = 0.0f;
		currentRoundInfo = nil;
		maxDelay = 0.0f;
		
		chubbySpriteSheet = [[SpriteSheet alloc] initWithImageName:@"chubbyWalkCycle.png" spriteWidth:32 spriteHeight:32 spacing:0 imageScale:1.0f];
		jeanieSpriteSheet = [[SpriteSheet alloc] initWithImageName:@"jeanieWalkCycle.png" spriteWidth:24 spriteHeight:24 spacing:0 imageScale:1.0f];
		lankySpriteSheet = [[SpriteSheet alloc] initWithImageName:@"lankyWalkCycle.png" spriteWidth:32 spriteHeight:32 spacing:0 imageScale:1.0f];
		smartySpriteSheet = [[SpriteSheet alloc] initWithImageName:@"smartyWalkCycle.png" spriteWidth:20 spriteHeight:20 spacing:0 imageScale:1.0f];
		airplaneSpriteSheet = [[SpriteSheet alloc] initWithImageName:@"paperAirplaneFlyCycle.png" spriteWidth:32 spriteHeight:32 spacing:0 imageScale:1.0f];
		bannerSpriteSheet = [[SpriteSheet alloc] initWithImageName:@"bannerFlyCycle.png" spriteWidth:32 spriteHeight:32 spacing:0 imageScale:1.0f];
		bandieSpriteSheet = [[SpriteSheet alloc] initWithImageName:@"bandieWalkCycle.png" spriteWidth:32 spriteHeight:32 spacing:0 imageScale:1.0f];
		cheerieSpriteSheet = [[SpriteSheet alloc] initWithImageName:@"cheerleaderWalkCycle.png" spriteWidth:32 spriteHeight:32 spacing:0 imageScale:1.0f];
		punkieSpriteSheet = [[SpriteSheet alloc] initWithImageName:@"punkWalkCycle.png" spriteWidth:32 spriteHeight:32 spacing:0 imageScale:1.0f];
		mascotSpriteSheet = [[SpriteSheet alloc] initWithImageName:@"mascotWalkCycle.png" spriteWidth:32 spriteHeight:32 spacing:0 imageScale:1.0f];
		queenieSpriteSheet = [[SpriteSheet alloc] initWithImageName:@"promQueenWalkCycle.png" spriteWidth:32 spriteHeight:32 spacing:0 imageScale:1.0f];
	}
	return self;
}

-(void)setCurrentRoundInfo:(Round*)r
{
	currentRoundInfo = r;
}
-(void)update:(float)deltaT
{
	if(currentRoundInfo)
	{
		if([GameObject getCurrentTime] - spawnDelay > lastSpawnTime)
		{
			Enemy *enemy = nil;
			float chooseEnemyRatio = RANDOM_0_TO_1();
			
			if([currentRoundInfo numChubbies] > 0 && chooseEnemyRatio < 0.09f)
			{
				enemy = [[Chubby alloc] initWithPosition:[[Point2D alloc] initWithX:nodePosition.x y:nodePosition.y] 
											 spriteSheet:chubbySpriteSheet targetNode:nextNode];
				[currentRoundInfo setNumChubbies:[currentRoundInfo numChubbies]-1];
			}
			else if([currentRoundInfo numJeanies] > 0 && chooseEnemyRatio < 0.18f)
			{
				enemy = [[Jeanie alloc] initWithPosition:[[Point2D alloc] initWithX:nodePosition.x y:nodePosition.y] 
											 spriteSheet:jeanieSpriteSheet targetNode:nextNode];
				[currentRoundInfo setNumJeanies:[currentRoundInfo numJeanies]-1];
			}
			else if([currentRoundInfo numLankies] > 0 && chooseEnemyRatio < 0.27f)
			{
				enemy = [[Lanky alloc] initWithPosition:[[Point2D alloc] initWithX:nodePosition.x y:nodePosition.y] 
											spriteSheet:lankySpriteSheet targetNode:nextNode];
				[currentRoundInfo setNumLankies:[currentRoundInfo numLankies]-1];
			}
			else if([currentRoundInfo numSmarties] > 0 && chooseEnemyRatio < 0.36f)
			{
				enemy = [[Smarty alloc] initWithPosition:[[Point2D alloc] initWithX:nodePosition.x y:nodePosition.y] 
											 spriteSheet:smartySpriteSheet targetNode:nextNode];
				[currentRoundInfo setNumSmarties:[currentRoundInfo numSmarties]-1];
			}
			else if([currentRoundInfo numAirplanes] > 0 && chooseEnemyRatio < 0.45f)
			{
				enemy = [[Airplane alloc] initWithPosition:[[Point2D alloc] initWithX:nodePosition.x y:nodePosition.y] 
											   spriteSheet:airplaneSpriteSheet targetNode:nextNode];
				[currentRoundInfo setNumAirplanes:[currentRoundInfo numAirplanes]-1];
			}
			else if([currentRoundInfo numBanners] > 0 && chooseEnemyRatio < 0.54f)
			{
				enemy = [[Banner alloc] initWithPosition:[[Point2D alloc] initWithX:nodePosition.x y:nodePosition.y] 
											 spriteSheet:bannerSpriteSheet targetNode:nextNode];
				[currentRoundInfo setNumBanners:[currentRoundInfo numBanners]-1];
			}
			else if([currentRoundInfo numBandies] > 0 && chooseEnemyRatio < 0.63f)
			{
				enemy = [[Bandie alloc] initWithPosition:[[Point2D alloc] initWithX:nodePosition.x y:nodePosition.y] 
											 spriteSheet:bandieSpriteSheet targetNode:nextNode];
				[currentRoundInfo setNumBandies:[currentRoundInfo numBandies]-1];
			}
			else if([currentRoundInfo numCheeries] > 0 && chooseEnemyRatio < 0.72f)
			{
				enemy = [[Cheerie alloc] initWithPosition:[[Point2D alloc] initWithX:nodePosition.x y:nodePosition.y] 
											  spriteSheet:cheerieSpriteSheet targetNode:nextNode];
				[currentRoundInfo setNumCheeries:[currentRoundInfo numCheeries]-1];
			}
			else if([currentRoundInfo numPunkies] > 0 && chooseEnemyRatio < 0.81f)
			{
				enemy = [[Punkie alloc] initWithPosition:[[Point2D alloc] initWithX:nodePosition.x y:nodePosition.y] 
											 spriteSheet:punkieSpriteSheet targetNode:nextNode];
				[currentRoundInfo setNumPunkies:[currentRoundInfo numPunkies]-1];
			}
			else if([currentRoundInfo numMascots] > 0 && chooseEnemyRatio < 0.9f)
			{
				enemy = [[Mascot alloc] initWithPosition:[[Point2D alloc] initWithX:nodePosition.x y:nodePosition.y] 
											 spriteSheet:mascotSpriteSheet targetNode:nextNode];
				[currentRoundInfo setNumMascots:[currentRoundInfo numMascots]-1];
			}
			else if([currentRoundInfo numQueenies] > 0)
			{
				enemy = [[Queenie alloc] initWithPosition:[[Point2D alloc] initWithX:nodePosition.x y:nodePosition.y] 
											  spriteSheet:queenieSpriteSheet targetNode:nextNode];
				[currentRoundInfo setNumQueenies:[currentRoundInfo numQueenies]-1];
			}
			
			if(enemy)
			{
				maxDelay = 0.7f/(0.01 * [enemy enemySpeed]);
				// remove our reference from the enemy
					
				lastSpawnTime = [GameObject getCurrentTime];
				spawnDelay = (RANDOM_0_TO_1() * maxDelay);
			}
		    [enemy release];
		}
	}
}
-(void)dealloc
{	
	// deallocate the sprite sheets
	[chubbySpriteSheet release];
	[jeanieSpriteSheet release];
	[lankySpriteSheet release];
	[smartySpriteSheet release];
	[airplaneSpriteSheet release];
	[bannerSpriteSheet release];
	[bandieSpriteSheet release];
	[cheerieSpriteSheet release];
	[punkieSpriteSheet release];
	[mascotSpriteSheet release];
	[queenieSpriteSheet release];
	[super dealloc];
}
@end
