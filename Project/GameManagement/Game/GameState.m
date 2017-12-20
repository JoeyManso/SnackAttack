//
//  GameState.m
//  towerDefense
//
//  Created by Joey Manso on 7/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GameState.h"
#import "SoundManager.h"
#import "ViewManager.h"
#import "UIManager.h"
#import "UIBars.h"

#import "Tower.h"
#import "Enemy.h"
#import "EnemyQueue.h"
#import "Map.h"

static const float GAME_SPEED_MIN = 0.5f;
static const float GAME_SPEED_MAX = 4.0f;
static UIManager *UIMan;
static SoundManager *soundMan;
static GameStatus *statusBar;
static EnemyQueue *enemyQueue;

// private stuff
@interface GameState()
{

}
-(void)setBeginningStats;
-(void)findEnemies;
-(void)checkCollisions;
-(void)updateAllObjects:(float)deltaTime;
-(BOOL)allEnemiesAreRemoved;
@end

@implementation GameState

@synthesize currentlyBoundTexture;
@synthesize currentScore;
@synthesize currentLives;
@synthesize currentCash;
@synthesize currentRound;
@synthesize gameSpeed;
@synthesize time;
@synthesize paused;

const int STARTING_CASH = 200;
const int STARTING_LIVES = 25;
const int MAX_SORT_COUNT = 15; // sort every time this count is reached
const float NEXT_ROUND_BUFFER = 1.5f; // time before next round starts after all enemies are removed from map

-(id)init
{
	if(self = [super init])
	{
		debug = enemiesOnMap = paused = NO;
		bonusToApply = enemiesDefeatedThisRound = 0;
		gameObjects = [[NSMutableArray alloc] init];
		addQueue = [[NSMutableArray alloc] init];
		removeQueue = [[NSMutableArray alloc] init];
		registerPoints = [[NSMutableArray alloc] init];
		enemyQueue = [[EnemyQueue alloc] init];
		sortCounter = 0;
		roundBuffer = 0.0f;
        gameSpeed = 1.0f;
		
		[self setBeginningStats];
	}
	return self;
}
+(GameState*)sharedGameStateInstance
{
	// return a singleton
	static GameState *sharedGameStateInstance;
	
	// lock the class (for multithreading!)
	@synchronized(self)
	{
		if(!sharedGameStateInstance)
		{
			sharedGameStateInstance = [[GameState alloc] init];
			// put this here to avoid static initialization errors
			soundMan = [SoundManager getInstance];
			[soundMan loadAllSounds];
			UIMan = [UIManager getInstance];
			statusBar = [UIMan getGameStatBarReference];
			// initialize status bar values
			[statusBar setRound:sharedGameStateInstance.currentRound+1];
			[statusBar setLives:sharedGameStateInstance.currentLives];
			[statusBar setCash:sharedGameStateInstance.currentCash];
			[statusBar setScore:sharedGameStateInstance.currentScore];
            [statusBar setGameSpeed:sharedGameStateInstance.gameSpeed];
		}
	}
	
	return sharedGameStateInstance;
}
-(BOOL)debugMode
{
	return debug;
}
-(void)addObject:(GameObject*)o
{
	[addQueue addObject:o];
}
-(void)removeObject:(GameObject*)o
{
	// add this object to the queue for removal
	[removeQueue addObject:o];
}
-(GameObject*)findObjectAtPosition:(CGPoint)p
{	
	// while our selected object does not become nil
	GameObject *touchedObject = nil;
	if(!paused)
	{
		for(GameObject *o in gameObjects)
		{
			// exit the loop as soon as we find an object
			if([o isTouchedAtPoint:p])
			{
				touchedObject = o;
			}
		}
	}
	return touchedObject;
}
-(BOOL)pointIsWithinTower:(Point2D*)p
{
	for(Tower *t in gameObjects)
	{
		if([t isKindOfClass:[Tower class]])
		{
			if(![t canBeMoved] && CGRectContainsPoint([t getObjectHitBox], CGPointMake(p.x, p.y)))
				return YES;
		}
	}
	return NO;
}

-(void)update:(float)deltaTime
{
    deltaTime *= gameSpeed;
	if(!paused)
	{		
		[self updateAllObjects:deltaTime];
		if(enemiesOnMap)
		{
			[self findEnemies];
			[self checkCollisions];
		}
		
		// if it's not empty, add what's in the add queue and remove it from the queue
		if([addQueue count] > 0)
		{
			for(Enemy *e in addQueue)
			{
				if([e isKindOfClass:[Enemy class]])
				{
					[enemyQueue addEnemy:e];
					if(currentRound > 20 && currentRound <= 25)
						[e multiplyMaxHitPoints:2];
					else if(currentRound > 25)
						[e multiplyMaxHitPoints:3];
				}
			}
			[gameObjects addObjectsFromArray:addQueue];
			[addQueue removeAllObjects];
		}
		// if we need to delete an object, dealloc it and remove all references
		if([removeQueue count] > 0)
		{
			// as long as there are no more references to the object, this will deallocate it
			for(GameObject *o in removeQueue)
			{
				[[TouchManager getInstance] objectHasBeenRemoved:o];
				[gameObjects removeObject:o];
				if([o isKindOfClass:[Enemy class]])
				{
					[enemyQueue removeEnemy:(Enemy*)o];
					if([self allEnemiesAreRemoved])
					{
						enemiesOnMap = NO;
						roundBuffer = NEXT_ROUND_BUFFER;
					}
				}
				
			}
			
			[removeQueue removeAllObjects];
		}
		if(roundBuffer > 0)
			roundBuffer -= deltaTime;
		else if(roundBuffer < 0.0f)
		{
			roundBuffer = 0.0f;
			[self goToNextRound];
		}
		
		if(sortCounter > MAX_SORT_COUNT)
		{
			[enemyQueue sort];
			sortCounter = 0;
		}
		++sortCounter;
	}
}
-(void)findEnemies
{
	for(Tower *tower in gameObjects)
	{
		// check if towers should shoot at enemies
		if([tower isKindOfClass:[Tower class]])
		{
			// check if the tower has the option to shoot
			if([tower canShoot])
			{
				// look for enemies in range
				Enemy *enemy = [enemyQueue getClosestEnemyFromPoint:[tower objectPosition] radius:[tower towerRange] towerType:[tower towerType] 
													 projectileType:[tower projectileType]];
				if(enemy)
				{	
					if([tower targetGameObject:enemy])
					{
						[tower shoot];
						// done shooting, break out of this loop
						break;
					}		
				}
			}
		}
	}
}

-(void)checkCollisions
{
	// this checks all projectiles against all enemies
	for(Projectile *projectile in gameObjects)
	{
		if([projectile isKindOfClass:[Projectile class]])
		{
			for(Enemy *enemy in gameObjects)
			{
				if([enemy isKindOfClass:[Enemy class]] && [projectile towerType] >= [enemy enemyType] && [enemy enemyImmunity] != [projectile projectileType])
				{
					if([enemy enemyHitPoints] >= 1 && 
					   CGRectContainsPoint([enemy getObjectHitBox], CGPointMake([projectile objectPosition].x, [projectile objectPosition].y)))
					{
						// give the projectile a reference to the enemy to appy damage and any potential effects
						[projectile hasCollided:enemy];
						// we hit an enemy, break out for this projectile
						break;
					}
				}
			}
		}
		
	}
}
-(void)upgradeSelectedTower
{
	for(Tower *tower in gameObjects)
	{
		// check if towers should shoot at enemies
		if([tower isKindOfClass:[Tower class]] && [tower selected])
		{
			[tower upgrade];
		}
	}
}
-(void)sellSelectedTower
{
	for(Tower *tower in gameObjects)
	{
		// check if towers should shoot at enemies
		if([tower isKindOfClass:[Tower class]] && [tower selected])
		{
			[tower sell];
		}
	}
}

-(void)damageEnemiesInRadius:(float)radius origin:(Point2D*)originPoint damage:(float)damage damageType:(uint)type
{
	for(Enemy *enemy in gameObjects)
	{
		if([enemy isKindOfClass:[Enemy class]] && [enemy enemyType] != AIR && [enemy enemyImmunity] != type)
		{
			if([Math distance:originPoint :enemy.objectPosition] <= radius)
				[enemy takeDamage:damage];
		}
	}
}
-(void)freezeEnemiesInRadius:(float)radius origin:(Point2D*)originPoint duration:(float)duration
{
	for(Enemy *enemy in gameObjects)
	{
		if([enemy isKindOfClass:[Enemy class]] && [enemy enemyType] != AIR && [enemy enemyImmunity] != FREEZE)
		{
			if([Math distance:originPoint :enemy.objectPosition] <= radius)
				[enemy freeze:duration];
		}
	}
}
-(void)showBoostForTowersFromPoint:(Point2D*)originPoint
{
	for(Tower *t in gameObjects)
	{
		if([t isKindOfClass:[Tower class]])
		{
			if([Math distance:originPoint :t.objectPosition] <= RG_RANGE)
				[t setIsInBoostRadius:YES];
			else
				[t setIsInBoostRadius:NO];
		}
	}
}
-(void)applyBoostForTowersFromPoint:(Point2D*)originPoint
{
	for(Tower *t in gameObjects)
	{
		if([t isKindOfClass:[Tower class]])
		{
			if([Math distance:originPoint :t.objectPosition] <= RG_RANGE)
			{
				[t setIsInBoostRadius:YES];
				[t applyBoostDamage];;
			}
			else
				[t setIsInBoostRadius:NO];
		}
	}
	[registerPoints addObject:originPoint];
}
-(void)removeBoostForTowersFromPoint:(Point2D*)originPoint
{
	[registerPoints removeObject:originPoint];
	for(Tower *t in gameObjects)
	{
		if([t isKindOfClass:[Tower class]])
		{
			if([Math distance:originPoint :t.objectPosition] <= RG_RANGE)
				[t removeBoost];
		}
	}
}
-(void)messageScreenHasFinished
{
	paused = NO;
	[self alterCash:bonusToApply];
	[statusBar setRound:++currentRound];
	[UIMan roundHasFinished:currentRound currentCash:currentCash];
}
-(BOOL)isBoostTowerInRange:(Point2D*)startPoint
{
	for(Point2D *p in registerPoints)
		if([Math distance:startPoint :p] < RG_RANGE)
			return YES;
	return NO;
}
-(BOOL)allEnemiesAreRemoved
{
	for(Enemy *e in gameObjects)
		if([e isKindOfClass:[Enemy class]])
			return NO;
	return YES;
}
-(void)draw
{
	for(GameObject *o in gameObjects)
		[o draw];
}
-(void)updateAllObjects:(float)deltaTime
{
	for(GameObject *o in gameObjects)
		[o update:deltaTime];
	time += deltaTime;
}
-(void)setMap:(Map*)m
{
	currentMap = m;
}
-(void)goToNextRound
{
	enemiesOnMap = YES;
	uint numberOfEnemiesThisRound;
	// special case for the first round (start button)
	if(currentRound == 0)
	{
		currentRoundInfo = [currentMap getFirstRound];
		[statusBar setRound:++currentRound];
	}
	else
	{			
		[soundMan playSoundWithKey:@"RoundOver" gain:1.0f pitch:1.0f shouldLoop:NO];
		numberOfEnemiesThisRound = [currentRoundInfo numTotalEnemies];
		[UIMan showMessageScreenWithRound:currentRound numEnemiesDefeated:enemiesDefeatedThisRound numEnemiesTotal:numberOfEnemiesThisRound
						   maxBonusAmount:[currentRoundInfo roundBonus] message1:[currentRoundInfo messageLine1] message2:[currentRoundInfo messageLine2] 
								 message3:[currentRoundInfo messageLine3]];
		float bonusPercent;
		if([currentRoundInfo numTotalEnemies] == 0)
			bonusPercent = 0.0f;
		else
			bonusPercent = (float)enemiesDefeatedThisRound/(float)[currentRoundInfo numTotalEnemies];
		bonusToApply = (uint)(bonusPercent * (float)[currentRoundInfo roundBonus]);
		currentRoundInfo = [currentMap getNextRound];
		paused = YES;
	}
	if(!currentRoundInfo)
	{
		[soundMan playSoundWithKey:@"GameWin" gain:1.0f pitch:1.0f shouldLoop:NO];
		[UIMan swapRoundWithReset:[[Image alloc] initWithImage:[UIImage imageNamed:@"ButtonMainMenu.png"] filter:GL_LINEAR]];
		// that was the last round, display win information and reset game
		[UIMan showMessageScreenWithRound:currentRound numEnemiesDefeated:enemiesDefeatedThisRound numEnemiesTotal:numberOfEnemiesThisRound 
						   maxBonusAmount:0 message1:@"Congratulations! You've" 
								 message2:[NSString stringWithFormat:@"won, defeating %u enemies",currentScore] 
								 message3:[NSString stringWithFormat:@"with %u lives remaining!",currentLives]];
	}
	enemiesDefeatedThisRound = 0;
}
-(void)showMenu
{
	[[ViewManager getInstance] showMainMenu];
}
-(void)showMenuEndGame
{
	[[ViewManager getInstance] showMainMenuDeactivateResume];
}
-(void)subtractLife
{
	if(currentLives > 0)
	{
		[soundMan playSoundWithKey:@"EnemyEscape" gain:0.2f pitch:0.75f shouldLoop:NO];
		[statusBar setLives:--currentLives];
	}
	// check if we've lost all lives, if so, we lose!
	if(currentLives == 0)
	{
		[soundMan playSoundWithKey:@"GameLoss" gain:1.0f pitch:1.0f shouldLoop:NO];
		[UIMan swapRoundWithReset:[[Image alloc] initWithImage:[UIImage imageNamed:@"ButtonMainMenu.png"] filter:GL_LINEAR]];
		// player lost, display special message screen
		[UIMan showMessageCustomTitle:[NSString stringWithFormat:@"Failed on Round %u",currentRound] numEnemiesDefeated:enemiesDefeatedThisRound 
					  numEnemiesTotal:[currentRoundInfo numTotalEnemies] maxBonusAmount:0 message1:@"Game Over! You let" message2:@"too many enemies through." 
							 message3:@"Way to fail!"];
		paused = YES;
	}
}
-(void)pause
{
	paused = YES;
}
-(void)unpause
{
    paused = NO;
}
-(void)speedDown
{
    gameSpeed = MAX(gameSpeed / 2.0f, GAME_SPEED_MIN);
    [[UIMan getGameStatBarReference] setGameSpeed:gameSpeed];
}
-(void)speedUp
{
    gameSpeed = MIN(gameSpeed * 2.0f, GAME_SPEED_MAX);
    [[UIMan getGameStatBarReference] setGameSpeed:gameSpeed];
}
-(void)alterCash:(int)deltaCash
{
	[statusBar setCash:currentCash+=deltaCash];
	[UIMan cashHasChanged:currentCash];
}
-(void)enemyDefeated:(uint)enemyValue
{
	++enemiesDefeatedThisRound;
	++currentScore;
	[statusBar setScore:currentScore];
	[self alterCash:enemyValue];
}
-(void)setBeginningStats
{
	time = 0.0f;
	roundBuffer = 0.0f;
	currentCash = STARTING_CASH;
	currentScore = 0;
	currentRound = 0;
	currentLives = STARTING_LIVES;
	enemiesOnMap = NO;
	paused = NO;
	enemiesDefeatedThisRound = 0;
}

-(void)resetGame
{
	[self setBeginningStats];
	[currentMap resetRounds];
	currentRoundInfo = nil;
	[statusBar setRound:currentRound+1];
	[statusBar setLives:currentLives];
	[statusBar setCash:currentCash];
	[statusBar setScore:currentScore];
	[UIMan resetGame];
	[gameObjects removeAllObjects];
	[enemyQueue removeAllEnemies];
}

-(void)dealloc
{
	// this deletes all objects as long as this is the only remaining reference to them
	[gameObjects removeAllObjects];
	[gameObjects release];
	[enemyQueue dealloc];
	[registerPoints removeAllObjects];
	[registerPoints release];
	[addQueue release];
	[removeQueue release];
	[super dealloc];
}

@end
